//
//  DetailRecommendModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailRecommendModel : NSObject

@property (nonatomic, assign) int tag_t1_id;

@property (nonatomic, strong) NSString *tag_t1;

@property (nonatomic, strong) NSArray<NSString *> *tag_t2;

@property (nonatomic, assign) int user_guid;

@property (nonatomic, strong) NSString *user_name;

@property (nonatomic, strong) NSString *user_avatar;

@property (nonatomic, assign) int wish_guid; // >0已收藏标志

@property (nonatomic, assign) int favorite_guid; // >0已赞标志

@property (nonatomic, assign) int post_guid;

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

@end
