//
//  PINStoreModel.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINStoreModel : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *create_time;

@property (nonatomic, strong) NSString *feature1;

@property (nonatomic, strong) NSString *owner;

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, strong) NSString *video;

@property (nonatomic, strong) NSString *activity;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *feature2;

@property (nonatomic, strong) NSString *slogan;

@property (nonatomic, strong) NSString *date;

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, assign) int star;

@property (nonatomic, strong) NSString *recommend;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *feature3;

@property (nonatomic, strong) NSString *modify_time;

@property (nonatomic, assign) int comment;

@property (nonatomic, strong) NSString *address;

@end
