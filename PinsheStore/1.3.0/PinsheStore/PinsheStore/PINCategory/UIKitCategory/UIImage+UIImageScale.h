//
//  UIImage+UIImageScale.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)

- (UIImage*)getSubImage:(CGRect)rect;

- (UIImage*)scaleToSize:(CGSize)size;

// 图片压缩到指定大小
- (NSData *)dataCompresWithLength:(int)length;

// 尺寸压缩在指定尺寸内
- (UIImage *)scaleToFitSize:(CGSize)target_size;

- (UIImage *)snapSmallImage:(float)target_size_width;

@end
