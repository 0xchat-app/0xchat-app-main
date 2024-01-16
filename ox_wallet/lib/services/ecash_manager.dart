import 'package:cashu_dart/cashu_dart.dart';

class EcashManager {
  static final EcashManager shared = EcashManager._internal();

  EcashManager._internal();

  final List<IMint> _mintList = List.of(Cashu.mintList());

  List<IMint> get mintList => _mintList;

  int get mintCount => mintList.length;

  IMint get defaultIMint => mintList.first;

  void updateMintList(IMint mint) {
    if (_mintList.contains(mint)) {
      _mintList.remove(mint);
      _mintList.insert(0, mint);
    } else {
      _mintList.insert(0, mint);
    }
  }

  List<String> get mintURLs => mintList.map((element) => element.mintURL).toList();

}