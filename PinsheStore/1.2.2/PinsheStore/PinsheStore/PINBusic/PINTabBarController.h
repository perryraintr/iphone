//
//  PinTabBarController.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "BaseViewController.h"

@interface PINTabBarController : BaseViewController

@property (nonatomic, assign) NSUInteger selectedIndex;

- (BaseViewController *)getSelectedViewController;
+ (NSArray *)tabBarControllerClasses;
- (void)creatCircle:(BOOL)isHidden;

@end
