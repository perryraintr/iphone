//
//  UIButton+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Building)

@property (nonatomic, strong) id info;

UIButton *Building_UIButton(id target, SEL action, UIColor *backgroundColor);

UIButton *Building_UIButtonWithFrame(CGRect frame, id target, SEL action, UIColor *backgroundColor);

UIButton *Building_UIButtonWithSuperView(UIView *superView, id target, SEL action, UIColor *backgroundColor);

UIButton *Building_UIButtonWithFrameAndSuperView(UIView *superView, CGRect frame, id target, SEL action, UIColor *backgroundColor);


@end
