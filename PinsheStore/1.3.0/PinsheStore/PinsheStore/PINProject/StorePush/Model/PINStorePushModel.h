//
//  PINStorePushModel.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINStorePushModel : NSObject

@property (assign, nonatomic) int guid;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) NSString *image;

@end
