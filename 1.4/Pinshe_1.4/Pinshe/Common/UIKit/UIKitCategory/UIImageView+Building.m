//
//  UIImageView+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIImageView+Building.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Building)

/// UIImageView
UIImageView *Building_UIImageView(UIImage *image) {
    UIImageView *imageView = [[UIImageView alloc] init];
    if (image) { imageView.image = image; }
    /// default
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

UIImageView *Building_UIImageViewWithFrame(CGRect frame, UIImage *image) {
    UIImageView *imageView = Building_UIImageView(image);
    imageView.frame = frame;
    return imageView;
}

/// SDImageView
UIImageView *Building_SDImageView(NSString *urlString, UIImage *placeholderImage) {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
    /// default
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

UIImageView *Building_SDImageViewWithFrame(CGRect frame, NSString *urlString, UIImage *placeholderImage) {
    UIImageView *imageView = Building_SDImageView(urlString, placeholderImage);
    imageView.frame = frame;
    return imageView;
}

UIImageView *Building_UIImageViewWithSuperView(UIView *superView, UIImage *image) {
    UIImageView *imageView = Building_UIImageView(image);
    if (superView) { [superView addSubview:imageView]; }
    return imageView;
}

UIImageView *Building_UIImageViewWithFrameAndSuperView(UIView *superView, CGRect frame, UIImage *image) {
    UIImageView *imageView = Building_UIImageViewWithFrame(frame, image);
    if (superView) { [superView addSubview:imageView]; }
    return imageView;
}


@end
