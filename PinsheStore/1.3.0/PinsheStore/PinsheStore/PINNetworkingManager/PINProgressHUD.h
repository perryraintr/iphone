//
//  PINProgressHUD.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/10.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINProgressHUD : NSObject

+ (void)startAnimationWithText:(NSString *)text hiddenDelay:(NSTimeInterval)delay;

+ (void)startAnimationHiddenDelay:(NSTimeInterval)delay;

+ (void)startAnimationWithText:(NSString *)text;

+ (void)startAnimation;

+ (void)stopAnimation;

@end
