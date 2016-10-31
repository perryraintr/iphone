//
//  AppDelegate.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, PINNetworkType) {
    PINNetworkType_Wifi = 0, // Wifi
    PINNetworkType_ChinaMobile, //移动
    PINNetworkType_None, //无网络
};

@class PINNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PINNavigationController *pinNavigationController;

@property (assign, nonatomic) PINNetworkType networkType;

- (void)needLoginVC;

- (void)rootVC;

@end

