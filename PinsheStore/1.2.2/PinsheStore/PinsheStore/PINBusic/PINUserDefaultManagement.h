//
//  PINUserDefaultManagement.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PINUser;
@interface PINUserDefaultManagement : NSObject {
    NSUserDefaults *defaults;
}

+ (PINUserDefaultManagement *)instance;

@property (nonatomic, strong) PINUser *pinUser;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, assign) BOOL isLogined;

@property (nonatomic, assign) int sid;

@property (nonatomic, strong) NSString *storeName;

@property (nonatomic, assign) float storeCurrent;

@property (nonatomic, assign) BOOL hasStore;

@property (nonatomic, assign) BOOL isSotreMember;

@property (nonatomic, strong) NSString *getTuiCid;

@end
