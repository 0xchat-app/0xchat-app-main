

import 'package:flutter/cupertino.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';


const String gesturePasswordKey = "gesturePasswordKey";
const String hasFingerprintKey = "hasFingerprintKey";
const String hasFaceIDKey = "hasFaceIDKey";

class OXAppPreferences {

    ValueNotifier<bool> hasGesturePasswordValueNotifier = ValueNotifier(false);
    ValueNotifier<bool> hasFingerprintValueNotifier = ValueNotifier(false);
    ValueNotifier<bool> hasFaceIDValueNotifier = ValueNotifier(false);

    static final OXAppPreferences sharedInstance = OXAppPreferences._internal();

    OXAppPreferences._internal() {

        OXCacheManager.defaultOXCacheManager.getForeverData(gesturePasswordKey, defaultValue: "").then((value) => {
            hasGesturePasswordValueNotifier.value = value.toString().isNotEmpty
        });
        OXCacheManager.defaultOXCacheManager.getForeverData(hasFingerprintKey, defaultValue: false).then((value) => {
            hasFingerprintValueNotifier.value = value
        });
        OXCacheManager.defaultOXCacheManager.getForeverData(hasFaceIDKey, defaultValue: false).then((value) =>{
            hasFaceIDValueNotifier.value = value
        });
    }

    factory OXAppPreferences() {
        return sharedInstance;
    }

    Future saveGesturePassword(String password) async {
        await OXCacheManager.defaultOXCacheManager.saveForeverData(gesturePasswordKey, password);
        hasGesturePasswordValueNotifier.value = password.isNotEmpty;
    }

    Future saveHasFingerprint(bool hasFingerprint) async {
        await OXCacheManager.defaultOXCacheManager.saveForeverData(hasFingerprintKey, hasFingerprint);
        hasFingerprintValueNotifier.value = hasFingerprint;
    }

    Future saveHasFaceID(bool hasFaceID) async {
        await OXCacheManager.defaultOXCacheManager.saveForeverData(hasFaceIDKey, hasFaceID);
        hasFaceIDValueNotifier.value = hasFaceID;
    }

    Future<String> getGesturePassword() async {
       return await OXCacheManager.defaultOXCacheManager.getForeverData(gesturePasswordKey, defaultValue: "");
    }

    Future<bool> getHasFingerprint() async {
        return await OXCacheManager.defaultOXCacheManager.getForeverData(hasFingerprintKey, defaultValue: false);
    }

    Future<bool> getHasFaceID() async {
        return await OXCacheManager.defaultOXCacheManager.getForeverData(hasFaceIDKey, defaultValue: false);
    }
}

class OXAppPreferencesWidgetTool {

    static Widget gesturePasswordListenableBuilder(ValueWidgetBuilder<bool> builder) {
        return ValueListenableBuilder(
          valueListenable: OXAppPreferences.sharedInstance.hasGesturePasswordValueNotifier,
          builder: builder
        );
    }

    static Widget fingerprintListenableBuilder(ValueWidgetBuilder<bool> builder) {
        return ValueListenableBuilder(
          valueListenable: OXAppPreferences.sharedInstance.hasFingerprintValueNotifier,
          builder: builder
        );
    }

    static Widget faceIDListenableBuilder(ValueWidgetBuilder<bool> builder) {
        return ValueListenableBuilder(
          valueListenable: OXAppPreferences.sharedInstance.hasFaceIDValueNotifier,
          builder: builder
        );
    }
}
