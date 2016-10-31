//
//  UIScrollView+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Building)

UIScrollView *Building_UIScrollView(BOOL directionalLockEnabled, BOOL bounces, BOOL pagingEnabled, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator);

UIScrollView *Building_UIScrollViewWithFrame(CGRect frame, BOOL directionalLockEnabled, BOOL bounces, BOOL pagingEnabled, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator);

UIScrollView *Building_UIScrollViewWithFrameAndSuperView(UIView *superView, CGRect frame, BOOL directionalLockEnabled, BOOL bounces, BOOL pagingEnabled, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator);

@end
