//
//  PINNetworkingConfig.h
//  PINNetworkingManager
//
//  Created by 雷亮 on 16/5/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#pragma mark -
#pragma mark - 数据回调
typedef void (^PINServiceCallback) (NSDictionary *result, NSString *message);

typedef void(^PINServiceFailure) (NSDictionary *result, NSString *message);

#pragma mark -
#pragma mark - 请求完成状态
/// 此处根据返回的Head值进行修改
typedef NS_ENUM(NSUInteger, PINServiceTag) {
    PINServiceTag_Success = 1,
    PINServiceTag_Error = 0,
};



