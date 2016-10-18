//
//  UILabel+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UILabel+Building.h"

@implementation UILabel (Building)

UILabel *Building_UILabel(UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines) {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    /// default backgroundColor
    label.backgroundColor = [UIColor clearColor];
    return label;
}

UILabel *Building_UILabelWithBackColorAndSuperView(UIView *superView, UIColor *backgroundColor) {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = backgroundColor;
    return label;
}

UILabel *Building_UILabelWithFrame(CGRect frame, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines) {
    UILabel *label = Building_UILabel(font, textColor, textAlignment, numberOfLines);
    label.frame = frame;
    return label;
}

UILabel *Building_UILabelWithSuperView(UIView *superView, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines) {
    UILabel *label = Building_UILabel(font, textColor, textAlignment, numberOfLines);
    if (superView) { [superView addSubview:label]; }
    return label;
}

UILabel *Building_UILabelWithFrameAndSuperView(UIView *superView, CGRect frame, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines) {
    UILabel *label = Building_UILabelWithFrame(frame, font, textColor, textAlignment, numberOfLines);
    if (superView) { [superView addSubview:label]; }
    return label;
}

@end
