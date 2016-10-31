//
//  PINStoreMemberModel.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/29.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINStoreMemberModel : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, assign) int store_guid;

@property (nonatomic, strong) NSString *store_name;

@property (nonatomic, strong) NSString *store_image;

@property (nonatomic, assign) int member_guid;

@property (nonatomic, strong) NSString *member_name;

@property (nonatomic, strong) NSString *member_avatar;

@property (nonatomic, strong) NSString *member_phone;

@end
