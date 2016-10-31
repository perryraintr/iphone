//
//  UINavigationBar+SetColor.m
//  UINavigationBar
//
//  Created by shiyaorong on 16/1/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UINavigationBar+SetColor.h"
#import <objc/runtime.h>

static const char backViewKey;

@interface UINavigationBar ()

/**
 * 用runtime给类目动态创建属性
 * 正常情况下不能给类目添加新的属性，因为内存早就分配好了
 */
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation UINavigationBar (SetColor)

- (UIView *)backgroundView {
    return objc_getAssociatedObject(self, &backViewKey);
}

- (void)setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, &backViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)become_backgroundColor:(UIColor *)backgroundColor {
    if (!self.backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        /// UIViewAutoresizingFlexibleHeight
        /// 自动调整自己的高度, 保证与superView顶部和底部的距离不变。
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundView.userInteractionEnabled = NO;
        [self insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.backgroundColor = backgroundColor;
}

@end
