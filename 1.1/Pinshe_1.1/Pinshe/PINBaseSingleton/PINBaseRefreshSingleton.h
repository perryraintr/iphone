//
//  PINBaseRefreshSingleton.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/11.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINBaseRefreshSingleton : NSObject

+ (PINBaseRefreshSingleton *)instance;

@property (nonatomic, assign) int refreshRecommend;
@property (nonatomic, assign) int refreshShit;
@property (nonatomic, assign) int refreshCompare;

@property (nonatomic, assign) int refreshTopGoodsList;

@property (nonatomic, assign) int refreshMyCentralCollection;
@property (nonatomic, assign) int refreshMyCentralPublish;

@end
