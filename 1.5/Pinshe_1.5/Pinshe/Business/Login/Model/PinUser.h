//
//  PinUser.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/22.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinUser : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *wechat;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *modify_time;

@end
