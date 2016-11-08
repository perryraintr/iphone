//
//  PINConstant.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINConstant.h"

//NSString *const REQUEST_URL = @"http://192.168.1.96/v1/";
NSString *const REQUEST_URL = @"http://interface.pinshe.org/v1/";
NSString *const REQUEST_HTML_URL = @"http://www.pinshe.org/html/v1/";

int const UPLOADIMAGEWIDTH = 621;
int const UPLOADIMAGELENGTH = 0.30*1024*1024;

@implementation PINConstant

AppDelegate *PINAppDelegate() {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

PINTabBarController *pinTabBarController() {
    return (PINTabBarController *)PINAppDelegate().pinNavigationController.viewControllers.firstObject;
}

+ (void)cleanUserDefault {
    [PINUserDefaultManagement instance].sid = 0;
    [PINUserDefaultManagement instance].pinUser = nil;
}
@end
