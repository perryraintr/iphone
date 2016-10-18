//
//  NSObject+HUD.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HUD)

@end


@interface UIView (hint)
/**
 *  @author shiyaorong, 16-09-12 13:49:51
 *
 *  在View上添加showHint
 */

- (void)chatShowHint:(NSString *)hint;

@end


@interface UIViewController (HUD)
/**
 *  @author shiyaorong, 16-09-12 13:49:51
 *
 *  在UIViewController上添加showHint
 */

- (void)chatShowHint:(NSString *)hint;

@end

