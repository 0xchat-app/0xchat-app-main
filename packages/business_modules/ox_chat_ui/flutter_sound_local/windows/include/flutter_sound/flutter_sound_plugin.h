#ifndef FLUTTER_PLUGIN_FLUTTER_SOUND_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_SOUND_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_sound {

// Stub implementation for flutter_sound on Windows
// Provides empty implementations to allow compilation
class FlutterSoundPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterSoundPlugin();

  virtual ~FlutterSoundPlugin();

  // Disallow copy and assign.
  FlutterSoundPlugin(const FlutterSoundPlugin&) = delete;
  FlutterSoundPlugin& operator=(const FlutterSoundPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_sound

#endif  // FLUTTER_PLUGIN_FLUTTER_SOUND_PLUGIN_H_
