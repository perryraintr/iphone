//
//  MyWishPostModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWishPostModel : NSObject

@property (nonatomic, assign) int wish_guid;

@property (nonatomic, assign) int post_guid;

@property (nonatomic, assign) int type;

@property (nonatomic, strong) NSString *post_brand;

@property (nonatomic, strong) NSString *post_image;

@property (nonatomic, strong) NSString *post_name;

@property (nonatomic, assign) int post_price;

@property (nonatomic, strong) NSString *post_address;

@property (nonatomic, assign) int post_view;

@property (nonatomic, assign) int post_comment;

@property (nonatomic, assign) int post_favorite;

@property (nonatomic, strong) NSString *post_description;

@property (nonatomic, strong) NSString *post_modify_time;

@property (nonatomic, strong) NSString *user_name;

@property (nonatomic, strong) NSString *user_avatar;

@property (nonatomic, assign) int favorite_guid;

@end
