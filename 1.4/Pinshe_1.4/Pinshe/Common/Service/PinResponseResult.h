//
//  PinResponseResult.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinResponseResult : NSObject

@property (nonatomic, strong) NSData *responseData; // 接口返回数据
@property (nonatomic, copy) NSString *responseString; // 接口返回的json
@property (nonatomic, strong) NSError *error; // 错误信息
@property (nonatomic, strong) NSString *methodBack; // 接口请求方法返回
@property (nonatomic, strong) id userInfo; // 接口请求传参
@property (nonatomic, strong) NSString *indicatorStyle;

@end
