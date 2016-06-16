//
//  RecommendSceneModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendSceneModel : NSObject

@property (nonatomic, assign) int tag1_count;

@property (nonatomic, assign) int tag2_count;

@property (nonatomic, assign) int tag3_count;

@property (nonatomic, assign) int tag4_count;

@property (nonatomic, strong) NSString *tag1_product1_image;

@property (nonatomic, strong) NSString *tag1_product2_image;

@property (nonatomic, strong) NSString *tag1_product3_image;

@property (nonatomic, strong) NSString *tag2_product1_image;

@property (nonatomic, strong) NSString *tag2_product2_image;

@property (nonatomic, strong) NSString *tag2_product3_image;

@property (nonatomic, strong) NSString *tag3_product1_image;

@property (nonatomic, strong) NSString *tag3_product2_image;

@property (nonatomic, strong) NSString *tag3_product3_image;

@property (nonatomic, strong) NSString *tag4_product1_image;

@property (nonatomic, strong) NSString *tag4_product2_image;

@property (nonatomic, strong) NSString *tag4_product3_image;

@end
