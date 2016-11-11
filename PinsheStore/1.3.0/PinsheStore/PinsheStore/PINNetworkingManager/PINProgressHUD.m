//
//  PINProgressHUD.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/10.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINProgressHUD.h"

@interface PINProgressHUD ()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation PINProgressHUD

+ (PINProgressHUD *)instance {
    static PINProgressHUD *progressHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD = [[PINProgressHUD alloc] init];
        progressHUD.progressHUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        [progressHUD.progressHUD removeFromSuperview];
        progressHUD.progressHUD.removeFromSuperViewOnHide = YES;
    });
    return progressHUD;
}

+ (void)startAnimationWithText:(NSString *)text hiddenDelay:(NSTimeInterval)delay {
    [PINProgressHUD instance].progressHUD.label.text = text;
    [PINProgressHUD startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PINProgressHUD stopAnimation];
    });
}

+ (void)startAnimationHiddenDelay:(NSTimeInterval)delay {
    [PINProgressHUD startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PINProgressHUD stopAnimation];
    });
}

+ (void)startAnimationWithText:(NSString *)text {
    [PINProgressHUD instance].progressHUD.label.text = text;
    [PINProgressHUD startAnimation];
}

+ (void)startAnimation {
    [[[UIApplication sharedApplication] keyWindow] addSubview:[PINProgressHUD instance].progressHUD];
    [[PINProgressHUD instance].progressHUD showAnimated:YES];
}

+ (void)stopAnimation {
    [PINProgressHUD instance].progressHUD.label.text = nil;
    [[PINProgressHUD instance].progressHUD hideAnimated:YES];
}

@end
