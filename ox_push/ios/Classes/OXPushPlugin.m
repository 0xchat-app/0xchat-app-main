#import "OXPushPlugin.h"

@implementation OXPushPlugin

static FlutterMethodChannel* _channel = nil;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  _channel = [FlutterMethodChannel
      methodChannelWithName:@"ox_push"
            binaryMessenger:[registrar messenger]];
  OXPushPlugin* instance = [[OXPushPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:_channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

+ (FlutterMethodChannel*)channel {
  return _channel;
}

@end
