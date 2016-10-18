//
//  PINMainModuleService.h
//  PINNetworkingManager
//
//  Created by 史瑶荣 on 16/5/31.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINNetworking.h"

@interface PINMainModuleService : NSObject

/// 以下是请求返回的数据，在controller里面使用的数据

/// 登录
- (void)loginRequestWithTelphone:(NSString *)telphone password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 注册
- (void)registerRequestWithTelphone:(NSString *)telphone code:(NSString *)code password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 修改密码
- (void)memberModifyRequestWithGuid:(int)guid valid:(NSString *)valid password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取用户信息
- (void)memberRequestWithTelphone:(NSString *)telphone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取用户是否有对应的咖啡店
- (void)storeRequestWithMid:(int)mid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取账单明细信息
- (void)cashRequestWithSid:(int)sid page:(int)page finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 添加提现信息
- (void)cashAddRequestWithSid:(int)sid mid:(int)mid amount:(NSString *)amount finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 发送短信验证码
- (void)sendMsgRequestWithPhone:(NSString *)phone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 发送通知
- (void)wechatSendWithMessage:(NSString *)m;

@end
