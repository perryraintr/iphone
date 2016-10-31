//
//  UIWindow+Category.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIWindow+Category.h"

@implementation UIWindow (Category)

+ (nonnull UIWindow *)currentWindow {
    return PINAppDelegate().window;
}

+ (void)addSubview:(nonnull UIView *)view {
    [[UIWindow currentWindow] addSubview:view];
}

@end
