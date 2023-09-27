#import "OXPerferencePlugin.h"
#import "OXCFlutterViewController.h"

@implementation OXPerferencePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.oxchat.global/perferences"
                                     binaryMessenger:[registrar messenger]];
    OXPerferencePlugin* instance = [[OXPerferencePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if ([@"showFlutterActivity" isEqualToString:call.method]) {
        [self showFlutterViewController:call.arguments result:result];
    }
    else if ([@"getAppOpenURL" isEqualToString:call.method]) {
        [self getAppOpenURL:call.arguments result:result];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)showFlutterViewController:(NSDictionary *)arguments result:(FlutterResult)result {
    UINavigationController *navCtrl = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    NSString *route = arguments[@"route"];
    NSString *params = arguments[@"params"];
    id paramsJson = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [OXCFlutterViewController openFlutterViewController:route params:paramsJson navigationController:navCtrl];
}

- (void)getAppOpenURL:(NSDictionary *)arguments result:(FlutterResult)result {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [userDefault valueForKey:OPENURLAPP] ?: @"";
    result(urlString);
    [userDefault setValue:@"" forKey:OPENURLAPP];
    [userDefault synchronize];
}

@end
