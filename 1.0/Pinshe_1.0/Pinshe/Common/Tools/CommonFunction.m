//
//  CommonFunction.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "CommonFunction.h"
#import "PinTabBarController.h"

@implementation CommonFunction

AppDelegate *pinSheAppDelegate() {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

PinTabBarController *pinTabBarController() {
    return (PinTabBarController *)pinSheAppDelegate().pinNavigationController.viewControllers.firstObject;
}

+ (NSString *)stringFromDateyyyy_MM_dd_HH_mm_ss:(NSDate *)aDate
{
    NSString *dateString = [[CommonFunction sharedDateFormatteryyyy_MM_dd_HH_mm_ss] stringFromDate:aDate];
    return [dateString length] > 0?dateString:@"";
}

+ (NSDateFormatter *)sharedDateFormatteryyyy_MM_dd_HH_mm_ss
{
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [_dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    });
    return _dateFormatter;
}

BOOL validateMobile(NSString *mobile) {
    NSString *mobileRegex = @"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

@end
