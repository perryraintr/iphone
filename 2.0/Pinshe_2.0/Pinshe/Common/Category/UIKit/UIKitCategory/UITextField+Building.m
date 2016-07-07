//
//  UITextField+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UITextField+Building.h"

@implementation UITextField (Building)

UITextField *Building_UITextField(UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder) {
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = textColor;
    textField.font = font;
    textField.textAlignment = textAlignment;
    textField.placeholder = placeholder;
    /// default
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    return textField;
}

UITextField *Building_UITextFieldWithFrame(CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder) {
    UITextField *textField = Building_UITextField(textColor, font, textAlignment, placeholder);
    textField.frame = frame;
    return textField;
}

UITextField *Building_UITextFieldWithSuperView(UIView *superView, UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder) {
    UITextField *textField = Building_UITextFieldWithFrame(CGRectZero, textColor, font, textAlignment, placeholder);
    if (superView) { [superView addSubview:textField]; }
    return textField;
}

UITextField *Building_UITextFieldWithFrameWithSuperView(UIView *superView, CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder) {
    UITextField *textField = Building_UITextFieldWithFrame(frame, textColor, font, textAlignment, placeholder);
    if (superView) { [superView addSubview:textField]; }
    return textField;
}


@end
