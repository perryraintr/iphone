//
//  AppDelegate.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "AppDelegate.h"
#import "PINTabBarController.h"
#import "PINLoginController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initReachability];
    
    if ([PINUserDefaultManagement instance].isLogined) {
        [self rootVC];
    } else {
        [self needLoginVC];
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)needLoginVC {
    PINLoginController *pinLoginController = [[PINLoginController alloc] init];
    self.pinNavigationController = [[PINNavigationController alloc] initWithRootViewController:pinLoginController];
    self.window.rootViewController = self.pinNavigationController;
}

- (void)rootVC {
    PINTabBarController *pinTabBarController = [[PINTabBarController alloc] init];
    self.pinNavigationController = [[PINNavigationController alloc] initWithRootViewController:pinTabBarController];
    self.window.rootViewController = self.pinNavigationController;
}

- (void)initReachability {
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) { // 未知网络
            AFNetworkReachabilityStatus networkReachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
            [self setNetworkReachabilityStatus:networkReachabilityStatus];
        } else {
            [self setNetworkReachabilityStatus:status];
        }
    }];
    [reachabilityManager startMonitoring];
}

- (void)setNetworkReachabilityStatus:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
        {
            self.networkType = PINNetworkType_None;
            PLog(@"networkType: None");
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机移动网络
        {
            self.networkType = PINNetworkType_ChinaMobile;
            PLog(@"networkType: Unknown, use default ChinaMobile");
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
        {
            self.networkType = PINNetworkType_Wifi;
            PLog(@"networkType: Wifi");
        }
            break;
            
        default:
            self.networkType = PINNetworkType_None;
            break;
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
