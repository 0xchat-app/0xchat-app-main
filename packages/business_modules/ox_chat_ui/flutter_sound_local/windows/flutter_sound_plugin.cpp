#include "flutter_sound_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

// Stub implementation for flutter_sound on Windows
// Provides empty implementations to allow compilation

namespace flutter_sound {

// static
void FlutterSoundPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_sound",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterSoundPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

FlutterSoundPlugin::FlutterSoundPlugin() {}

FlutterSoundPlugin::~FlutterSoundPlugin() {}

void FlutterSoundPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // Return not implemented for all method calls
  result->NotImplemented();
}

}  // namespace flutter_sound
