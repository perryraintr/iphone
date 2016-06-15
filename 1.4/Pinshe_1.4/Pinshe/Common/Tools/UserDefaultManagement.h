//
//  UserDefaultManagement.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PinUser;
@interface UserDefaultManagement : NSObject {
    NSUserDefaults *defaults;
}

+ (UserDefaultManagement *)instance;

@property (nonatomic, strong) NSString *debugRequestUrl;

@property (nonatomic, strong) NSString *indexShareResult;

@property (nonatomic, assign) BOOL haveUserId;

@property (nonatomic, assign) int userId;

@property (nonatomic, assign) BOOL isLogined;

@property (nonatomic, strong) PinUser *pinUser;

// 第二个tab，navigationBar点击
@property (nonatomic, assign) NSInteger buttonTag;

@property (nonatomic, strong) NSString *messageClickTime;

@property (nonatomic, assign) int messageCount;

@end
