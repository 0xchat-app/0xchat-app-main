import 'package:cashu_dart/cashu_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_wallet/services/ecash_listener.dart';

class EcashManager extends ChangeNotifier {
  static final EcashManager shared = EcashManager._internal();

  EcashManager._internal() {
    EcashListener onMintListChangedListener = EcashListener(onMintsChanged: _onMintsChanged);
    Cashu.addInvoiceListener(onMintListChangedListener);
  }

  final localKey = StorageSettingKey.KEY_DEFAULT_MINT_URL.name;
  final ecashAccessKey = StorageSettingKey.KEY_WALLET_ACCESS.name;
  final ecashSafeTipsSeenKey = StorageSettingKey.KEY_ECASH_SAFE_TIPS_SEEN.name;

  late List<IMint> _mintList;

  IMint? _defaultIMint;

  bool _isWalletAvailable = false;

  bool _isWalletSafeTipsSeen = false;

  List<IMint> get mintList => _mintList;

  int get mintCount => mintList.length;

  IMint? get defaultIMint => _defaultIMint;
  
  String get pubKey => OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';

  bool isDefaultMint(IMint mint) => _defaultIMint == mint;

  bool get isWalletAvailable => _isWalletAvailable;

  bool get isWalletSafeTipsSeen => _isWalletSafeTipsSeen;
  
  setup() async {
    _mintList = List.of(await Cashu.mintList());
    _initDefaultMint();
    _isWalletAvailable = await _getEcashAccessSignForLocal();
    _isWalletSafeTipsSeen = await _getEcashSafeTipsSeen();
  }

  Future<void> _initDefaultMint() async {
    String defaultMintURL = await _getMintURLForLocal();
    if(defaultMintURL.isNotEmpty){
      for (var element in mintList) {
        if(element.mintURL == defaultMintURL){
          _setDefaultMint(element);
        }
      }
    }
  }

  void _setDefaultMint(IMint? mint){
    _defaultIMint = mint;
    if(mint != null) updateMintList(mint);
  }

  _onMintsChanged(List<IMint> mints) {
    if(!listEquals(mints, _mintList)){
      _mintList = mints;
      _initDefaultMint();
      notifyListeners();
    }
  }

  void addMint(IMint mint) {
    _mintList.add(mint);
  }

  Future<bool> deleteMint(IMint mint) async {
    if (isDefaultMint(mint)) {
      await removeDefaultMint();
    }
    notifyListeners();
    return _mintList.remove(mint);
  }

  void updateMintList(IMint mint) {
    if (_mintList.contains(mint)) {
      _mintList.remove(mint);
      _mintList.insert(0, mint);
    } else {
      _mintList.insert(0, mint);
    }
  }

  List<String> get mintURLs => mintList.map((element) => element.mintURL).toList();

  Future<void> setDefaultMint(IMint mint) async {
    await _saveMintURLForLocal(mint.mintURL);
    _setDefaultMint(mint);
  }

  Future<void> removeDefaultMint() async {
    await _saveMintURLForLocal('');
    _setDefaultMint(null);
  }

  Future<void> setWalletAvailable() async {
    await _saveEcashAccessSignForLocal(true);
    _isWalletAvailable = true;
  }

  Future<void> setWalletSafeTipsSeen() async {
    await _saveEcashSafeTipsSeen(true);
    _isWalletSafeTipsSeen = true;
  }

  Future<void> _saveMintURLForLocal(String mintURL) async {
    await UserConfigTool.saveSetting(localKey, mintURL);
  }

  Future<String> _getMintURLForLocal() async {
    return UserConfigTool.getSetting(localKey, defaultValue: '');
  }

  Future<void> _saveEcashAccessSignForLocal(bool sign) async {
    await UserConfigTool.saveSetting(ecashAccessKey, sign);
  }

  Future<bool> _getEcashAccessSignForLocal() async {
    return UserConfigTool.getSetting(ecashAccessKey, defaultValue:  false);
  }

  Future<void> _saveEcashSafeTipsSeen(bool seen) async {
    await UserConfigTool.saveSetting(ecashSafeTipsSeenKey, seen);
  }

  Future<bool> _getEcashSafeTipsSeen() async {
    return UserConfigTool.getSetting(ecashSafeTipsSeenKey, defaultValue: false);
  }
}