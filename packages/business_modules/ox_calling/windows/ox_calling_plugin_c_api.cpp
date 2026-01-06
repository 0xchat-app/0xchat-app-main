#include "include/ox_calling/ox_calling_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ox_calling_plugin.h"

void OxCallingPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ox_calling::OxCallingPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
