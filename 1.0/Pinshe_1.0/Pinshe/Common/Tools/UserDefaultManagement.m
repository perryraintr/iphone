//
//  UserDefaultManagement.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UserDefaultManagement.h"
#import "PinUser.h"

@implementation UserDefaultManagement
+ (UserDefaultManagement *)instance {
    static UserDefaultManagement *userDefaultManagement = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaultManagement = [[self alloc] init];
    });
    return userDefaultManagement;
}

- (id)init {
    if (self = [super init]) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

// 存取debugRequestUrl
- (NSString *)debugRequestUrl {
    return [defaults objectForKey:@"debugRequestUrl"]?[defaults objectForKey:@"debugRequestUrl"]:@"";
}
- (void)setDebugRequestUrl:(NSString *)debugRequestUrl{
    [defaults setValue:debugRequestUrl forKey:@"debugRequestUrl"];
    [defaults synchronize];
}

- (NSString *)indexShareResult {
    return [defaults objectForKey:@"indexShareResult"]?[defaults objectForKey:@"indexShareResult"]:@"";
}

- (void)setIndexShareResult:(NSString *)indexShareResult {
    [defaults setValue:indexShareResult forKey:@"indexShareResult"];
    [defaults synchronize];
}

- (BOOL)haveUserId {
    return [[defaults objectForKey:@"haveUserId"] boolValue];
}

- (void)setHaveUserId:(BOOL)haveUserId {
    [defaults setBool:haveUserId forKey:@"haveUserId"];
    [defaults synchronize];
}

- (int)userId {
    return [[defaults objectForKey:@"userId"] intValue];
}

- (void)setUserId:(int)userId {
    [defaults setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [defaults synchronize];
}

// 取是否已经登录的标志
- (BOOL)isLogined {
    if ([WXApi isWXAppInstalled]) { // 安装微信
        return [UserDefaultManagement instance].userId > 0 && [UserDefaultManagement instance].pinUser;
    } else {
        return YES;
    }
}

- (void)setIsLogined:(BOOL)isLogined {
    [defaults setBool:isLogined forKey:@"isLogined"];
    [defaults synchronize];
}

- (PinUser *)pinUser {
    if ([defaults objectForKey:@"pinUser"]) {
        id pinUser = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"pinUser"]];
        if ([pinUser isKindOfClass:CLASS(@"PinUser")]) {
            return pinUser;
        }
    }
    return nil;
}

- (void)setPinUser:(PinUser *)pinUser {
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:pinUser] forKey:@"pinUser"];
    [defaults synchronize];
}

- (NSInteger)buttonTag {
    if ([[defaults objectForKey:@"buttonTag"] integerValue] == 0) {
        return 100;
    }
    return [[defaults objectForKey:@"buttonTag"] integerValue];
}

- (void)setButtonTag:(NSInteger)buttonTag {
    [defaults setInteger:buttonTag forKey:@"buttonTag"];
    [defaults synchronize];
}

- (NSString *)messageClickTime {
    return [defaults objectForKey:@"messageClickTime"];
}

- (void)setMessageClickTime:(NSString *)messageClickTime {
    [defaults setObject:messageClickTime forKey:@"messageClickTime"];
    [defaults synchronize];
}

- (int)messageCount {
    return [[defaults objectForKey:@"messageCount"] intValue];
}

- (void)setMessageCount:(int)messageCount {
    [defaults setObject:[NSNumber numberWithInt:messageCount] forKey:@"messageCount"];
    [defaults synchronize];
}

@end
