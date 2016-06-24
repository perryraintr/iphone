//
//  PINNetworkingManager.m
//  PINNetworkingManager
//
//  Created by 雷亮 on 16/5/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PINNetworkingManager.h"
#import "AFNetworking.h"

/// 超时时间
static float const kTimeoutInterval = 30.f;
static NSString *const kServiceSuccessMessage = @"请求成功";
static NSString *const kServiceErrorMessage = @"请求失败";
static NSString *kUploadImageName = @"file";

@implementation PINNetworkingManager

/// GET
- (void)GET:(NSString *)methodName params:(id)params finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    NSString *requestUrl = getRequestUrl();
    NSString *urlString = @"";
    urlString = [NSString stringWithFormat:@"%@%@?%@", requestUrl, methodName, params];
    
    PLog(@"requestUrl==>%@\n-----------------------------------------------------%@\n", methodName, urlString);
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseObject];
        if (pinBaseModel.head == 1) {
            finished(pinBaseModel.body, requestErrorWithCode(PINServiceTag_Success));
        } else {
            failure(pinBaseModel.body, requestErrorWithCode(PINServiceTag_Error));
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PLog(@"requestFinished：error：%zd ==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", pinBaseModel.head, methodName,
                 [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLog(@"requestFailed:==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", methodName, @"失败");
        failure(nil, requestErrorWithCode(PINServiceTag_Error));
    }];
}

/// POST
- (void)POST:(NSString *)methodName params:(NSDictionary *)params finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    NSString *requestUrl = getRequestUrl();
    NSString *urlString = @"";
    urlString = [NSString stringWithFormat:@"%@%@?", requestUrl, methodName];
    
    PLog(@"requestUrl==>%@\n-----------------------------------------------------%@\npostString=====>\n%@\n", methodName, urlString, paramsFromDictionary(params));
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseObject];
        if (pinBaseModel.head == 1) {
            finished(pinBaseModel.body, requestErrorWithCode(PINServiceTag_Success));
        } else {
            failure(pinBaseModel.body, requestErrorWithCode(PINServiceTag_Error));
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PLog(@"requestFinished：error：%zd ==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", pinBaseModel.head, methodName,
                 [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLog(@"requestFailed:==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", methodName, @"失败");
        failure(nil, requestErrorWithCode(PINServiceTag_Error));
    }];
}

/**
 * Upload Images
 * imageNames ：图片名 @[@"image.png", ...] 需要带有后缀
 * images ：要上传的图片
 */
- (void)UploadImagesWithMethodName:(NSString *)methodName params:(NSDictionary *)params imageNames:(NSArray <NSString *>*)imageNames images:(NSArray *)images finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];

    NSString *requestUrl = getRequestUrl();
    NSString *urlString = @"";
    urlString = [NSString stringWithFormat:@"%@%@?", requestUrl, methodName];
    
    PLog(@"requestUrl==>%@\n-----------------------------------------------------%@\npostString=====>\n%@\n", methodName, urlString, paramsFromDictionary(params));
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *fileName = imageNames[idx];
            
            if ([obj isKindOfClass:[UIImage class]]) {
                NSData *imageData = UIImageJPEGRepresentation(obj, 0.3);
                [formData appendPartWithFileData:imageData name:kUploadImageName fileName:fileName mimeType:([fileName hasSuffix:@"png"] ? @"image/png" : @"image/jpg")];
            } else {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
                [formData appendPartWithFileData:imageData name:kUploadImageName fileName:fileName mimeType:([fileName hasSuffix:@"png"] ? @"image/png" : @"image/jpg")];
            }
        }];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseObject];

        if (pinBaseModel.head == 1) {
            finished(pinBaseModel.body, requestErrorWithCode(PINServiceTag_Success));
        } else {
            failure(pinBaseModel.body, requestErrorWithCode(PINServiceTag_Error));
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PLog(@"requestFinished：error：%zd ==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", pinBaseModel.head, methodName,
                 [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLog(@"requestFailed:==>%@\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n%@\n~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~\n\n", methodName, @"失败");
        failure(nil, requestErrorWithCode(PINServiceTag_Error));
    }];
}

NSString *requestErrorWithCode(PINServiceTag code) {
    switch (code) {
        case PINServiceTag_Success:
        {
            return kServiceSuccessMessage;
            break;
        }
        case PINServiceTag_Error:
        {
            return kServiceErrorMessage;
            break;
        }
        default:
            return kServiceErrorMessage;
            break;
    }
}

NSString *getRequestUrl(void) {
    NSString *requestUrl = REQUEST_URL;
#ifdef DEBUG
    if ([[UserDefaultManagement instance].debugRequestUrl length] > 0) {
        requestUrl = [UserDefaultManagement instance].debugRequestUrl;
    }
#endif
    return requestUrl;
}

@end
