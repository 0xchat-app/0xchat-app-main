#import "OXCCommonPlugin.h"
#if __has_include(<ox_common/ox_common-Swift.h>)
#import <ox_common/ox_common-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ox_common-Swift.h"
#endif

@implementation OXCCommonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOXCCommonPlugin registerWithRegistrar:registrar];
}
@end
