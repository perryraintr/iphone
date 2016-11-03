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

/// 添加一个用户
- (void)addMemberWithTelphone:(NSString *)telphone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 修改密码
- (void)memberModifyRequestWithGuid:(int)guid valid:(NSString *)valid password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

- (void)memberGeTuiModifyRequestWithGuid:(int)guid geTuiCid:(NSString *)getTuiCid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取用户信息
- (void)memberRequestWithTelphone:(NSString *)telphone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取某个咖啡馆的信息
- (void)storeInfoRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 修改某个咖啡馆的信息
- (void)storeModifyInfoRequestWithSid:(int)sid slogan:(NSString *)slogan dateStr:(NSString *)dateStr phone:(NSString *)phone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取用户是否有对应的咖啡店
- (void)storeRequestWithMid:(int)mid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取用户是否是某家咖啡馆的店员
- (void)storeMemberRequestWithMid:(int)mid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取咖啡馆所有的店员
- (void)storeMemberListRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 添加一个咖啡馆的店员
- (void)addStoreMemberWithMid:(int)mid sid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 删除一个咖啡馆的店员
- (void)removeStoreMemberWithGuid:(int)guid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取账单明细信息
- (void)cashRequestWithSid:(int)sid page:(int)page date:(NSString *)date finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 添加提现信息
- (void)cashAddRequestWithSid:(int)sid mid:(int)mid amount:(NSString *)amount finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 发送短信验证码
- (void)sendMsgRequestWithPhone:(NSString *)phone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 发送通知
- (void)wechatSendWithMessage:(NSString *)m;

/// 地址转换经纬度
- (void)addressChangeLocation:(NSString *)address finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取store特色1
- (void)store_feature1_imageWithFinished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 获取store特色2
- (void)store_feature2_imageWithFinished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

@end
