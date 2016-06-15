//
//  AFHTTPRequestOperationManager+AutoRetry.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "AFHTTPRequestOperationManager+AutoRetry.h"
#import "ObjcAssociatedObjectHelpers.h"

@implementation AFHTTPRequestOperationManager (AutoRetry)

SYNTHESIZE_ASC_OBJ(__operationsDict, setOperationsDict);
SYNTHESIZE_ASC_OBJ(__retryDelayCalcBlock, setRetryDelayCalcBlock);

- (void)createOperationsDict {
    [self setOperationsDict:[[NSDictionary alloc] init]];
}

- (void)createDelayRetryCalcBlock {
    RetryDelayCalcBlock block = ^int(int totalRetries, int currentRetry, int delayInSecondsSpecified) {
        return delayInSecondsSpecified;
    };
    [self setRetryDelayCalcBlock:block];
}

- (id)retryDelayCalcBlock {
    if (!self.__retryDelayCalcBlock) {
        [self createDelayRetryCalcBlock];
    }
    return self.__retryDelayCalcBlock;
}

- (id)operationsDict {
    if (!self.__operationsDict) {
        [self createOperationsDict];
    }
    return self.__operationsDict;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                             methodBackInfo:(NSMutableDictionary *)methodBackInfo
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                                autoRetryOf:(int)retriesRemaining retryInterval:(int)intervalInSeconds {
    
    void (^retryBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *retryOperationDict = self.operationsDict[request];
        int originalRetryCount = [retryOperationDict[@"originalRetryCount"] intValue];
        int retriesRemainingCount = [retryOperationDict[@"retriesRemainingCount"] intValue];
        if (retriesRemainingCount > 0 && error.code == NSURLErrorTimedOut) {
            PLog(@"AutoRetry: Request %@ failed: %@, retry %d out of %d begining...",
                  [methodBackInfo objectForKey:@"methodBack"], error.localizedDescription, originalRetryCount - retriesRemainingCount + 1, originalRetryCount);
            AFHTTPRequestOperation *retryOperation = [self HTTPRequestOperationWithRequest:request
                                                                            methodBackInfo:methodBackInfo
                                                                                   success:success
                                                                                   failure:failure
                                                                               autoRetryOf:retriesRemainingCount - 1
                                                                             retryInterval:intervalInSeconds];
            void (^addRetryOperation)() = ^{
                retryOperation.userInfo = [methodBackInfo objectForKey:@"userInfo"];
                retryOperation.methodBack = [methodBackInfo objectForKey:@"methodBack"];
                retryOperation.methodName = [methodBackInfo objectForKey:@"methodName"];
                retryOperation.indicatorStyle = [methodBackInfo objectForKey:@"indicatorStyle"];
                [self.operationQueue addOperation:retryOperation];
            };
            RetryDelayCalcBlock delayCalc = self.retryDelayCalcBlock;
            int intervalToWait = delayCalc(originalRetryCount, retriesRemainingCount, intervalInSeconds);
            if (intervalToWait > 0) {
                PLog(@"AutoRetry: Delaying retry for %d seconds...", intervalToWait);
                dispatch_time_t delay = dispatch_time(0, (int64_t) (intervalToWait * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^(void) {
                    addRetryOperation();
                });
            } else {
                addRetryOperation();
            }
        } else {
            PLog(@"AutoRetry: Request %@ failed %d times: %@", [methodBackInfo objectForKey:@"methodBack"], originalRetryCount, error.localizedDescription);
            PLog(@"AutoRetry: No more retries allowed! executing supplied failure block...");
            failure(operation, error);
        }
    };
    NSMutableDictionary *operationDict = self.operationsDict[request];
    if (!operationDict) {
        operationDict = [NSMutableDictionary new];
        operationDict[@"originalRetryCount"] = [NSNumber numberWithInt:retriesRemaining];
    }
    operationDict[@"retriesRemainingCount"] = [NSNumber numberWithInt:retriesRemaining];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.operationsDict];
    newDict[request] = operationDict;
    self.operationsDict = newDict;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObj) {
                                                                          success(operation, responseObj);
                                                                      } failure:retryBlock];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters methodBackInfo:(NSMutableDictionary *)methodBackInfo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self POST:URLString parameters:parameters methodBackInfo:methodBackInfo success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters methodBackInfo:(NSMutableDictionary *)methodBackInfo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self GET:URLString parameters:parameters methodBackInfo:methodBackInfo success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self HEAD:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters methodBackInfo:(NSMutableDictionary *)methodBackInfo constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self POST:URLString parameters:parameters methodBackInfo:methodBackInfo constructingBodyWithBlock:block success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self PUT:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self PATCH:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure autoRetry:(int)timesToRetry {
    return [self DELETE:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  methodBackInfo:(NSMutableDictionary *)methodBackInfo
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:methodBackInfo success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    operation.userInfo = [methodBackInfo objectForKey:@"userInfo"];
    operation.methodBack = [methodBackInfo objectForKey:@"methodBack"];
    operation.methodName = [methodBackInfo objectForKey:@"methodName"];
    operation.indicatorStyle = [methodBackInfo objectForKey:@"indicatorStyle"];
    [self.operationQueue addOperation:operation];
    
    return operation;
}


- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                 methodBackInfo:(NSMutableDictionary *)methodBackInfo
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:methodBackInfo success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    operation.userInfo = [methodBackInfo objectForKey:@"userInfo"];
    operation.methodBack = [methodBackInfo objectForKey:@"methodBack"];
    operation.methodName = [methodBackInfo objectForKey:@"methodName"];
    operation.indicatorStyle = [methodBackInfo objectForKey:@"indicatorStyle"];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:nil success:^(AFHTTPRequestOperation *requestOperation, __unused id responseObject) {
        if (success) {
            success(requestOperation);
        }
    }                                                                 failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  methodBackInfo:(NSMutableDictionary *)methodBackInfo
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:methodBackInfo success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    operation.userInfo = [methodBackInfo objectForKey:@"userInfo"];
    operation.methodBack = [methodBackInfo objectForKey:@"methodBack"];
    operation.methodName = [methodBackInfo objectForKey:@"methodName"];
    operation.indicatorStyle = [methodBackInfo objectForKey:@"indicatorStyle"];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:nil success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                        autoRetry:(int)timesToRetry
                    retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:nil success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                         autoRetry:(int)timesToRetry
                     retryInterval:(int)intervalInSeconds {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request methodBackInfo:nil success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

@end
