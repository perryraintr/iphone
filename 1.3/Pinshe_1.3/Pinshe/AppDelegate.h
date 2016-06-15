//
//  AppDelegate.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, PinNetworkType) {
    PinNetworkType_Wifi = 0, // Wifi
    PinNetworkType_ChinaMobile, //移动
    PinNetworkType_None, //无网络
};

@class PinNavigationController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PinNavigationController *pinNavigationController;
@property (assign, nonatomic) PinNetworkType networkType;

@end

