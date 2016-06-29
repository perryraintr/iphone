//
//  UITextField+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Building)

UITextField *Building_UITextField(UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder);

UITextField *Building_UITextFieldWithFrame(CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder);

UITextField *Building_UITextFieldWithSuperView(UIView *superView, UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder);

UITextField *Building_UITextFieldWithFrameWithSuperView(UIView *superView, CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment textAlignment, NSString *placeholder);

@end
