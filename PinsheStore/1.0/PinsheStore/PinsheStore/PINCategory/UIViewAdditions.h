//
//  UIViewAdditions.h
//
//  Pinshe
//
//  Created by shiyaorong on 16/04/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Geometry)
/**
 * view.top
 */
@property (nonatomic, assign) CGFloat top;
/**
 * view.bottom
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 * view.left
 */
@property (nonatomic, assign) CGFloat left;
/**
 * view.right
 */
@property (nonatomic, assign) CGFloat right;
/**
 * view.width
 */
@property (nonatomic, assign) CGFloat width;
/**
 * view.height
 */
@property (nonatomic, assign) CGFloat height;
/**
 * view.center.x
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 * view.center.y
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 * view.size
 */
@property (nonatomic, assign) CGSize size;
/**
 * view.origin
 */
@property (nonatomic, assign) CGPoint origin;

@end



@interface UIView (ViewHiarachy)

/**
 * 获取当前view最近的uiviewcontroller。
 */
@property (nonatomic, readonly) UIViewController *viewController;
/**
 * 移除所有子视图。
 */
- (void)removeAllSubviews;

@end

@interface UIView (Gesture)

/**
 * 在当前视图上添加点击事件。
 */

// TODO DINGLi Deprecated
- (void)addTapAction:(SEL)tapAction target:(id)target;

@end

@interface UIView (firstResponder)

- (UIView *)findViewThatIsFirstResponder;
- (NSArray *)descendantViews;

@end

@interface UIView (autoLayout)

- (void)testAmbiguity;

@end

@interface UIView (DDFramework)
- (void)cutCorners;
- (void)cutCornersWithRadius:(CGFloat)radius;
@end