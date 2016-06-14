//
//  BaseNetworkManager.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinResponseResult.h"

@protocol BaseNetworkManagerDelegate <NSObject>

@required
- (void)requestFinished:(PinResponseResult *)request;
- (void)requestFailed:(PinResponseResult *)request;

@end

@interface BaseNetworkManager : NSObject {
    struct {
        unsigned requestFinished : 1;
        unsigned requestFailed : 1;
        unsigned startActivityIndicatorView: 1;
    } _delegateCan;
}

@property (nonatomic, weak) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, weak) id <BaseNetworkManagerDelegate>delegate;

- (void)pinRequestByGet:(NSString *)requestParams withMethodName:(NSString *)methodName withMethodBack:(NSString *)methodBack withUserInfo:(NSMutableDictionary *)userInfo withIndicatorStyle:(PinIndicatorStyle)indicatorStyle;

- (void)pinRequestByPost:(NSMutableDictionary *)reqDic withMethodName:(NSString *)methodName withMethodBack:(NSString *)methodBack withUserInfo:(NSMutableDictionary *)userInfo withIndicatorStyle:(PinIndicatorStyle)indicatorStyle;

- (void)pinPostImageData:(NSMutableDictionary *)reqDic withMethodName:(NSString *)methodName withMethodBack:(NSString *)methodBack withUserInfo:(NSMutableDictionary *)userInfo withIndicatorStyle:(PinIndicatorStyle)indicatorStyle;

- (void)cancelAllRequest;

@end
