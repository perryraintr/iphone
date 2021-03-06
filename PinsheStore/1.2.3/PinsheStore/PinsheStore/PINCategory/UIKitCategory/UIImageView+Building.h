//
//  UIImageView+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Building)

/// UIImageView
UIImageView *Building_UIImageView(UIImage *image);

UIImageView *Building_UIImageViewWithFrame(CGRect frame, UIImage *image);

/// UIImageView (通过 url 来加载 image)
UIImageView *Building_SDImageView(NSString *urlString, UIImage *placeholderImage);

UIImageView *Building_SDImageViewWithFrame(CGRect frame, NSString *urlString, UIImage *placeholderImage);

UIImageView *Building_UIImageViewWithSuperView(UIView *superView, UIImage *image);

UIImageView *Building_UIImageViewWithFrameAndSuperView(UIView *superView, CGRect frame, UIImage *image);

@end
