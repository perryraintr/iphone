//
//  PinConstant.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const REQUEST_URL;
extern NSString *const REQUEST_HTML_URL;

// 字体大小
extern float const fFont11;
extern float const fFont12;
extern float const fFont13;
extern float const fFont14;
extern float const fFont15;
extern float const fFont16;
extern float const fFont17;
extern float const fFont18;
extern float const fFont19;
extern float const fFont20;

typedef NS_ENUM (NSUInteger, PinIndicatorStyle) {
    PinIndicatorStyle_DefaultIndicator = 0,
    PinIndicatorStyle_NoStartIndicator,
    PinIndicatorStyle_NoStopIndicator,
    PinIndicatorStyle_NoIndicator,
};

typedef NS_ENUM (NSUInteger, PinLoginType) {
    PinLoginType_PulishComapre = 1,
    PinLoginType_DetailCompare,
    PinLoginType_PublishRecommed,
    PinLoginType_PublishShit,
    PinLoginType_PublishMy,
    PinLoginType_MyInstalled,
    PinLoginType_Favor, // 加入收藏
};

typedef NS_ENUM (NSUInteger, PinMyCentralType) {
    PinMyCentralType_CentralRecommed = 1,
    PinMyCentralType_CentralShit,
    PinMyCentralType_CentralComapre,
};

typedef NS_ENUM(NSUInteger, PinTopSceneType) {
    PinTopSceneType_WhiteCollar = 1,
    PinTopSceneType_Office,
    PinTopSceneType_Jouney,
    PinTopSceneType_Exercise,
};