//
//  PINUserDefaultManagement.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINUserDefaultManagement.h"
#import "PINUser.h"

@implementation PINUserDefaultManagement

+ (PINUserDefaultManagement *)instance {
    static PINUserDefaultManagement *userDefaultManagement = nil;
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

- (PINUser *)pinUser {
    if ([defaults objectForKey:@"pinUser"]) {
        id pinUser = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"pinUser"]];
        if ([pinUser isKindOfClass:CLASS(@"PINUser")]) {
            return pinUser;
        }
    }
    return nil;
}

- (void)setPinUser:(PINUser *)pinUser {
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:pinUser] forKey:@"pinUser"];
    [defaults synchronize];
}

- (NSString *)phone {
    return [defaults objectForKey:@"phone"];
}

- (void)setPhone:(NSString *)phone {
    [defaults setObject:phone forKey:@"phone"];
    [defaults synchronize];
}

// 取是否已经登录的标志
- (BOOL)isLogined {
    return [PINUserDefaultManagement instance].pinUser && [PINUserDefaultManagement instance].pinUser.guid > 0;
}

- (void)setIsLogined:(BOOL)isLogined {
    [defaults setBool:isLogined forKey:@"isLogined"];
    [defaults synchronize];
}

@end
