//
//  CommonFunction.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate, PinTabBarController;

@interface CommonFunction : NSObject

AppDelegate *pinSheAppDelegate();

PinTabBarController *pinTabBarController();

BOOL validateMobile(NSString *mobile);

+ (NSString *)stringFromDateyyyy_MM_dd_HH_mm_ss:(NSDate *)aDate;

@end
