//
//  NSObject+UMobClick.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/17.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UMobClick)

+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;

@end
