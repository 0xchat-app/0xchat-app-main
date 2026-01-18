#ifndef FLUTTER_PLUGIN_FLUTTER_SOUND_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_SOUND_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

// Define FLUTTER_PLUGIN_EXPORT only if not already defined by another plugin
#ifndef FLUTTER_PLUGIN_EXPORT
#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT
#else
#define FLUTTER_PLUGIN_EXPORT extern
#endif
#endif

typedef struct _FlutterSoundPlugin FlutterSoundPlugin;
typedef struct _FlutterSoundPluginClass FlutterSoundPluginClass;

struct _FlutterSoundPlugin {
  GObject parent_instance;
};

struct _FlutterSoundPluginClass {
  GObjectClass parent_class;
};

GType flutter_sound_plugin_get_type(void) G_GNUC_CONST;

FLUTTER_PLUGIN_EXPORT void flutter_sound_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_FLUTTER_SOUND_PLUGIN_H_
