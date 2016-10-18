//
//  PINUser.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINUser : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *wechat_id;

@property (nonatomic, assign) CGFloat current;

@property (nonatomic, assign) CGFloat amount;

@end
