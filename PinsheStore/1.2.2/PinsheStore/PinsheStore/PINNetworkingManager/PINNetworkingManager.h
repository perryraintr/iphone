//
//  PINNetworkingManager.h
//  PINNetworkingManager
//
//  Created by 史瑶荣 on 16/5/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PINNetworkingConfig.h"

@class PINBaseService;

@interface PINNetworkingManager : NSObject

/**
 * POST 的 parameters 只能是Dictionary
 * GET 的 parameters 可以是Dictionary和NSString
 */
/// GET
- (void)GET:(NSString *)methodName params:(id)params finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// POST
- (void)POST:(NSString *)methodName params:(NSDictionary *)params finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/**
 * Upload Images
 * imageNames ：图片名 @[@"image.png", ...] 需要带有后缀
 * images ：要上传的图片
 */
- (void)UploadImagesWithMethodName:(NSString *)methodName params:(NSDictionary *)params imageNames:(NSArray <NSString *>*)imageNames images:(NSArray *)images finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 请求返回message
NSString *requestErrorWithCode(PINServiceTag code);

NSString *getRequestUrl(void);

@end
