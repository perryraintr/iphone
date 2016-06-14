//
//  TopProductModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/3.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopProductModel : NSObject

@property (nonatomic, assign) int product_guid;

@property (nonatomic, strong) NSString *product_brand;

@property (nonatomic, strong) NSString *product_image;

@property (nonatomic, strong) NSString *product_name;

@property (nonatomic, assign) int product_price;

@property (nonatomic, strong) NSString *product_address;

@property (nonatomic, assign) int product_favorite;

@property (nonatomic, strong) NSString *product_description;

@property (nonatomic, strong) NSString *product_modify_time;

@property (nonatomic, assign) int user_count;

@property (nonatomic, strong) NSString *user1_avatar;

@property (nonatomic, strong) NSString *user2_avatar;

@property (nonatomic, strong) NSString *user3_avatar;

@end
