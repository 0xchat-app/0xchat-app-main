#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@class OXCFlutterEngine;
@interface OXCFlutterEngineManager : NSObject

+ (OXCFlutterEngineManager *)sharedInstance;

- (OXCFlutterEngine *)avaliableEngine;

- (void)prepareForFlutterEngine;

- (void)clearFlutterEngine;

@end

@interface OXCFlutterEngine : NSObject

@property(nonatomic, strong) FlutterEngine *engine; 
@property(nonatomic, copy) NSString *engineName;
@property(nonatomic, copy) NSString *defaultRouteName;
@property(nonatomic, strong) FlutterBasicMessageChannel *reloadMessageChannel;

- (instancetype)initWithName:(NSString *)engineName;
- (instancetype)initWithInitRoute:(NSString *)routeName;

@end
