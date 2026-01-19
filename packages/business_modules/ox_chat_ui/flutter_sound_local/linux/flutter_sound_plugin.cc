#include "include/flutter_sound/flutter_sound_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <cstring>

// Stub implementation for flutter_sound on Linux
// Provides empty implementations to allow compilation

#define FLUTTER_SOUND_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_sound_plugin_get_type(), \
                              FlutterSoundPlugin))

// Define the structure only once
// Use a guard to prevent redefinition if this file is accidentally included
#ifndef FLUTTER_SOUND_PLUGIN_STRUCT_DEFINED
#define FLUTTER_SOUND_PLUGIN_STRUCT_DEFINED
struct _FlutterSoundPlugin {
  GObject parent_instance;
};
#endif

// G_DEFINE_TYPE must be called after the structure definition
// and only once per translation unit
G_DEFINE_TYPE(FlutterSoundPlugin, flutter_sound_plugin, g_object_get_type())

static void flutter_sound_plugin_handle_method_call(
    FlutterSoundPlugin* self,
    FlMethodCall* method_call) {
  // Return not implemented for all method calls
  g_autoptr(FlMethodResponse) response = 
      FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  fl_method_call_respond(method_call, response, nullptr);
}

static void flutter_sound_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(flutter_sound_plugin_parent_class)->dispose(object);
}

static void flutter_sound_plugin_class_init(FlutterSoundPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_sound_plugin_dispose;
}

static void flutter_sound_plugin_init(FlutterSoundPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlutterSoundPlugin* plugin = FLUTTER_SOUND_PLUGIN(user_data);
  flutter_sound_plugin_handle_method_call(plugin, method_call);
}

void flutter_sound_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlutterSoundPlugin* plugin = FLUTTER_SOUND_PLUGIN(
      g_object_new(flutter_sound_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "flutter_sound",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
