//
//  UIViewAdditions.m
//
//  Pinshe
//
//  Created by shiyaorong on 16/04/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIViewAdditions.h"
//#import "MBProgressHUD.h"

@implementation UIView (Geometry)

- (void)setTop:(CGFloat)t
{
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b
{
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l
{
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r
{
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWidth:(CGFloat)w
{
    self.frame = CGRectMake(self.left, self.top, w, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h
{
    self.frame = CGRectMake(self.left, self.top, self.width, h);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

@end


@implementation UIView (ViewHiarachy)

- (UIViewController *)viewController
{
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end

@implementation UIView (hint)

- (void)chatShowHint:(NSString *)hint {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end

@implementation UIView (Gesture)

- (void)addTapAction:(SEL)tapAction target:(id)target
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:tapAction];
    [self addGestureRecognizer:gesture];
}



@end

@implementation UIView (firstResponder)

- (UIView *)findViewThatIsFirstResponder
{
	if (self.isFirstResponder) {
		return self;
	}
    
	for (UIView *subView in self.subviews) {
		UIView *firstResponder = [subView findViewThatIsFirstResponder];
		if (firstResponder != nil) {
			return firstResponder;
		}
	}
	return nil;
}

- (NSArray *)descendantViews
{
    NSMutableArray *descendantArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        [descendantArray addObject:view];
        [descendantArray addObjectsFromArray:[view descendantViews]];
    }
    return [descendantArray copy];
}

@end

@implementation UIView (autoLayout)

- (void) testAmbiguity
{
    if (self.hasAmbiguousLayout) {
        NSLog(@"<%@:%p>: %@", self.class.description, self, @"Ambiguous");
    }
    for (UIView *view in self.subviews) {
        [view testAmbiguity];
    }
}

@end

@implementation UIView (DDFramework)
- (void)cutCorners
{
    CALayer *layer = [self layer];
    layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    self.clipsToBounds = YES;
}

- (void)cutCornersWithRadius:(CGFloat)radius
{
    CALayer *layer = [self layer];
    layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
@end