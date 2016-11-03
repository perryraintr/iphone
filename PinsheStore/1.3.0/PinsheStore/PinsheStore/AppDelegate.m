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
#import "GeTuiSdk.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self GeTuiInit];
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

- (void)GeTuiInit {
    // [ GTSdk ]：是否允许APP后台运行
        [GeTuiSdk runBackgroundEnable:YES];
    
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-Channel"];
    
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT启动个推
    
    PLog(@"GeTuiAppID : %@", GeTuiAppID);
    
    [GeTuiSdk startSdkWithAppId:GeTuiAppID appKey:GeTuiAppKey appSecret:GeTuiAppSecret delegate:self];
    
    // 注册APNs - custom method - 开发者自定义的方法
    [self registerRemoteNotification];
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    
    
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    if (Is_iOS10) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                PLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    PLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                PLog(@"注册失败");
            }
        }];
    }
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

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    PLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    PLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", [error localizedDescription]);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 显示APNs信息到页面
//    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], userInfo];
//    PLog(@"点击通知栏，得到的数据，显示APNs信息到页面 : %@", record);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//    
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        PLog(@"iOS10 前台收到远程通知:%@", userInfo);
//        
//    }
//    else {
//        // 判断为本地通知
//        PLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
//    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        PLog(@"iOS10 收到远程通知:%@", userInfo);
//        
//    }
//    else {
//        // 判断为本地通知
//        PLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
//    }
//    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSdk ]：个推SDK已注册，返回clientId
    PLog(@">>[GTSdk RegisterClient]:%@", clientId);
    
    if ([PINUserDefaultManagement instance].isLogined) { // 已登录
        PINMainModuleService *httpService = [[PINMainModuleService alloc] init];
        [httpService memberGeTuiModifyRequestWithGuid:[PINUserDefaultManagement instance].pinUser.guid geTuiCid:clientId finished:^(NSDictionary *result, NSString *message) {
        } failure:^(NSDictionary *result, NSString *message) {
        }];
    } else {
        [PINUserDefaultManagement instance].getTuiCid = clientId;
    }
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
//    // 页面显示日志
//    NSString *record = [NSString stringWithFormat:@"%d, %@, %@%@", ++_lastPayloadIndex, [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @""];
//    [_viewController logMsg:record];
//    
//    // 控制台打印日志
//    NSString *msg = [NSString stringWithFormat:@"%@ : %@%@", [NSString stringFromDateyyyy_MM_dd:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @""];
//    PLog(@">>[GTSdk ReceivePayload]:%@, taskId: %@, msgId :%@", msg, taskId, msgId);
    
    if ([PINUserDefaultManagement instance].isLogined) {
        PINTabBarController *pinTabBar = pinTabBarController();
        [pinTabBar creatCircle:NO];
    }
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 页面显示：上行消息结果反馈
//    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//    PLog(@"页面显示：上行消息结果反馈 : %@", record);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // 页面显示：个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    PLog(@"GeTuiSdkDidOccurError: %@", [error localizedDescription]);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 页面显示更新通知SDK运行状态
//    [_viewController updateStatusView:self];
    PLog(@"GeTuiSDkDidNotifySdkState : %zd", aStatus);
}

/** SDK设置推送模式回调  */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    // 页面显示错误信息
    if (error) {
        PLog(@"GeTuiSdkDidSetPushMode: %@", [error localizedDescription]);
        return;
    }
    
    PLog(@"%@", [NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@", isModeOff ? @"关闭" : @"开启"]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    PLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    PLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    PLog(@"applicationWillEnterForeground");

    //应用的数字角标减1
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PLog(@"applicationDidBecomeActive");
    if ([PINUserDefaultManagement instance].isLogined) {
        PINTabBarController *pinTabBar = pinTabBarController();
        [pinTabBar creatCircle:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    PLog(@"applicationWillTerminate");
}

@end
