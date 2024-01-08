import 'package:cashu_dart/cashu_dart.dart';

class EcashManager {
  static final EcashManager shared = EcashManager._internal();

  EcashManager._internal();

  List<IMint> get mintList => Cashu.mintList();

  int get mintCount => mintList.length;

  IMint get defaultIMint => mintList.first;
}