#import "OXCNavigator.h"
#import "OXCFlutterViewController.h"
#import "OXCFlutterEngineManager.h"
#import <objc/runtime.h>

#define FlutterMethod(methodName)                         \
+ (void)methodName:(NSDictionary *)__params_name_params    \
           result:(FlutterResult)__params_name_callback   \
       controller:(OXCFlutterViewController *)__params_name_controller

#define FlutterParams __params_name_params
#define FlutterCallback __params_name_callback
#define FlutterController __params_name_controller

#define FlutterIsNotEmpty(value) (![value isKindOfClass:NSNull.class] && value != nil)
#define FlutterValue(value, default) (FlutterIsNotEmpty(value) ? value : default)

typedef void *(*fn)(id,SEL,id,FlutterResult,id);

typedef enum : NSUInteger {
    NavigatorPageCodeExchange = 2333
} NavigatorPageCode;

@interface OXCNavigator ()

@property(nonatomic, class, weak, readonly) NSMutableDictionary *navigatorProxies;

@end

@implementation OXCNavigator

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    NSObject<FlutterPluginRegistrar>* registrar = [registry registrarForPlugin:@"Navigator"];
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"NativeNavigator"
                                     binaryMessenger:[registrar messenger]];
    OXCNavigator* instance = [[OXCNavigator alloc] init];
    instance.registry = registry;
    [registrar addMethodCallDelegate:instance channel:channel];
}
static NSMutableDictionary *_navigatorProxies;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *methodName = call.method;
    id params = call.arguments;
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:result:controller:",  methodName]);
    Method method = class_getClassMethod(self.class, sel);
    IMP imp = method_getImplementation(method);
    if (imp != nil && result != nil) {
        fn f = (fn)imp;
        f(self.class, sel, params, result, ((FlutterEngine *)self.registry).viewController);
        return;
    }
}

+ (UINavigationController *)currentNavController {
    return  UIApplication.sharedApplication.delegate.window.rootViewController;
}

FlutterMethod(didPush) {
    if (![FlutterController isKindOfClass:[OXCFlutterViewController class]]) {
        return;
    }
    BOOL canPop = [FlutterParams[@"canPop"] boolValue];
    OXCFlutterViewController *vc = (OXCFlutterViewController *)FlutterController;
    vc.canPop = canPop;
}

FlutterMethod(didPop) {
    if (![FlutterController isKindOfClass:[OXCFlutterViewController class]]) {
        return;
    }
    BOOL canPop = [FlutterParams[@"canPop"] boolValue];
    OXCFlutterViewController *vc = (OXCFlutterViewController *)FlutterController;
    vc.canPop = canPop;
}

#pragma mark - Setter / Getter
+ (NSMutableDictionary *)navigatorProxies {
    if (!_navigatorProxies) {
        _navigatorProxies = [[NSMutableDictionary alloc] init];
    }
    return _navigatorProxies;
}

@end
