//
//  BaseNetworkManager.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "BaseNetworkManager.h"
#import "AFHTTPRequestOperationManager+AutoRetry.h"

@implementation BaseNetworkManager

- (void)pinRequestByGet:(NSString *)requestParams withMethodName:(NSString *)methodName withMethodBack:(NSString *)methodBack withUserInfo:(NSMutableDictionary *)userInfo withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    NSString *requestUrl = getRequestUrl();
    
    NSString *urlString = @"";
    urlString = [NSString stringWithFormat:@"%@%@?%@", requestUrl, methodName, requestParams];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    PLog(@"requestUrl==>%@\n-----------------------------------------------------%@\n", methodBack, urlString);
    
    NSMutableDictionary *methodBackInfo = [NSMutableDictionary dictionary];
    if (userInfo.count > 0) {
        [methodBackInfo setObject:userInfo forKey:@"userInfo"];
    }
    if (methodBack) {
        [methodBackInfo setObject:methodBack forKey:@"methodBack"];
    }
    if (methodName) {
        [methodBackInfo setObject:methodName forKey:@"methodName"];
    }
    
    [methodBackInfo setObject:[NSString stringWithFormat:@"%tu", indicatorStyle] forKey:@"indicatorStyle"];

    weakSelf(self);
    [self.requestOperationManager GET:urlString parameters:[NSDictionary dictionary] methodBackInfo:methodBackInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf networkRequestFinished:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf networkRequestFailed:operation];
    } autoRetry:0];
}

- (void)pinRequestByPost:(NSMutableDictionary *)reqDic withMethodName:(NSString *)methodName withMethodBack:(NSString *)methodBack withUserInfo:(NSMutableDictionary *)userInfo withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    NSString *requestUrl = getRequestUrl();
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", requestUrl, methodName];

    PLog(@"requestUrl==>%@\n-----------------------------------------------------%@\npostString=====>\n%@\n", methodBack, urlString, paramsFromDictionary(reqDic));
    
    NSMutableDictionary *methodBackInfo = [NSMutableDictionary dictionary];
    if (userInfo.count > 0) {
        [methodBackInfo setObject:userInfo forKey:@"userInfo"];
    }
    if (methodBack) {
        [methodBackInfo setObject:methodBack forKey:@"methodBack"];
    }
    if (methodName) {
        [methodBackInfo setObject:methodName forKey:@"methodName"];
    }
    [methodBackInfo setObject:[NSString stringWithFormat:@"%tu", indicatorStyle] forKey:@"indicatorStyle"];
    
    weakSelf(self);
    [self.requestOperationManager POST:urlString parameters:reqDic methodBackInfo:methodBackInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf networkRequestFinished:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf networkRequestFailed:operation];
    } autoRetry:0];
}

- (void)pinPostImageData:(NSMutableDictionary *)reqDic withMethodName:(NSString *)methodName withMethodBack:(NSString *)methodBack withUserInfo:(NSMutableDictionary *)userInfo withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    NSString *requestUrl = getRequestUrl();
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", requestUrl, methodName];

    PLog(@"requestUrl==>%@\n-----------------------------------------------------%@\npostString=====>\n%@\n", methodBack, urlString, paramsFromDictionary(reqDic));
    
    NSMutableDictionary *methodBackInfo = [NSMutableDictionary dictionary];
    if (userInfo.count > 0) {
        [methodBackInfo setObject:userInfo forKey:@"userInfo"];
    }
    if (methodBack) {
        [methodBackInfo setObject:methodBack forKey:@"methodBack"];
    }
    if (methodName) {
        [methodBackInfo setObject:methodName forKey:@"methodName"];
    }
    [methodBackInfo setObject:[NSString stringWithFormat:@"%tu", indicatorStyle] forKey:@"indicatorStyle"];
    
    weakSelf(self);
    [self.requestOperationManager POST:urlString parameters:reqDic methodBackInfo:methodBackInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSArray *imageArray = [reqDic objectForKey:@"imageArray"];
        NSArray *fileNameArray = [reqDic objectForKey:@"fileNameArray"];

        for (int i = 0; i < imageArray.count; i++) {
            id imageSource = [imageArray objectAtIndex:i];
            NSString *fileName = [fileNameArray objectAtIndex:i];
            if ([imageSource isKindOfClass:[UIImage class]]) {
                NSData *imageData = UIImageJPEGRepresentation(imageSource, 0.3);
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:[reqDic objectForKey:@"key"] fileName:fileName mimeType:([fileName hasSuffix:@"png"] ? @"image/png" : @"image/jpg")];
                }
            } else {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageSource]];
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:[reqDic objectForKey:@"key"] fileName:fileName mimeType:([fileName hasSuffix:@"png"] ? @"image/png" : @"image/jpg")];
                }
            }
        }

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf networkRequestFinished:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf networkRequestFailed:operation];
    } autoRetry:0];
}

- (void)setDelegate:(id<BaseNetworkManagerDelegate>)newDelegate {
    _delegate = newDelegate;
    _delegateCan.requestFinished = [_delegate respondsToSelector:@selector(requestFinished:)];
    _delegateCan.requestFailed = [_delegate respondsToSelector:@selector(requestFailed:)];
    _delegateCan.startActivityIndicatorView = [_delegate respondsToSelector:@selector(startActivityIndicatorView:)];
}

- (void)networkRequestFinished:(AFHTTPRequestOperation *)request {
    PLog(@"requestFinished==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n",request.methodBack, request.responseString);
    if (_delegateCan.requestFinished) {
        [self.delegate requestFinished:[self getResponseResult:request]];
    }
}

- (void)networkRequestFailed:(AFHTTPRequestOperation *)request {
    PLog(@"requestFailed:==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", request.methodBack,request.responseString);
    if (_delegateCan.requestFailed) {
        [self.delegate requestFailed:[self getResponseResult:request]];
    }
}

- (PinResponseResult *)getResponseResult:(AFHTTPRequestOperation *)request {
    PinResponseResult *responseResult = [[PinResponseResult alloc] init];
    responseResult.responseData = request.responseData;
    responseResult.responseString = request.responseString;
    responseResult.error = request.error;
    responseResult.methodBack = request.methodBack;
    responseResult.userInfo = request.userInfo;
    responseResult.indicatorStyle = request.indicatorStyle;
    return responseResult;
}

- (void)cancelAllRequest {
    AFHTTPRequestOperationManager *requestOperationManager = [AFHTTPRequestOperationManager manager];
    [requestOperationManager.operationQueue cancelAllOperations];
}

- (AFHTTPRequestOperationManager *)requestOperationManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 30.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/xml", @"text/html", @"text/javascript", @"application/x-7z-compressed", @"image/gif", @"image/jpeg", @"image/png", @"application/pdf", @"application/octet-stream", @"application/x-zip-compressed", @"text/plain", nil];

//    [manager.requestSerializer setValue:[CommonFunction getUserAgent] forHTTPHeaderField:@"User-Agent"];
    //支持Https
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    return manager;
}

@end
