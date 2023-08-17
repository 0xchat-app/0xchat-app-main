#import "OXCFlutterViewController.h"
#import "GeneratedPluginRegistrant.h"
#import "OXCFlutterEngineManager.h"

@implementation OXCFlutterViewController

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.oxFlutterEngine.engine.navigationChannel invokeMethod:@"setInitialRoute"
                                      arguments:@{}];
    self.oxFlutterEngine.defaultRouteName = @"/temp";
    [self.oxFlutterEngine.reloadMessageChannel sendMessage:self.oxFlutterEngine.defaultRouteName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.height != UIScreen.mainScreen.bounds.size.height) {
        self.view.frame = UIScreen.mainScreen.bounds;
        [self.view setNeedsLayout];
    }
}

- (UIView *)splashScreenView {
    return nil;
}

+ (OXCFlutterViewController *)flutterViewController:(NSString *)route
                                             params:(id)pageParams {
    route = [self getFlutterFullRoute:route params:pageParams];
    OXCFlutterEngine *engine = nil;
    engine = OXCFlutterEngineManager.sharedInstance.avaliableEngine;
    OXCFlutterViewController *flutterViewController = [[OXCFlutterViewController alloc] initWithEngine:engine.engine nibName:nil bundle:nil];
    flutterViewController.oxFlutterEngine = engine;
    [engine.reloadMessageChannel sendMessage:route];
    return flutterViewController;
}

// Override the superclass method to prevent system font size settings from affecting the page.
- (CGFloat)textScaleFactor {
    return 1.0;
}

#pragma mark - Interface
+ (OXCFlutterViewController *)shareEngineFlutterViewController:(NSString *)route
                                                        params:(id _Nullable)pageParams {
    
    route = [self getFlutterFullRoute:route params:pageParams];
    OXCFlutterEngine *flutterEngine = [[OXCFlutterEngineManager sharedInstance] avaliableEngine];
    flutterEngine.defaultRouteName = route;
    OXCFlutterViewController *flutterViewController = [[OXCFlutterViewController alloc] initWithEngine:flutterEngine.engine
                                                                                               nibName:nil
                                                                                                bundle:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [flutterEngine.reloadMessageChannel sendMessage:flutterEngine.defaultRouteName];
    });
    
    
    flutterViewController.oxFlutterEngine = flutterEngine;
    return flutterViewController;
}

+ (OXCFlutterViewController *)openFlutterViewController:(NSString *)route
                                                params:(id _Nullable)params
                                  navigationController:(UINavigationController * _Nullable)navigationController {
    OXCFlutterViewController *flutterViewController = [self shareEngineFlutterViewController:route params:params];
    UINavigationController *defaultNavController = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    if (![defaultNavController isKindOfClass:UINavigationController.class]) {
        defaultNavController = nil;
    }
    navigationController = navigationController ?: defaultNavController;
    [navigationController pushViewController:flutterViewController animated:YES];
    return flutterViewController;
}

+ (NSString *)getFlutterFullRoute:(NSString *)route params:(id _Nullable)pageParams {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"pageParams"] = pageParams;
    if (params != nil) {
        NSData  *data = [NSJSONSerialization  dataWithJSONObject:params options:NSJSONWritingPrettyPrinted  error:nil];
        NSString  *routeParams = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding ];
        route = [NSString stringWithFormat:@"%@?%@", route, routeParams];
    }
    return route;
}

#pragma mark - Setter / Getter
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.view.backgroundColor = backgroundColor;
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    switch (self.barStyle) {
        case FlutterStatusStyleDefault: {
            // Use Flutter's inherent control logic.
            UIStatusBarStyle style = [super preferredStatusBarStyle];
            // Due to Flutter's older versions not being compatible with iOS 13, we perform a conversion here.
            if (style == UIStatusBarStyleDefault) {
                return [self systemDarkStyle];
            } else {
                return style;
            }
        }
        case FlutterStatusStyleLightContent:
            return UIStatusBarStyleLightContent;
            
        case FlutterStatusStyleDarkContent:
            return [self systemDarkStyle];
        
        case FlutterStatusStyleOXChat:
            // Default color according to the current theme.
        default:
            return UIStatusBarStyleDefault;
    }
}

- (UIStatusBarStyle)systemDarkStyle {
    if (@available(iOS 13.0, *)) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        return UIStatusBarStyleDarkContent;
        #endif
    }
    return UIStatusBarStyleDefault;
}

@end
