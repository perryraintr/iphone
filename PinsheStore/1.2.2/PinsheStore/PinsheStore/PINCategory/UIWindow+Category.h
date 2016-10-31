//
//  UIWindow+Category.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Category)

/// 当前 main Window
+ (nonnull UIWindow *)currentWindow;

/// 添加子视图到当前 Window
+ (void)addSubview:(nonnull UIView *)view;

@end
