// Wrapper file to ensure FlutterSoundPluginRegisterWithRegistrar is always available
// This file ensures the function declaration is visible to generated_plugin_registrant.cc

#include <flutter_plugin_registrar.h>

// Define FLUTTER_PLUGIN_EXPORT if not already defined
#ifndef FLUTTER_PLUGIN_EXPORT
  #ifdef FLUTTER_PLUGIN_IMPL
    #define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
  #else
    #define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
  #endif
#endif

// Forward declaration to ensure the function is available
extern "C" {
  FLUTTER_PLUGIN_EXPORT void FlutterSoundPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar);
}

// This file ensures the linker can find the function implementation
// The actual implementation is in flutter_sound_plugin_c_api.cpp
