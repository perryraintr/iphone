//
//  UIView+ClickOn.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIView+ClickOn.h"
#import <objc/runtime.h>

static char completionClickOnKey;

@interface UIView ()

@property (nonatomic, copy) CompletionClickOn completionClickOn;

@end

@implementation UIView (ClickOn)

- (CompletionClickOn)completionClickOn {
    return objc_getAssociatedObject(self, &completionClickOnKey);
}

- (void)setCompletionClickOn:(CompletionClickOn)completionClickOn {
    objc_setAssociatedObject(self, &completionClickOnKey, completionClickOn, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)clickedOnViewWithCompletion:(CompletionClickOn)completion {
    /// 开启交互
    self.userInteractionEnabled = YES;
    /// 添加点击方法
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[self class] action:@selector(clickOnViewWithTap:)];
    TapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:TapGestureRecognizer];
    /// block 赋值
    self.completionClickOn = completion;
}

+ (void)clickOnViewWithTap:(UITapGestureRecognizer *)sender {
    sender.view.completionClickOn(sender.view);
}

@end
