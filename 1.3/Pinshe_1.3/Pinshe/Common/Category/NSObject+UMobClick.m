//
//  NSObject+UMobClick.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/17.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "NSObject+UMobClick.h"

@implementation NSObject (UMobClick)

+ (void)event:(NSString *)eventId label:(NSString *)label {
    @try {
        [MobClick event:eventId label:label];
    } @catch (NSException *exception) {
        PLog(@"reason:%@\ncallStackSymbols:%@", exception.reason, exception.callStackSymbols);
    }
} // label为nil或@""时，等同于 event:eventId label:eventId;


@end
