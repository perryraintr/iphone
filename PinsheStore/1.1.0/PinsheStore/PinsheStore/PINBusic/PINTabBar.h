//
//  PinTabBar.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINTabBar;

@protocol PINTabBarDelegate
@optional
- (UIImage *)imageFor:(PINTabBar *)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage *)tabBarArrowImage;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end

@interface PINTabBar : UIView

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) NSObject <PINTabBarDelegate> *delegate;

- (id)initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <PINTabBarDelegate> *)customTabBarDelegate;
- (void)selectItemAtIndex:(NSInteger)index;

@end
