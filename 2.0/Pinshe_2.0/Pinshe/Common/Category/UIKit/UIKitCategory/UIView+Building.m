//
//  UIView+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIView+Building.h"

static const char *UIVIEW_INFO;

@implementation UIView (Building)

- (void)setInfo:(id)info {
    objc_setAssociatedObject(self, &UIVIEW_INFO, info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)info {
    return objc_getAssociatedObject(self, &UIVIEW_INFO);
}

UIView *Building_UIView() {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

UIView *Building_UIViewWithFrame(CGRect frame) {
    UIView *view = Building_UIView();
    view.frame = frame;
    return view;
}

UIView *Building_UIViewWithSuperView(UIView *superView) {
    UIView *view = Building_UIView();
    if (superView) { [superView addSubview:view]; }
    return view;
}

UIView *Building_UIViewWithFrameAndSuperView(UIView *superView, CGRect frame) {
    UIView *view = Building_UIViewWithFrame(frame);
    if (superView) { [superView addSubview:view]; }
    return view;
}

@end
