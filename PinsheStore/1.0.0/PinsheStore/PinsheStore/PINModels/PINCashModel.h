//
//  PINCashModel.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINCashModel : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, assign) float amount;

@property (nonatomic, assign) int type; // -1: 提现记录, 1: 咖啡下单纪录

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *order_order_no;

@property (nonatomic, assign) int store_guid;

@property (nonatomic, strong) NSString *store_name;

@property (nonatomic, strong) NSString *member_wechat_id;

@property (nonatomic, strong) NSString *member_name;

@property (nonatomic, assign) int member_guid;

@property (nonatomic, strong) NSString *create_time;

@end

