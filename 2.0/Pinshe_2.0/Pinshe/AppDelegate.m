//
//  AppDelegate.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "AppDelegate.h"
#import "PinTabBarController.h"
#import "PinNavigationController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initUmengTrack];
    [self initReachability];
    
    PinTabBarController *pinTabBarController = [[PinTabBarController alloc] init];
    self.pinNavigationController = [[PinNavigationController alloc] initWithRootViewController:pinTabBarController];
    self.window.rootViewController = self.pinNavigationController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    return YES;
}

- (void)initUmengTrack {
    @try {
#ifdef DEBUG
        [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#else
        [MobClick setLogEnabled:NO];
#endif
        
#if TARGET_IPHONE_SIMULATOR
        [MobClick setCrashReportEnabled:NO];
#endif
        
        [MobClick setAppVersion:XcodeAppVersion];
        //注册友盟分享
        [UMSocialData setAppKey:UMENG_KEY];
        
        //注册友盟统计
        UMConfigInstance.appKey = UMENG_KEY;
#ifdef DEBUG
        UMConfigInstance.channelId = @"debug";
#else
        UMConfigInstance.channelId = @"App Store";
#endif
        [MobClick startWithConfigure:UMConfigInstance];
        
        //注册友盟分享微信回调
        [UMSocialWechatHandler setWXAppId:WeChatAppleID appSecret:WeChatSecret url:@"http://www.pinshe.org"];
        
        [WXApi registerApp:WeChatAppleID withDescription:@"pinShe"];
    } @catch (NSException *exception) {
        PLog(@"%s\nreason:%@\ncallStackSymbols:%@", __func__, exception.reason, exception.callStackSymbols);
    }
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
            self.networkType = PinNetworkType_None;
            PLog(@"networkType: None");
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机移动网络
        {
            self.networkType = PinNetworkType_ChinaMobile;
            PLog(@"networkType: Unknown, use default ChinaMobile");
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
        {
            self.networkType = PinNetworkType_Wifi;
            PLog(@"networkType: Wifi");
        }
            break;
            
        default:
            self.networkType = PinNetworkType_None;
            break;
    }

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PLog(@"???%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                    stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url];
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
