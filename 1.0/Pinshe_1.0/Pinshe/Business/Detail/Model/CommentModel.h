//
//  CommentModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, assign) int guid;

@property (nonatomic, assign) int user_guid;

@property (nonatomic, strong) NSString *user_name;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSString *reply_name;

@end
