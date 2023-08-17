#import "OXCBaseNavigationController.h"
#import "OXCFlutterViewController.h"
#import <Flutter/Flutter.h>

@interface OXCBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation OXCBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate {
    if ([self.topViewController isKindOfClass:FlutterViewController.class]) {
        return [self.topViewController shouldAutorotate];
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.topViewController isKindOfClass:FlutterViewController.class]) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Delegate
// UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count == 1 ||
        ([self.topViewController isKindOfClass:[OXCFlutterViewController class]] && ((OXCFlutterViewController *)self.topViewController).canPop)) {
        return NO;
    }else{
        return YES;
    }
}


@end
