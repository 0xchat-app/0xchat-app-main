#import "OXNetworkPlugin.h"

@implementation OXNetworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"ox_network"
                                     binaryMessenger:[registrar messenger]];
    OXNetworkPlugin* instance = [[OXNetworkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getProxyAddress" isEqualToString:call.method]) {
        [self getProxyAddress:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)getProxyAddress:(id)params result:(FlutterResult)result {
    
    NSString *url = params[@"url"];

    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:url]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies firstObject];
    NSString *hostName = settings[(__bridge NSString *)kCFProxyHostNameKey];
    NSNumber *portName = settings[(__bridge NSString *)kCFProxyPortNumberKey];
    CFStringRef proxyTypeRef = (__bridge CFStringRef)settings[(__bridge NSString *)kCFProxyTypeKey];
    
    if (hostName == nil || portName == nil) {
        result(@"");
    } else {
        // Return format: "host:port:type" or "host:port" if type is unknown
        // Convert CFStringRef to NSString for comparison
        NSString *proxyType = nil;
        if (proxyTypeRef != NULL) {
            proxyType = (__bridge NSString *)proxyTypeRef;
            // Return the actual type string (e.g., "kCFProxyTypeSOCKS", "kCFProxyTypeHTTP")
            result([NSString stringWithFormat:@"%@:%@:%@", hostName, portName, proxyType]);
        } else {
            result([NSString stringWithFormat:@"%@:%@", hostName, portName]);
        }
    }
}

@end
