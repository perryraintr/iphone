//
//  PINMainModuleService.m
//  PINNetworkingManager
//
//  Created by 史瑶荣 on 16/5/31.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINMainModuleService.h"
#import "PINNetworking.h"
#import "PINStoreModel.h"

static NSString *const kLoginPath = @"merchant_login.a";
static NSString *const kMemberPath = @"merchant.a";
static NSString *const kMemberAddPath = @"merchant_add.a";
static NSString *const kMemberModifyPath = @"merchant_modify.a";
static NSString *const kStorePath = @"store.a";
static NSString *const kStoreAddPath = @"store_add.a";
static NSString *const kStoreModifyPath = @"store_modify.a";
static NSString *const kStoreMemberPath = @"store_member.a";
static NSString *const kStoreMemberAddPath = @"store_member_add.a";
static NSString *const kStoreMemberRemovePath = @"store_member_remove.a";
static NSString *const kCashPath = @"store_cash.a";
static NSString *const kCashAddPath = @"store_cash_add.a";
static NSString *const kYunPianPath = @"yunpian.a";
static NSString *const kWechatSendPath = @"wechat_send.a";
static NSString *const kStoreFeature1Path = @"store_feature1_image.a";
static NSString *const kStoreFeature2Path = @"store_feature2_image.a";
static NSString *const kStorePaymentPath = @"store_payment.a";
static NSString *const kStorePaymentAddPath = @"store_payment_add.a";
static NSString *const kStorePaymentModifyPath = @"store_payment_modify.a";
static NSString *const kStorePushPath = @"store_push.a";
static NSString *const kStorePushAddPath = @"store_push_add.a";
static NSString *const kStorePushRemovePath = @"store_push_remove.a";

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
    
    if ([PINUserDefaultManagement instance].getTuiCid.length > 0) {
        paramStr = [NSString stringWithFormat:@"%@&getui=%@", paramStr, [PINUserDefaultManagement instance].getTuiCid];
    }
    
    [_manger GET:kLoginPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 注册
- (void)registerRequestWithTelphone:(NSString *)telphone code:(NSString *)code password:(NSString *)password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"phone=%@&code=%@&password=%@", telphone, code, password];
    
    [_manger GET:kMemberAddPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 添加一个用户
- (void)addMemberWithTelphone:(NSString *)telphone finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"phone=%@", telphone];
    
    [_manger GET:kMemberAddPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
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

/// 修改个推
- (void)memberGeTuiModifyRequestWithGuid:(int)guid geTuiCid:(NSString *)getTuiCid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"id=%zd&getui=%@&device=0", guid, getTuiCid];
    
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

/// 获取某个咖啡馆的信息
- (void)storeInfoRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"id=%zd", sid];
    
    [_manger GET:kStorePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取咖啡馆的WiFi信息
- (void)storeWifiModifyRequestWithSid:(int)sid wifi:(NSString *)wifi wifi_password:(NSString *)wifi_password finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"id=%zd&wifi=%@&wifi_password=%@", sid, wifi, wifi_password];
    
    [_manger GET:kStoreModifyPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
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

/// 获取用户是否是某家咖啡馆的店员
- (void)storeMemberRequestWithMid:(int)mid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"mid=%zd", mid];
    
    [_manger GET:kStoreMemberPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取咖啡馆所有的店员
- (void)storeMemberListRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd", sid];
    
    [_manger GET:kStoreMemberPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 添加一个咖啡馆的店员
- (void)addStoreMemberWithMid:(int)mid sid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"mid=%zd&sid=%zd", mid, sid];
    
    [_manger GET:kStoreMemberAddPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 删除一个咖啡馆的店员
- (void)removeStoreMemberWithGuid:(int)guid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"id=%zd", guid];
    
    [_manger GET:kStoreMemberRemovePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];

}

/// 获取账单明细信息
- (void)cashRequestWithSid:(int)sid page:(int)page date:(NSString *)date finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd&page=%zd", sid, page];
    if (date.length > 0) {
        paramStr = [NSString stringWithFormat:@"%@&date=%@", paramStr, date];
    }
    
    [_manger GET:kCashPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取账单明细信息
- (void)cashAddRequestWithSid:(int)sid mid:(int)mid amount:(NSString *)amount finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {

    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd&merchantid=%zd&amount=%@&oid=0&type=-1&status=0", sid, mid, amount];
    
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

    for (int i = 0; i < wcidArr.count; i++) {
        NSString *paramStr = [NSString stringWithFormat:@"wcid=%@%@", wcidArr[i], m];
        
        [_manger GET:kWechatSendPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        } failure:^(NSDictionary *result, NSString *message) {
        }];
    }
}

/// 地址转换经纬度
- (void)addressChangeLocation:(NSString *)address finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramString = [NSString stringWithFormat:@"key=%@&address=%@&batch=false", GeoKey, address];
    
    [_manger GETGEO:@"geo" params:paramString finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取store特色1
- (void)store_feature1_imageWithFinished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramString = @"page=1";
    
    [_manger GET:kStoreFeature1Path params:paramString finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 获取store特色2
- (void)store_feature2_imageWithFinished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramString = @"page=1";
    
    [_manger GET:kStoreFeature2Path params:paramString finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 创建一个店铺
- (void)storeAddRequestWithStoreModel:(PINStoreModel *)model finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:[PINUserDefaultManagement instance].pinUser.guid] forKey:@"mid"];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"is_delete"];
    [dic setObject:[NSNumber numberWithInt:30] forKey:@"star"];
    [dic setObject:[NSNumber numberWithInt:6] forKey:@"comment"];
    [dic setObject:model.owner forKey:@"owner"];
    [dic setObject:model.phone forKey:@"phone"];
    [dic setObject:model.name forKey:@"name"];
    [dic setObject:model.slogan forKey:@"slogan"];
    [dic setObject:model.storeDescription forKey:@"description"];
    [dic setObject:model.date forKey:@"date"];
    [dic setObject:model.feature1 forKey:@"feature1s"];
    [dic setObject:model.feature2 forKey:@"feature2s"];
    [dic setObject:model.feature3?:@"" forKey:@"feature3"];
    [dic setObject:model.address forKey:@"address"];
    [dic setObject:[NSNumber numberWithDouble:model.longitude] forKey:@"longitude"];
    [dic setObject:[NSNumber numberWithDouble:model.latitude] forKey:@"latitude"];
    
    PLog(@"%@-- %@ -- %@ -- %@", model.avatarImage, model.avatarImageName, model.imageNames, model.images);
    [_manger UploadImagesWithMethodName:kStoreAddPath params:dic avatarImageName:model.avatarImageName avatarImage:model.avatarImage imageNames:model.imageNames images:model.images finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];

}

/// 修改某个咖啡馆的信息
- (void)storeModifyInfoRequestWithStoreModel:(PINStoreModel *)model isChangeAddress:(BOOL)isChange finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:model.guid] forKey:@"id"];
    [dic setObject:model.owner forKey:@"owner"];
    [dic setObject:model.phone forKey:@"phone"];
    [dic setObject:model.name forKey:@"name"];
    [dic setObject:model.slogan forKey:@"slogan"];
    [dic setObject:model.storeDescription forKey:@"description"];
    [dic setObject:model.address forKey:@"address"];
    [dic setObject:model.date forKey:@"date"];
    [dic setObject:model.feature1 forKey:@"feature1s"];
    [dic setObject:model.feature2 forKey:@"feature2s"];
    [dic setObject:model.feature3?:@"" forKey:@"feature3"];
    
    if (isChange) {
        [dic setObject:model.address forKey:@"address"];
        [dic setObject:[NSNumber numberWithDouble:model.longitude] forKey:@"longitude"];
        [dic setObject:[NSNumber numberWithDouble:model.latitude] forKey:@"latitude"];
    }
    
    id avatar = nil;
    if (model.avatarImage) {
        avatar = model.avatarImage;
    } else {
        avatar = model.avatar;
    }
    PLog(@"%@-- %@ -- %@ -- %@", avatar, model.avatarImageName, model.imageNames, model.images);
    [_manger UploadImagesWithMethodName:kStoreModifyPath params:dic avatarImageName:model.avatarImageName avatarImage:avatar imageNames:model.imageNames images:model.images finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 提现账户列表
- (void)paymentListRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd", sid];

    [_manger GET:kStorePaymentPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 添加提现列表
- (void)paymentAddRequestWithSid:(int)sid type:(int)type holder:(NSString *)holder account:(NSString *)account company:(NSString *)company finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd&type=%zd&holder=%@&account=%@&company=%@", sid, type, holder, account, company];
    
    [_manger GET:kStorePaymentAddPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 修改提现列表
- (void)paymentModifyRequestWithSid:(int)sid paymentid:(int)paymentid type:(int)type holder:(NSString *)holder account:(NSString *)account company:(NSString *)company finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd&id=%zd&type=%zd&holder=%@&account=%@&company=%@", sid, paymentid, type, holder, account, company];
    
    [_manger GET:kStorePaymentModifyPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 推送列表
- (void)storePushListRequestWithSid:(int)sid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"sid=%zd", sid];
    
    [_manger GET:kStorePushPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

/// 添加推送
- (void)storePushAddRequestWithSid:(int)sid name:(NSString *)name url:(NSString *)url images:(NSArray *)images imageNames:(NSArray *)imageNames finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:[PINUserDefaultManagement instance].sid] forKey:@"sid"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:url forKey:@"url"];
    
    [_manger UploadImagesWithMethodName:kStorePushAddPath params:dic avatarImageName:@"" avatarImage:nil imageNames:imageNames images:images finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
    
}

/// 删除推送
- (void)storePushRemoveRequestWithGuid:(int)guid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"id=%zd", guid];
    
    [_manger GET:kStorePushRemovePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];

}

@end
