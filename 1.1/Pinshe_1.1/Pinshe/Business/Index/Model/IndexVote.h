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

@property (nonatomic, strong) NSString *vote_name;

@property (nonatomic, assign) int vote_count_a; // 左侧图百分比

@property (nonatomic, assign) int vote_count_b; // 右侧图百分比

@property (nonatomic, assign) int vote_view;

@property (nonatomic, assign) int vote_comment;

@property (nonatomic, strong) NSString *vote_modify_time;

@property (nonatomic, strong) NSString *usera_name;

@property (nonatomic, strong) NSString *usera_avatar;

@property (nonatomic, strong) NSString *userb_name;

@property (nonatomic, strong) NSString *userb_avatar;

@property (nonatomic, assign) int posta_guid;

@property (nonatomic, strong) NSString *posta_name;

@property (nonatomic, assign) int posta_view;

@property (nonatomic, assign) int posta_comment;

@property (nonatomic, assign) int posta_favorite;

@property (nonatomic, strong) NSString *posta_image;

@property (nonatomic, assign) float posta_price;

@property (nonatomic, strong) NSString *posta_address;

@property (nonatomic, strong) NSString *posta_brand;

@property (nonatomic, strong) NSString *postb_description;

@property (nonatomic, assign) int postb_guid;

@property (nonatomic, strong) NSString *postb_name;

@property (nonatomic, assign) int postb_view;

@property (nonatomic, assign) int postb_comment;

@property (nonatomic, assign) int postb_favorite;

@property (nonatomic, strong) NSString *postb_image;

@property (nonatomic, assign) float postb_price;

@property (nonatomic, strong) NSString *postb_address;

@property (nonatomic, strong) NSString *postb_brand;

@property (nonatomic, strong) NSString *posta_description;

// 不需要网络解析
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) float vote_rate_a; // 左侧图百分比

@property (nonatomic, assign) float vote_rate_b; // 右侧图百分比

- (float)vote_rate_a:(BOOL)isLeft;
- (float)vote_rate_b:(BOOL)isLeft;
@end
