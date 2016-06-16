//
//  PINBaseRefreshSingleton.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/11.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINBaseRefreshSingleton.h"

@implementation PINBaseRefreshSingleton

+ (PINBaseRefreshSingleton *)instance {
    static PINBaseRefreshSingleton *pinBaseRefreshSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pinBaseRefreshSingleton = [[self alloc] init];
    });
    return pinBaseRefreshSingleton;
}



@end
