//
//  UILabel+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Building)

UILabel *Building_UILabel(UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines);

UILabel *Building_UILabelWithFrame(CGRect frame, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines);

UILabel *Building_UILabelWithSuperView(UIView *superView, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines);

UILabel *Building_UILabelWithBackColorAndSuperView(UIView *superView, UIColor *backgroundColor);

UILabel *Building_UILabelWithFrameAndSuperView(UIView *superView, CGRect frame, UIFont *font, UIColor *textColor, NSTextAlignment textAlignment, NSInteger numberOfLines);

@end
