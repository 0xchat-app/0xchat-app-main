#import "OXCFlutterEngineManager.h"
#import "GeneratedPluginRegistrant.h"
#import "OXPerferencePlugin.h"
#import "OXCNavigator.h"

//#if __has_include(<scan/ScanPlugin.h>)
//#import <scan/ScanPlugin.h>
//#else
//@import scan;
//#endif

#if __has_include(<ox_common/OXCCommonPlugin.h>)
#import <ox_common/OXCCommonPlugin.h>
#else
@import ox_common;
#endif

#if __has_include(<ox_network/OXNetworkPlugin.h>)
#import <ox_network/OXNetworkPlugin.h>
#else
@import ox_network;
#endif

#if __has_include(<ox_push/OXPushPlugin.h>)
#import <ox_push/OXPushPlugin.h>
#else
@import ox_push;
#endif

static NSString *_kReloadChannelName = @"reload";

@interface OXCFlutterEngineManager()

@property(nonatomic, strong) NSMutableArray <OXCFlutterEngine *>*oxFlutterEngines;

@end

@implementation OXCFlutterEngineManager

+ (OXCFlutterEngineManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static OXCFlutterEngineManager *engineManage;
    dispatch_once(&onceToken, ^{
        if (!engineManage) {
            engineManage = [[self alloc] init];
        }
    });
    return engineManage;
}

- (void)prepareForFlutterEngine {
    [self avaliableEngine];
}

- (OXCFlutterEngine *)avaliableEngine {
    OXCFlutterEngine *avaliableEngine = nil;
    NSUInteger avaliableEngineCount = 0;
    for (OXCFlutterEngine *flutterEngine in self.oxFlutterEngines) {
        if (flutterEngine.engine.viewController == nil) {
            if(!avaliableEngine) avaliableEngine = flutterEngine;
            avaliableEngineCount ++;
        }
    }
    
    if (avaliableEngineCount <= 0) {
        NSString *engineName = [NSString stringWithFormat:@"com.ox.flutterEngine%lu", (unsigned long)self.oxFlutterEngines.count];
        OXCFlutterEngine *flutterEngine = [[OXCFlutterEngine alloc] initWithName:engineName];
        if (!avaliableEngine) avaliableEngine = flutterEngine;
        [self.oxFlutterEngines addObject:flutterEngine];
    }
    
    return avaliableEngine;
}

- (NSMutableArray *)oxFlutterEngines {
    if (!_oxFlutterEngines) {
        _oxFlutterEngines = [[NSMutableArray alloc] init];
    }
    return _oxFlutterEngines;
}

- (void)clearFlutterEngine {
    
}

@end

@implementation OXCFlutterEngine

- (instancetype)initWithName:(NSString *)engineName {
    self = [super init];
    if (self) {
        _engineName = engineName;
        _engine = [[FlutterEngine alloc] initWithName:engineName project:nil];
        [_engine runWithEntrypoint:nil  initialRoute:@"/temp"];
        [self prepareForChannel];
    }
    return self;
}

- (instancetype)initWithInitRoute:(NSString *)routeName {
    self = [super init];
    if (self) {
        _engine = [[FlutterEngine alloc] initWithName:routeName project:nil];
        self.defaultRouteName = routeName;
        [_engine runWithEntrypoint:nil initialRoute:@"/temp"];
        [self prepareForChannel];
    }
    return self;
}

- (void)prepareForChannel {
    _reloadMessageChannel = [[FlutterBasicMessageChannel alloc] initWithName:_kReloadChannelName
                                                             binaryMessenger:_engine
                                                                       codec:[FlutterStringCodec sharedInstance]];
    [OXCNavigator registerWithRegistry:_engine];
    [OXPerferencePlugin registerWithRegistrar:[_engine registrarForPlugin:@"OXPerference"]];
    [GeneratedPluginRegistrant registerWithRegistry:_engine];
//    [ScanPlugin registerWithRegistrar:[_engine registrarForPlugin:@"ScanPlugin"]];
    [OXCCommonPlugin registerWithRegistrar:[_engine registrarForPlugin:@"OXCCommonPlugin"]];
    [OXNetworkPlugin registerWithRegistrar:[_engine registrarForPlugin:@"OXNetworkPlugin"]];
    [OXPushPlugin registerWithRegistrar:[_engine registrarForPlugin:@"OXPushPlugin"]];
}

@end
