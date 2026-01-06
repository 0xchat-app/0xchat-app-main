import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:unifiedpush/unifiedpush.dart';

import 'constants.dart';
import 'push_picker_dialogs.dart';

class UPFunctions {

  static Future<void> initRegisterApp([String instance = defaultInstance, List<String>? features]) async {
    var distributor = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageSettingKey.KEY_DISTRIBUTOR_NAME.name);
    if (distributor == null){
      distributor = ppnOxchat;
      await saveDistributor(distributor);
      await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageSettingKey.KEY_DISTRIBUTOR_NAME.name, ppnOxchat);
    }
    await registerApp(instance = distributor, features = features);
  }

  static Future<String?> registerAppWithDialog(BuildContext context,
      [String instance = defaultInstance, List<String>? features]) async {
    String? picked;

    final distributors = await getDistributors(features);
    List<String> showDistributors = [];
    showDistributors.addAll(distributors);
    picked = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PushPickerDialog(distributors: showDistributors,);
      },
    );
    if (picked != null ) {
      await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageSettingKey.KEY_DISTRIBUTOR_NAME.name, picked);
      await saveDistributor(picked); //unable to store fake distributor —— noDistributorAck
      await registerApp(instance = picked, features = features);
    }

    return picked == null ? picked : getShowTitle(picked);
  }

  static Future<void> registerApp([String instance = defaultInstance, List<String>? features]) async {
    await UnifiedPush.registerApp(instance, features);
  }

  static Future<void> unregister([String instance = defaultInstance]) async {
    return await UnifiedPush.unregister(instance);
  }

  static Future<List<String>> getDistributors(List<String>? features) async {
    return await UnifiedPush.getDistributors(features);
  }

  static Future<String?> getDistributor() async {
    return await UnifiedPush.getDistributor();
  }

  static Future<void> saveDistributor(String distributor) async {
    await UnifiedPush.saveDistributor(distributor);
  }

  static void onRegistrationFailed(String instance) {

  }

  static void onUnregistered(String instance) {

  }
}
