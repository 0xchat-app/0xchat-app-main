import 'dart:convert';

import '../../core/nuts/token/proof.dart';
import '../../core/nuts/token/proof_isar.dart';
import '../../model/history_entry.dart';
import '../../model/history_entry_isar.dart';
import '../../model/invoice.dart';
import '../../model/invoice_isar.dart';
import '../../model/keyset_info.dart';
import '../../model/keyset_info_isar.dart';
import '../../model/lightning_invoice.dart';
import '../../model/lightning_invoice_isar.dart';
import '../../model/mint_info.dart';
import '../../model/mint_info_isar.dart';
import '../../model/mint_model.dart';
import '../../model/mint_model_isar.dart';
import '../../model/unblinding_data.dart';
import '../../model/unblinding_data_isar.dart';
import 'db.dart';
import 'db_config_helper.dart';
import 'db_isar.dart';

class DBMigrateHelper {

  static Future<void> trySqliteToIsar() async {
    if (await DBConfigHelper.isSqliteToIsarFinish()) return ;

    final migrationMethods = [
      _proofMigrateToIsar,
      _historyMigrateToIsar,
      _invoiceMigrateToIsar,
      _mintMigrateToIsar,
      _mintInfoMigrateToIsar,
      _keysetInfoMigrateToIsar,
      _lightningInvoiceMigrateToIsar,
      _unblindingDataMigrateToIsar,
    ];

    for (var method in migrationMethods) {
      try {
        await method();
      } catch (_) {}
    }

    await DBConfigHelper.setSqliteToIsarFinish();
  }

  static Future<void> _proofMigrateToIsar() async {
    List<Proof> proofs = await CashuDB.sharedInstance.objects<Proof>();
    List<ProofIsar> proofsISAR = proofs.map((proof) => ProofIsar(
      keysetId: proof.id,
      amount: proof.amount,
      secret: proof.secret,
      C: proof.C,
      dleqPlainText: proof.dleqPlainText,
    )).toList();
    await CashuIsarDB.putAll<ProofIsar>(proofsISAR);
  }

  static Future<void> _historyMigrateToIsar() async {
    List<IHistoryEntry> historyList = await CashuDB.sharedInstance.objects<IHistoryEntry>();
    List<IHistoryEntryIsar> historyISAR = historyList.map((history) => IHistoryEntryIsar(
      amount: history.amount.toDouble(),
      typeRaw: history.type.value,
      timestamp: history.timestamp,
      value: history.value,
      mints: history.mints,
      fee: history.fee?.toInt(),
      isSpent: history.isSpent,
    )).toList();
    await CashuIsarDB.putAll<IHistoryEntryIsar>(historyISAR);
  }

  static Future<void> _invoiceMigrateToIsar() async {
    List<IInvoice> invoices = await CashuDB.sharedInstance.objects<IInvoice>();
    List<IInvoiceIsar> invoicesISAR = invoices.map((invoice) => IInvoiceIsar(
      quote: invoice.quote,
      request: invoice.request,
      paid: invoice.paid,
      expiry: invoice.expiry,
      amount: invoice.amount,
      mintURL: invoice.mintURL,
    )).toList();
    await CashuIsarDB.putAll<IInvoiceIsar>(invoicesISAR);
  }

  static Future<void> _keysetInfoMigrateToIsar() async {
    List<KeysetInfo> keysets = await CashuDB.sharedInstance.objects<KeysetInfo>();
    List<KeysetInfoIsar> keysetsISAR = keysets.map((keyset) {
      var keysetRaw = '';
      try {
        keysetRaw = json.encode(keyset.keyset);
      } catch (_) {}
      return KeysetInfoIsar(
        keysetId: keyset.id,
        mintURL: keyset.mintURL,
        unit: keyset.unit,
        active: true,
        keysetRaw: keysetRaw,
      );
    }).toList();
    await CashuIsarDB.putAll<KeysetInfoIsar>(keysetsISAR);
  }

  static Future<void> _lightningInvoiceMigrateToIsar() async {
    List<LightningInvoice> invoices = await CashuDB.sharedInstance.objects<LightningInvoice>();
    List<LightningInvoiceIsar> invoicesISAR = invoices.map((invoice) => LightningInvoiceIsar(
      pr: invoice.pr,
      hash: invoice.hash,
      amount: invoice.amount,
      mintURL: invoice.mintURL,
    )).toList();
    await CashuIsarDB.putAll<LightningInvoiceIsar>(invoicesISAR);
  }

  static Future<void> _mintMigrateToIsar() async {
    List<IMint> mints = await CashuDB.sharedInstance.objects<IMint>();
    List<IMintIsar> mintsISAR = mints.map((mint) => IMintIsar(
      mintURL: mint.mintURL,
      maxNutsVersion: mint.maxNutsVersion,
      name: mint.name,
      balance: mint.balance,
    )).toList();
    await CashuIsarDB.putAll<IMintIsar>(mintsISAR);
  }

  static Future<void> _mintInfoMigrateToIsar() async {
    List<MintInfo> mintInfos = await CashuDB.sharedInstance.objects<MintInfo>();
    List<MintInfoIsar> mintInfosISAR = mintInfos.map((info) {
      var contactJsonRaw = '';
      var nutsJsonRaw = '';
      try {
        contactJsonRaw = json.encode(info.contact);
        nutsJsonRaw = json.encode(info.nuts);
      } catch (_) {}
      return MintInfoIsar(
        mintURL: info.mintURL,
        name: info.name,
        pubkey: info.pubkey,
        version: info.version,
        description: info.description,
        descriptionLong: info.descriptionLong,
        contactJsonRaw: contactJsonRaw,
        nutsJsonRaw: nutsJsonRaw,
        motd: info.motd,
      );
    }).toList();
    await CashuIsarDB.putAll<MintInfoIsar>(mintInfosISAR);
  }

  static Future<void> _unblindingDataMigrateToIsar() async {
    List<UnblindingData> unblindingData = await CashuDB.sharedInstance.objects<UnblindingData>();
    List<UnblindingDataIsar> unblindingDataISAR = unblindingData.map((data) {
      var dleqPlainText = '';
      try {
        dleqPlainText = json.encode(data.dleq);
      } catch (_) {}
      return UnblindingDataIsar(
        mintURL: data.mintURL,
        unit: data.unit,
        actionTypeRaw: data.actionTypeRaw,
        actionValue: data.actionValue,
        keysetId: data.id,
        amount: data.amount,
        C_: data.C_,
        dleqPlainText: dleqPlainText,
        r: data.r,
        secret: data.secret,
      );
    }).toList();
    await CashuIsarDB.putAll<UnblindingDataIsar>(unblindingDataISAR);
  }
}