//
//  PinTabBar.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PinTabBar;

@protocol PinTabBarDelegate
@optional
- (UIImage *)imageFor:(PinTabBar *)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage *)tabBarArrowImage;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end

@interface PinTabBar : UIView

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) NSObject <PinTabBarDelegate> *delegate;

- (id)initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <PinTabBarDelegate> *)customTabBarDelegate;
- (void)selectItemAtIndex:(NSInteger)index;

@end
