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

@property (nonatomic, assign) float current;

@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) double latitude;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int star;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *slogan;

@property (nonatomic, strong) NSString *owner;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, strong) NSString *avatarImageName;

@property (nonatomic, strong) NSString *recommend;

@property (nonatomic, strong) NSString *feature1;

@property (nonatomic, strong) NSString *feature2;

@property (nonatomic, strong) NSString *feature3;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *video;

@property (nonatomic, strong) NSString *activity;

@property (nonatomic, assign) float comment;

@property (nonatomic, strong) NSString *wifi;

@property (nonatomic, strong) NSString *wifi_password;

@property (nonatomic, assign) int invaild;

@property (nonatomic, strong) NSString *storeDescription;

@property (nonatomic, strong) NSString *create_time;

@property (nonatomic, strong) NSString *modify_time;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSMutableArray *imageNames;

@property (nonatomic, strong) NSArray *feature1s;

@property (nonatomic, strong) NSArray *feature2s;

@property (nonatomic, assign) int is_delete;

@property (nonatomic, strong) NSArray *resultFeature1;

@property (nonatomic, strong) NSArray *resultFeature2;

@end
