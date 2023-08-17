#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@class OXCFlutterEngine;

typedef enum : NSUInteger {
    FlutterStatusStyleDefault,
    FlutterStatusStyleLightContent,
    FlutterStatusStyleDarkContent,
    FlutterStatusStyleOXChat,
} FlutterStatusStyle;

@interface OXCFlutterViewController : FlutterViewController

@property(nonatomic, weak) OXCFlutterEngine *oxFlutterEngine;

@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, assign) FlutterStatusStyle barStyle;
@property(nonatomic, assign) BOOL canPop;

//- (void)pages:(void(^)(NSArray<NSString *> *))complete;

//- (void)callFlutterMethodWithModule:(NSString *)module
//                             method:(NSString *)method
//                             params:(NSDictionary *)params
//                           callback:(FlutterResult)callback;

+ (OXCFlutterViewController *)flutterViewController:(NSString *)route
                                             params:(id _Nullable)params;

/**
 Creates a Flutter page

 @param route The route name in the format of moduleName/pageName
 @param params The parameters to be passed
 @return The created Flutter page
 */
+ (OXCFlutterViewController *)shareEngineFlutterViewController:(NSString *)route
                                            params:(id _Nullable)params;

/**
 Navigate to a Flutter page

 @param route The route name, in the format of moduleName/pageName
 @param params Parameters to be passed
 @param navigationController Navigation controller, defaults to the current page stack's navigation controller
 @return The target Flutter page to navigate to
 */

+ (OXCFlutterViewController *)openFlutterViewController:(NSString *)route
                                                params:(id _Nullable)params
                                  navigationController:(UINavigationController * _Nullable)navigationController;

// Get the complete FlutterRoute string with parameters
+ (NSString *)getFlutterFullRoute:(NSString *)route params:(id _Nullable)pageParams;

@end

NS_ASSUME_NONNULL_END
