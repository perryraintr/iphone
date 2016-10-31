//
//  UIView+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Building)

@property (nonatomic, strong) id info;

UIView *Building_UIView();

UIView *Building_UIViewWithFrame(CGRect frame);

UIView *Building_UIViewWithSuperView(UIView *superView);

UIView *Building_UIViewWithFrameAndSuperView(UIView *superView, CGRect frame);

@end
