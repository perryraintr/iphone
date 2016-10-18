//
//  UIButton+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIButton+Building.h"

static const char *RY_INFO;

@implementation UIButton (Building)

- (void)setInfo:(id)info {
    objc_setAssociatedObject(self, &RY_INFO, info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)info {
    return objc_getAssociatedObject(self, &RY_INFO);
}

UIButton *Building_UIButton(id target, SEL action, UIColor *backgroundColor) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = backgroundColor ?: [UIColor clearColor];
    return button;
}

UIButton *Building_UIButtonWithFrame(CGRect frame, id target, SEL action, UIColor *backgroundColor) {
    UIButton *button = Building_UIButton(target, action, backgroundColor);
    button.frame = frame;
    return button;
}

UIButton *Building_UIButtonWithSuperView(UIView *superView, id target, SEL action, UIColor *backgroundColor) {
    UIButton *button = Building_UIButton(target, action, backgroundColor);
    if (superView) { [superView addSubview:button]; }
    return button;
}

UIButton *Building_UIButtonWithFrameAndSuperView(UIView *superView, CGRect frame, id target, SEL action, UIColor *backgroundColor) {
    UIButton *button = Building_UIButton(target, action, backgroundColor);
    button.frame = frame;
    if (superView) { [superView addSubview:button]; }
    return button;
}


@end
