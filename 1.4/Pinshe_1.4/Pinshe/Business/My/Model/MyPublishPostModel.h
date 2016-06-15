//
//  MyPublishPostModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPublishPostModel : NSObject

@property (nonatomic, strong) NSArray<NSNumber *> *tag_t2;

@property (nonatomic, assign) int guid;

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

@property (nonatomic, strong) NSString *reply_name;

@property (nonatomic, strong) NSString *reply_modify_time;

@end
