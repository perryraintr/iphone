//
//  LoginController.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/17.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "BaseViewController.h"

@class PinNavigationController;
@interface LoginController : BaseViewController

@property (nonatomic, strong) UIViewController *willPushViewController;
@property (nonatomic, strong) PinNavigationController *pushNavigationContrller;

@end
