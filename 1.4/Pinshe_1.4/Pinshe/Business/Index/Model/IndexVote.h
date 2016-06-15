//
//  IndexVote.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/18.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexVote : NSObject

@property (nonatomic, assign) int vote_guid;

@property (nonatomic, assign) int vote_user_id;

@property (nonatomic, strong) NSString *vote_user_name;

@property (nonatomic, strong) NSString *vote_user_avatar;

@property (nonatomic, strong) NSString *vote_name;

@property (nonatomic, assign) int vote_count_a; // 左侧图百分比

@property (nonatomic, assign) int vote_count_b; // 右侧图百分比

@property (nonatomic, assign) int vote_view;

@property (nonatomic, assign) int vote_comment;

@property (nonatomic, strong) NSString *vote_modify_time;

@property (nonatomic, strong) NSString *posta_image;

@property (nonatomic, strong) NSString *postb_image;

@property (nonatomic, assign) int product_a_guid;

@property (nonatomic, strong) NSString *product_a_name;

@property (nonatomic, strong) NSString *product_a_image;

@property (nonatomic, assign) float product_a_price;

@property (nonatomic, strong) NSString *product_a_brand;

@property (nonatomic, assign) int product_b_guid;

@property (nonatomic, strong) NSString *product_b_name;

@property (nonatomic, strong) NSString *product_b_image;

@property (nonatomic, assign) float product_b_price;

@property (nonatomic, strong) NSString *product_b_brand;

// 不需要网络解析
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, assign) BOOL isLeft;

@property (nonatomic, assign) float vote_rate_a; // 左侧图百分比

@property (nonatomic, assign) float vote_rate_b; // 右侧图百分比

- (float)vote_rate_a:(BOOL)isLeft;
- (float)vote_rate_b:(BOOL)isLeft;
@end
