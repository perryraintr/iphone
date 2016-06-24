//
//  MyWishModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyWishPostModel, MyWishVoteModel;
@interface MyWishModel : NSObject

@property (nonatomic, assign) PinMyCentralType type;

@property (nonatomic, strong) MyWishVoteModel *myVoteModel;

@property (nonatomic, strong) MyWishPostModel *myPostModel;

@end
