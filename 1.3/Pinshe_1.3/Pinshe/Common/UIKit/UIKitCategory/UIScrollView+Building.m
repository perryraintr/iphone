//
//  UIScrollView+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIScrollView+Building.h"

@implementation UIScrollView (Building)

UIScrollView *Building_UIScrollView(BOOL directionalLockEnabled, BOOL bounces, BOOL pagingEnabled, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator) {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.directionalLockEnabled = directionalLockEnabled;
    scrollView.bounces = bounces;
    scrollView.pagingEnabled = pagingEnabled;
    scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    /// defalut
    scrollView.backgroundColor = [UIColor clearColor];
    return scrollView;
}

UIScrollView *Building_UIScrollViewWithFrame(CGRect frame, BOOL directionalLockEnabled, BOOL bounces, BOOL pagingEnabled, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator) {
    UIScrollView *scrollView = Building_UIScrollView(directionalLockEnabled, bounces, pagingEnabled, showsHorizontalScrollIndicator, showsVerticalScrollIndicator);
    scrollView.frame = frame;
    return scrollView;
}

UIScrollView *Building_UIScrollViewWithFrameAndSuperView(UIView *superView, CGRect frame, BOOL directionalLockEnabled, BOOL bounces, BOOL pagingEnabled, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator) {
    UIScrollView *scrollView = Building_UIScrollViewWithFrame(frame, directionalLockEnabled, bounces, pagingEnabled, showsHorizontalScrollIndicator, showsVerticalScrollIndicator);
    if (superView) { [superView addSubview:scrollView]; }
    return scrollView;
}


@end
