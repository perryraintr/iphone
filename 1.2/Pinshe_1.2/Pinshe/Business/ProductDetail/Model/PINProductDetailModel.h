//
//  PINProductDetailModel.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINProductDetailModel : NSObject

@property (nonatomic, strong) NSString *tag_t1;

@property (nonatomic, strong) NSArray<NSString *> *tag_t2;

@property (nonatomic, assign) int product_guid;

@property (nonatomic, strong) NSString *product_name;

@property (nonatomic, assign) int product_favorite;

@property (nonatomic, strong) NSString *product_image;

@property (nonatomic, assign) float product_price;

@property (nonatomic, strong) NSString *product_address;

@property (nonatomic, strong) NSString *product_brand;

@property (nonatomic, strong) NSString *product_description;

@property (nonatomic, strong) NSString *product_modify_time;

@property (nonatomic, strong) NSArray<NSString *> *product_images;

@end
