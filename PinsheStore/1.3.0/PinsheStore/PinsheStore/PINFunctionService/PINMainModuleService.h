//
//  PINMainModuleService.h
//  PINNetworkingManager
//
//  Created by 史瑶荣 on 16/5/31.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINNetworking.h"

@class PINStoreModel;

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

/// 获取咖啡馆的WiFi信息
- (void)storeWifiModifyRequestWithSid:(int)sid wifi:(NSString *)wifi wifi_password:(NSString *)wifi_password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

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

/// 创建一个店铺
- (void)storeAddRequestWithStoreModel:(PINStoreModel *)model finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 修改某个咖啡馆的信息
- (void)storeModifyInfoRequestWithStoreModel:(PINStoreModel *)model isChangeAddress:(BOOL)isChange finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 提现账户列表
- (void)paymentListRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 添加提现列表
- (void)paymentAddRequestWithSid:(int)sid type:(int)type holder:(NSString *)holder account:(NSString *)account company:(NSString *)company finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 修改提现列表
- (void)paymentModifyRequestWithSid:(int)sid paymentid:(int)paymentid type:(int)type holder:(NSString *)holder account:(NSString *)account company:(NSString *)company finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 推送列表
- (void)storePushListRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 添加推送
- (void)storePushAddRequestWithSid:(int)sid name:(NSString *)name url:(NSString *)url images:(NSArray *)images imageNames:(NSArray *)imageNames finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 删除推送
- (void)storePushRemoveRequestWithGuid:(int)guid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

@end
