//
//  PINNetActivityIndicator.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/16.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINNetActivityIndicator : NSObject

+ (void)startActivityIndicator:(PinIndicatorStyle)indicatorStyle;

+ (void)stopActivityIndicator:(PinIndicatorStyle)indicatorStyle;

@end
