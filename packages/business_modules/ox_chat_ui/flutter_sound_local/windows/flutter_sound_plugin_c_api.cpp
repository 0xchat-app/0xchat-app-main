#include "include/flutter_sound/flutter_sound_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_sound_plugin.h"

void FlutterSoundPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_sound::FlutterSoundPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

// Alias for compatibility with generated code that expects FlutterSoundPluginRegisterWithRegistrar
void FlutterSoundPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterSoundPluginCApiRegisterWithRegistrar(registrar);
}
