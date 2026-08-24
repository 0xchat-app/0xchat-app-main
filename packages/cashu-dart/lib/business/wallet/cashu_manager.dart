
import 'dart:async';

import 'package:cashu_dart/model/unblinding_data_isar.dart';

import '../../core/nuts/token/proof.dart';
import '../../core/nuts/token/proof_isar.dart';
import '../../model/db_config_isar.dart';
import '../../model/history_entry.dart';
import '../../model/history_entry_isar.dart';
import '../../model/invoice.dart';
import '../../model/invoice_isar.dart';
import '../../model/invoice_listener.dart';
import '../../model/keyset_info.dart';
import '../../model/keyset_info_isar.dart';
import '../../model/lightning_invoice.dart';
import '../../model/lightning_invoice_isar.dart';
import '../../model/mint_info.dart';
import '../../model/mint_info_isar.dart';
import '../../model/mint_model.dart';
import '../../model/mint_model_isar.dart';
import '../../model/unblinding_data.dart';
import '../../utils/database/db.dart';
import '../../utils/database/db_isar.dart';
import '../../utils/database/db_migrate_helper.dart';
import '../../utils/isolate_worker.dart';
import '../../utils/log_util.dart';
import '../mint/mint_helper.dart';
import '../mint/mint_info_store.dart';
import '../mint/mint_store.dart';
import '../proof/proof_helper.dart';
import 'proof_blinding_manager.dart';
import 'invoice_handler.dart';

typedef SignWithKeyFunction = Future<String> Function(String pubkey, String message);

class CashuManager {
  static final CashuManager shared = CashuManager._internal();
  CashuManager._internal();

  List<String>? defaultMint;

  final List<IMintIsar> mints = [];
  final Set<String> mintURLQueue = {};
  InvoiceHandler invoiceHandler = InvoiceHandler();
  final List<CashuListener> _listeners = [];

  Completer setupFinish = Completer();

  static const int dbVersion = 5;
  String dbNameWithIdentify(String identify) => 'cashu-$identify.db';

  String Function()? defaultSignPubkey;
  SignWithKeyFunction? signFn;

  Future<void> setup(String identify, {
    String? dbPassword,
    List<String>? defaultMint,
  }) async {
    try {
      await clean();
      this.defaultMint = defaultMint;
      await setupDB(dbName: identify, dbPassword: dbPassword);
      await setupMint();
      await setupBalance();
      await ProofHelper.tryParseProofsToNewestVersion();
      await invoiceHandler.initialize();
      await ProofBlindingManager.shared.initialize();
      await IsolateWorker.cashuWorker.init();
      invoiceHandler.invoiceOnPaidCallback = notifyListenerForPaidSuccess;
      setupFinish.complete();
      LogUtils.i(() => '[Cashu - setup] Finished');
    } catch (e, stack) {
      LogUtils.e(() => '[Cashu - setup] $e');
      LogUtils.e(() => '[Cashu - setup] stack: $stack');
    }
  }

  Future changeDBPassword(String identify, String newPassword) async {
    if (!await CashuDB.sharedInstance.isExistsDB(dbNameWithIdentify(identify))) return;
    await CashuDB.sharedInstance.execute("PRAGMA rekey = '$newPassword'");
    await CashuDB.sharedInstance.closeDatabase();
    await CashuDB.sharedInstance.open(
      dbNameWithIdentify(identify),
      version: dbVersion,
      password: newPassword,
    );
  }

  Future<void> clean() async {
    setupFinish = Completer();
    await CashuDB.sharedInstance.closeDatabase();
    mints.clear();
    invoiceHandler.dispose();
    ProofBlindingManager.shared.dispose();
  }

  Future<void> setupDB({
    String dbName = 'default',
    String? dbPassword,
  }) async {
    await Future.wait([
      _openSQLiteDB(
        dbName: dbName,
        dbPassword: dbPassword,
      ),
      _openIsarDB(
        dbName: dbName,
      ),
    ]);

    if (await CashuDB.sharedInstance.isExistsDB(dbNameWithIdentify(dbName))) {
      await DBMigrateHelper.trySqliteToIsar();
      await CashuDB.sharedInstance.db.close();
    }
  }

  Future<void> _openSQLiteDB({
    String dbName = 'default',
    String? dbPassword,
  }) async {
    if (!await CashuDB.sharedInstance.isExistsDB(dbNameWithIdentify(dbName))) return;
    CashuDB.sharedInstance.schemes = [
      KeysetInfo,
      Proof,
      IHistoryEntry,
      IInvoice,
      LightningInvoice,
      MintInfo,
      IMint,
      UnblindingData,
    ];
    await CashuDB.sharedInstance.open(
      dbNameWithIdentify(dbName),
      version: dbVersion,
      password: dbPassword,
    );
  }

  Future<void> _openIsarDB({
    String dbName = 'default',
  }) async {
    CashuIsarDB.shared.schemas = [
      ProofIsarSchema,
      IHistoryEntryIsarSchema,
      IInvoiceIsarSchema,
      KeysetInfoIsarSchema,
      LightningInvoiceIsarSchema,
      MintInfoIsarSchema,
      IMintIsarSchema,
      UnblindingDataIsarSchema,
      DBConfigIsarSchema,
    ];
    await CashuIsarDB.shared.open('cashu-$dbName');
  }

  Future<void> setupMint() async {
    try {
      List<IMintIsar> dbMints = await MintStore.getMints();
      if (dbMints.isEmpty) {
        dbMints = await _addDefaultMint();
      }
      await _initializeMints(dbMints);
    } catch (e) {
      LogUtils.e(() => '[E][Cashu - setupMint] $e');
    }
  }

  Future<List<IMintIsar>> _addDefaultMint() async {
    defaultMint ??= ['https://testnut.cashu.space'];
    final result = <IMintIsar>[];
    for (final mintURL in defaultMint!) {
      final mint = IMintIsar(mintURL: mintURL, maxNutsVersion: 1);
      await MintStore.addMints([mint]);
      result.add(mint);
    }
    return result;
  }

  Future<void> _initializeMints(List<IMintIsar> dbMints) async {
    for (IMintIsar mint in dbMints) {
      await _setupMintInfo(mint);
      await _setupMintKeyset(mint);
      mints.add(mint);
    }
  }

  Future<void> _setupMintInfo(IMintIsar mint) async {
    final info = await MintInfoStore.getMintInfo(mint.mintURL);
    if (info != null) {
      mint.info = info;
    }
  }

  Future<void> _setupMintKeyset(IMintIsar mint) async {
    await MintHelper.updateMintKeysetFromLocal(mint);
  }

  Future<void> setupBalance() async {
    for (IMintIsar mint in mints) {
      await updateMintBalance(mint);
    }
  }

  Future<IMintIsar?> getMint(String mintURL) async {
    final url = MintHelper.getMintURL(mintURL);
    for (IMintIsar mint in mints) {
      if (mint.mintURL == url) {
        return mint;
      }
    }
    try {
      return addMint(mintURL);
    } catch (_) {
      return null;
    }
  }

  Future<IMintIsar?> addMint(String mintURL) async {

    final url = MintHelper.getMintURL(mintURL);

    if (mints.any((element) => element.mintURL == url)) {
      return null;
    }

    if (!mintURLQueue.add(url)) return null;

    final maxNutsVersion = await MintHelper.getMaxNutsVersion(url);

    final mint = IMintIsar(mintURL: url, maxNutsVersion: maxNutsVersion);

    final fetchSuccess = await MintHelper.updateMintInfoFromRemote(mint);
    if (!fetchSuccess) {
      mintURLQueue.remove(url);
      return null;
    }
    mint.name = mint.info?.name ?? mint.info?.mintURL ?? '';

    mints.add(mint);
    mintURLQueue.remove(url);
    MintHelper.updateMintKeysetFromRemote(mint);
    notifyListenerForMintListChanged();
    return mint;
  }

  Future<bool> updateMintName(IMintIsar mint) async {
    final index = mints.indexWhere((element) => element.mintURL == mint.mintURL);
    if (index < 0) {
      return false;
    }
    mints[index].name = mint.name;
    return await MintStore.updateMint(mint);
  }

  Future updateMintBalance([IMintIsar? mint]) async {
    final mints = this.mints.where((element) => mint == null || element.mintURL == mint.mintURL);
    if (mints.isEmpty) {
      return false;
    }

    for (var mint in mints) {
      var total = 0;
      final proofs = await ProofHelper.getProofs(mint.mintURL);
      for (final proof in proofs) {
        total += proof.amountNum;
      }
      if (mint.balance != total) {
        mint.balance = total;
        notifyListenerForBalanceChanged(mint);
      }
    }
  }

  Future<bool> deleteMint(IMintIsar mint) async {
    try {
      final target = mints.firstWhere((element) => element.mintURL == mint.mintURL);
      mints.remove(target);
      return await MintStore.deleteMint(target.mintURL);
    } catch (_) {
      return false;
    }
  }

  void addListener(CashuListener listener) {
    _listeners.add(listener);
  }

  void removeListener(CashuListener listener) {
    _listeners.remove(listener);
  }

  void notifyListenerForPaidSuccess(Receipt receipt) {
    for (var e in _listeners) {
      e.handleInvoicePaid(receipt);
    }
  }

  void notifyListenerForBalanceChanged(IMintIsar mint) {
    for (var e in _listeners) {
      e.handleBalanceChanged(mint);
    }
  }

  void notifyListenerForMintListChanged() {
    for (var e in _listeners) {
      e.handleMintListChanged(mints);
    }
  }

  void notifyListenerForPaymentCompleted(String paymentKey) {
    for (var e in _listeners) {
      e.handlePaymentCompleted(paymentKey);
    }
  }

  void notifyListenerForHistoryChanged() {
    for (var e in _listeners) {
      e.handleHistoryChanged();
    }
  }
}
