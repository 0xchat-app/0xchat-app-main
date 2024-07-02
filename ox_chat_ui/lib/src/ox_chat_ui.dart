
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OXChatUI extends OXFlutterModule {

  @override
  Future<void> setup() async {
    await super.setup();
  }

  @override
  String get moduleName => 'ox_chat_ui';

  @override
  Map<String, Function> get interfaces => { };

  @override
  Future<T?>? navigateToPage<T>(BuildContext context, String pageName, Map<String, dynamic>? params) {
    return null;
  }
}