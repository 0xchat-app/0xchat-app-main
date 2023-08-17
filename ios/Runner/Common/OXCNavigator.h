#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface OXCNavigator : NSObject<FlutterPlugin>

+ (UINavigationController *)currentNavController;

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry;

@property (nonatomic, weak)  NSObject<FlutterPluginRegistry>* registry;

@end

