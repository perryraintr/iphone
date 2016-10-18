//
//  PINMainModuleService.m
//  PINNetworkingManager
//
//  Created by 史瑶荣 on 16/5/31.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINMainModuleService.h"
#import "PINNetworking.h"
#import "PINNetActivityIndicator.h"

static NSString *const kLoginPath = @"login.a";
static NSString *const kMemberPath = @"member.a";
static NSString *const kMemberAddPath = @"member_add.a";
static NSString *const kMemberModifyPath = @"member_modify.a";
static NSString *const kStorePath = @"store.a";
static NSString *const kCashPath = @"cash.a";
static NSString *const kCashAddPath = @"cash_add.a";
static NSString *const kYunPianPath = @"yunpian.a";
static NSString *const kWechatSendPath = @"wechat_send.a";

@interface PINMainModuleService ()

@property (nonatomic, strong) PINNetworkingManager *manger;

@end

@implementation PINMainModuleService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manger = [[PINNetworkingManager alloc] init];
    }
    return self;
}

/// 登录
- (void)loginRequestWithTelphone:(NSString *)telphone password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"phone=%@&password=%@", telphone, password];
    
    [_manger GET:kLoginPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        
        if (XONE_Dic_Is_NullValid(result)) {
            failure(result, message);
        } else {
            finished(result, message);
        }
        
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 注册
- (void)registerRequestWithTelphone:(NSString *)telphone code:(NSString *)code password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"phone=%@&code=%@&password=%@", telphone, code, password];
    
    [_manger GET:kMemberAddPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        
        if (XONE_Dic_Is_NullValid(result)) {
            failure(result, message);
        } else {
            finished(result, message);
        }
        
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 修改密码
- (void)memberModifyRequestWithGuid:(int)guid valid:(NSString *)valid password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"id=%zd&code=%@&password=%@", guid, valid, password];
    
    [_manger GET:kMemberModifyPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取用户信息
- (void)memberRequestWithTelphone:(NSString *)telphone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"phone=%@", telphone];
    
    [_manger GET:kMemberPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取用户是否有对应的咖啡店
- (void)storeRequestWithMid:(int)mid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"mid=%zd", mid];
    
    [_manger GET:kStorePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取账单明细信息
- (void)cashRequestWithSid:(int)sid page:(int)page finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd&page=%zd", sid, page];
    
    [_manger GET:kCashPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取账单明细信息
- (void)cashAddRequestWithSid:(int)sid mid:(int)mid amount:(NSString *)amount finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {

    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd&mid=%zd&amount=%@&oid=0&type=-1&status=0", sid, mid, amount];
    
    [_manger GET:kCashAddPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

- (void)sendMsgRequestWithPhone:(NSString *)phone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"phone=%@", phone];

    [_manger GET:kYunPianPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
    
}

/// 发送通知
- (void)wechatSendWithMessage:(NSString *)m {
    
    NSArray *wcidArr = @[@"o1D_JwGTL0ZN81hpxJSxflvtXQj8", @"o1D_JwFbCrjU1rPJdO6-ljRQC5qE", @"o1D_JwHikK5LBt_Y__Ukr9p4tKsY", @"o1D_JwGKMNWZmBYLxghYYw0GIlUg"];
    for (int i = 0; i < 4; i++) {
        NSString *paramStr = [NSString stringWithFormat:@"wcid=%@&m=%@", wcidArr[i], m];
        
        [_manger GET:kWechatSendPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        } failure:^(NSDictionary *result, NSString *message) {
        }];
    }
    
}

@end
