import 'package:flutter/material.dart';

abstract class ContactBasePageState<T extends StatefulWidget> extends State<T> {
  void updateContactTabClickAction(int num, bool isChangeToContactPage);
}