//
//  PINConstant.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

extern NSString *const REQUEST_URL;
extern NSString *const REQUEST_HTML_URL;

typedef NS_ENUM (NSUInteger, PINIndicatorStyle) {
    PINIndicatorStyle_DefaultIndicator = 0,
    PINIndicatorStyle_NoStartIndicator,
    PINIndicatorStyle_NoStopIndicator,
    PINIndicatorStyle_NoIndicator,
};

@interface PINConstant : NSObject

AppDelegate *PINAppDelegate();

@end