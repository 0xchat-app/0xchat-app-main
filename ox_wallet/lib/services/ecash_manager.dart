import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class EcashManager {
  static final EcashManager shared = EcashManager._internal();

  EcashManager._internal();

  final localKey = 'default_mint_url';
  final ecashAccessKey = 'wallet_access';

  late List<IMint> _mintList;

  IMint? _defaultIMint;

  bool _isWalletAvailable = false;

  List<IMint> get mintList => _mintList;

  int get mintCount => mintList.length;

  IMint? get defaultIMint => _defaultIMint;
  
  String get pubKey => OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';

  bool isDefaultMint(IMint mint) => _defaultIMint == mint;

  bool get isWalletAvailable => _isWalletAvailable;
  
  setup() async {
    _mintList = List.of(await Cashu.mintList());
    _initDefaultMint();
    _isWalletAvailable = await _getEcashAccessSignForLocal();
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

  void addMint(IMint mint) {
    _mintList.add(mint);
  }

  Future<bool> deleteMint(IMint mint) async {
    if (isDefaultMint(mint)) {
      await removeDefaultMint();
    }
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

  Future<bool> setDefaultMint(IMint mint) async {
    bool result = await _saveMintURLForLocal(mint.mintURL);
    if (result) _setDefaultMint(mint);
    return result;
  }

  Future<bool> removeDefaultMint() async {
    bool result =  await _saveMintURLForLocal('');
    if(result) _setDefaultMint(null);
    return result;
  }

  Future<void> setWalletAvailable() async {
    await _saveEcashAccessSignForLocal(true);
    _isWalletAvailable = true;
  }

  Future<bool> _saveMintURLForLocal(String mintURL) async {
    return await OXCacheManager.defaultOXCacheManager.saveForeverData('$pubKey.$localKey', mintURL);
  }
  
  Future<String> _getMintURLForLocal() async {
    return await OXCacheManager.defaultOXCacheManager.getForeverData('$pubKey.$localKey');
  }

  Future<bool> _saveEcashAccessSignForLocal(bool sign) async {
    return await OXCacheManager.defaultOXCacheManager.saveForeverData('$pubKey.$ecashAccessKey', sign);
  }

  Future<bool> _getEcashAccessSignForLocal()  async{
    return await OXCacheManager.defaultOXCacheManager.getForeverData('$pubKey.$ecashAccessKey',defaultValue: false);
  }
}