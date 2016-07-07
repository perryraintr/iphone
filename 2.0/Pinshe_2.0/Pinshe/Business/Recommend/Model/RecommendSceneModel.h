//
//  RecommendSceneModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendSceneModel : NSObject

@property (nonatomic, assign) int tag_guid;

@property (nonatomic, assign) int tag_t1;

@property (nonatomic, assign) int tag_t2;

@property (nonatomic, assign) int tag_count;

@property (nonatomic, strong) NSString *tag_name;

@property (nonatomic, strong) NSString *tag_description;

@property (nonatomic, strong) NSString *tag_product1_guid;

@property (nonatomic, strong) NSString *tag_product1_image;

@property (nonatomic, strong) NSString *tag_product2_guid;

@property (nonatomic, strong) NSString *tag_product2_image;

@property (nonatomic, strong) NSString *tag_product3_guid;

@property (nonatomic, strong) NSString *tag_product3_image;

@end
