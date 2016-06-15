//
//  DetailVoteModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailVoteModel : NSObject

@property (nonatomic, assign) int vote_guid;

@property (nonatomic, assign) int vote_user_id;

@property (nonatomic, strong) NSString *vote_user_name;

@property (nonatomic, strong) NSString *vote_user_avatar;

@property (nonatomic, strong) NSString *vote_name;

@property (nonatomic, assign) int vote_count_a; // 左侧图百分比

@property (nonatomic, assign) int vote_count_b; // 右侧图百分比

@property (nonatomic, assign) int vote_view;

@property (nonatomic, assign) int vote_comment;

@property (nonatomic, assign) int vote_favorite;

@property (nonatomic, assign) int wish_guid; // >0已收藏标志

@property (nonatomic, assign) int favorite_guid; // >0已赞标志

@property (nonatomic, strong) NSString *vote_modify_time;

@property (nonatomic, strong) NSString *posta_image;

@property (nonatomic, assign) int producta_guid;

@property (nonatomic, strong) NSString *postb_image;

@property (nonatomic, assign) int productb_guid;

// 不需要网络解析
@property (nonatomic, assign) float vote_rate_a; // 左侧图百分比

@property (nonatomic, assign) float vote_rate_b; // 右侧图百分比

@end
