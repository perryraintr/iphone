//
//  UITextView+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Building)

UITextView *Building_UITextView(UIFont *font, UIColor *textColor, NSTextAlignment textAlignment);

UITextView *Building_UITextViewWithFrame(CGRect frame, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment);

UITextView *Building_UITextViewWithFrameAndSuperView(UIView *superView, CGRect frame, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment);

@end
