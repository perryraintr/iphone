//
//  PINStoreFeatureModel.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/3.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINStoreFeatureModel : NSObject

@property (assign, nonatomic) int guid;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *url;

@property (assign, nonatomic) BOOL isChoosed;

@end
