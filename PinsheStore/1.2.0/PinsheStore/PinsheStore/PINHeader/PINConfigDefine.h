//
//  PINConfigDefine.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#pragma mark -
#pragma mark ---- 常用宏 ----

#ifdef DEBUG
#define PLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define PLog(format, ...) //NSLog(format, ## __VA_ARGS__)
#endif

#define SCREEN_WITH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FITWITH(x) SCREEN_WITH*x/414.0
#define FITHEIGHT(h) SCREEN_HEIGHT*h/736.0

#define weakSelf(self)     __weak typeof(self) weakSelf = self;

// 类对象
#define CLASS(className) [NSClassFromString(className) class]

//取得指定名称的图片
#define IMG_Name(name) [UIImage imageNamed:name]

//取得指定名称的图片
#define IMG_Name(name) [UIImage imageNamed:name]

// 字符串拼接
#ifndef Format
#define Format(...) [NSString stringWithFormat:__VA_ARGS__]
#endif

// 版本号
#define SystemVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 销毁view
#ifndef PIN_VIEW_SAFE_RELEASE
#define PIN_VIEW_SAFE_RELEASE(__REF) \
\
{ \
if ((__REF) != nil) { \
[__REF removeFromSuperview]; \
__REF = nil; \
} \
}
#endif

// 暂停时间
#define SAFERELEASE_TIMER(timer) if ([timer isValid]) {\
[timer invalidate]; timer = nil;\
}

// 字体
#define FontNotSou(x)                     [UIFont fontWithName:@"Helvetica" size:x]
#define Font(x)                           [UIFont fontWithName:@"Helvetica" size:FITWITH(x)]
#define FontBold(x)                       [UIFont fontWithName:@"Helvetica-Bold" size:FITWITH(x)]
#define FontWithNameNotSou(name, x)       [UIFont fontWithName:name size:x]
#define FontWithName(name, x)             [UIFont fontWithName:name size:FITWITH(x)]

// 颜色
#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]

#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : (alphaValue)]




