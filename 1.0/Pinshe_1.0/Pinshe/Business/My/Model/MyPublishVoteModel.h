//
//  MyPublishVoteModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPublishVoteModel : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, assign) int vote_guid;

@property (nonatomic, assign) int vote_user_id;

@property (nonatomic, strong) NSString *vote_name;

@property (nonatomic, assign) int vote_rate_a;

@property (nonatomic, assign) int vote_rate_b;

@property (nonatomic, assign) int vote_view;

@property (nonatomic, assign) int vote_comment;

@property (nonatomic, strong) NSString *vote_description;

@property (nonatomic, strong) NSString *vote_modify_time;

@property (nonatomic, strong) NSString *reply_name;

@property (nonatomic, strong) NSString *reply_modify_time;

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

@property (nonatomic, assign) int posta_price;

@property (nonatomic, strong) NSString *posta_address;

@property (nonatomic, strong) NSString *posta_brand;

@property (nonatomic, strong) NSString *posta_description;

@property (nonatomic, assign) int postb_guid;

@property (nonatomic, strong) NSString *postb_name;

@property (nonatomic, assign) int postb_view;

@property (nonatomic, assign) int postb_comment;

@property (nonatomic, assign) int postb_favorite;

@property (nonatomic, strong) NSString *postb_image;

@property (nonatomic, assign) int postb_price;

@property (nonatomic, strong) NSString *postb_brand;

@property (nonatomic, strong) NSString *postb_address;

@property (nonatomic, strong) NSString *postb_description;

@end
