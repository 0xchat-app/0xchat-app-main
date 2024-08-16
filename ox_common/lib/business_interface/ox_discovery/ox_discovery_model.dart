import 'package:flutter/cupertino.dart';

abstract class DiscoveryPageBaseState<T extends StatefulWidget> extends State<T> {
  void updateClickNum(int num, bool isChangeToDiscovery);
}
