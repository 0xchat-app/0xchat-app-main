import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class EcashManager {
  static final EcashManager shared = EcashManager._internal();

  EcashManager._internal();

  final localKey = 'default_mint_url';

  late List<IMint> _mintList;

  IMint? _defaultIMint;

  List<IMint> get mintList => _mintList;

  int get mintCount => mintList.length;

  IMint? get defaultIMint => _defaultIMint;
  
  String get pubKey => OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
  
  setup() async {
    _mintList = List.of(Cashu.mintList());
    _initDefaultMint();
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

  Future<bool> _saveMintURLForLocal(String mintURL) async {
    return await OXCacheManager.defaultOXCacheManager.saveData('$pubKey.$localKey', mintURL);
  }
  
  Future<String> _getMintURLForLocal() async {
    return await OXCacheManager.defaultOXCacheManager.getData('$pubKey.$localKey');
  }
}