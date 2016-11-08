//
//  UIImage+UIImageScale.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIImage+UIImageScale.h"

@implementation UIImage (UIImageScale)

- (UIImage*)getSubImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage*)scaleToSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 图片压缩到指定大小
- (NSData *)dataCompresWithLength:(int)length {
    // sourceImage is whatever image you're starting with
    
    NSData *imageData = [[NSData alloc] init];
    for (float compression = 1.0; compression >= 0.0; compression -= .1) {
        imageData = UIImageJPEGRepresentation(self, compression);
        NSInteger imageLength = imageData.length;
        if (imageLength < length) {
            break;
        }
    }
    return imageData;
}

// 尺寸压缩在指定尺寸内
- (UIImage *)scaleToFitSize:(CGSize)target_size {
    float hfactor = self.size.width / target_size.width;
    float vfactor = self.size.height / target_size.height;
    float factor = MAX(hfactor, vfactor);
    factor = MAX(factor, 1.0);
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = self.size.width / factor;
    float newHeight = self.size.height / factor;
    CGRect newRect = CGRectMake(0.0, 0.0, newWidth, newHeight);
    UIGraphicsBeginImageContext(newRect.size);
    [self drawInRect:newRect blendMode:kCGBlendModePlusDarker alpha:1];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    PLog(@"image width = %f,height = %f",scaledImage.size.width,scaledImage.size.height);
    return scaledImage;
}

// 宽度相同，高度按照原始比例来
- (UIImage *)snapSmallImage:(float)target_size_width {
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = target_size_width;
    float newHeight = target_size_width * self.size.height / self.size.width;
    CGRect newRect = CGRectMake(0.0, 0.0, newWidth, newHeight);
    UIGraphicsBeginImageContext(newRect.size);
    [self drawInRect:newRect blendMode:kCGBlendModePlusDarker alpha:1];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    PLog(@"image width = %f,height = %f",scaledImage.size.width,scaledImage.size.height);
    return scaledImage;
}

@end
