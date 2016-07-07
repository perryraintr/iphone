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

@property (nonatomic, strong) NSString *vote_name;

@property (nonatomic, strong) NSString *vote_description;

@property (nonatomic, strong) NSString *vote_modify_time;

@property (nonatomic, strong) NSString *posta_image;

@property (nonatomic, strong) NSString *posta_description;

@property (nonatomic, strong) NSString *postb_image;

@end
