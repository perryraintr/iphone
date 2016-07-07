//
//  MyPublishModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyPublishVoteModel, MyPublishPostModel;
@interface MyPublishModel : NSObject

@property (nonatomic, assign) PinMyCentralType type;

@property (nonatomic, strong) MyPublishVoteModel *myVoteModel;

@property (nonatomic, strong) MyPublishPostModel *myPostModel;

@end
