//
//  MessageModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/20.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, assign) int type;

@property (nonatomic, assign) int vote_guid;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSString *modify_time;

@property (nonatomic, strong) NSString *modify_time1;

@property (nonatomic, assign) int post_guid;

@property (nonatomic, strong) NSString *post_image;

@property (nonatomic, strong) NSString *user_name;

@property (nonatomic, strong) NSString *user_avatar;

@end
