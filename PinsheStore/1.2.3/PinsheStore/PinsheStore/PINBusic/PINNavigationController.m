//
//  PinNavigationController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINNavigationController.h"

@interface PINNavigationController ()<UIGestureRecognizerDelegate>
@end

@implementation PINNavigationController

- (id)init {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
    }
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.backgroundColor = [UIColor blackColor];
//    [self.navigationBar become_backgroundColor:HEXCOLOR(pinColorNativeBarColor)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //如果ViewController不是从BaseViewController继承的，拒绝之
    if (![viewController isKindOfClass:[BaseViewController class]]) {
        return;
    }    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    NSUInteger ret = [self transitionPopController:nil];
    if (ret > 0) {
        if (self.viewControllers.count > ret) {
            UIViewController *toPop = [self.viewControllers objectAtIndex:self.viewControllers.count - 2 - ret];
            [super popToViewController:toPop animated:animated];
            return toPop;
        }
    }
    return [super popViewControllerAnimated:animated];
}

- (UIViewController *)forwardViewController
{
    UIViewController *viewController;
    NSArray *array = [self viewControllers];
    if (array.count > 1) {
        viewController = array[array.count -2];
    }
    return viewController;
}

- (NSUInteger)transitionPopController:(id)sender
{
    UIViewController *forward = [self forwardViewController];
    if (!forward) {
        return 0;
    }
    return 0;
}

@end
