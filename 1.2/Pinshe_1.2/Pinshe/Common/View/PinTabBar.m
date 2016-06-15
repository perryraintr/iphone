//
//  PinTabBar.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PinTabBar.h"

#define TAB_ARROW_IMAGE_TAG 2394859

@interface PinTabBar (Private)
- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex;
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex;
- (UIButton *)buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
- (UIImage *)tabBarImage:(UIImage *)startImage size:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage;
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage *)startImage;
- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage;
@end


@implementation PinTabBar

- (id)initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <PinTabBarDelegate> *)customTabBarDelegate {
    if (self = [super init]) {
        self.tag = objectTag;
        self.delegate = customTabBarDelegate;
        self.frame = CGRectMake(0, 0, itemSize.width *itemCount, itemSize.height);
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBarBg.png"]];
        backgroundImageView.frame = self.bounds;
        [self addSubview:backgroundImageView];
        
        self.buttons = [NSMutableArray arrayWithCapacity:itemCount];
        
        CGFloat horizontalOffset = 0;
        for (NSUInteger i = 0 ; i < itemCount ; i++) {
            UIButton *button = [self buttonAtIndex:i width:self.frame.size.width/itemCount];
            button.frame = CGRectMake(horizontalOffset, 0, button.frame.size.width, button.frame.size.height);
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
            horizontalOffset = horizontalOffset + itemSize.width;
            
            [self.buttons addObject:button];
        }
    }
    return self;

}

- (void)dimAllButtonsExcept:(UIButton *)selectedButton {
    BOOL addTabBarArrow = NO;
    for (UIButton *button in self.buttons) {
        NSUInteger selectedIndex = [self.buttons indexOfObjectIdenticalTo:button];
        if (button == selectedButton) {
            button.selected = YES;
            button.highlighted = YES;
            
            UIImage *buttonPressedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabIconSel%tu.png", selectedIndex]];
            [button setImage:buttonPressedImage forState:UIControlStateNormal];
            
            UIImageView *tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
            if (tabBarArrow) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect frame = tabBarArrow.frame;
                frame.origin.x = [self horizontalLocationFor:selectedIndex];
                tabBarArrow.frame = frame;
                [UIView commitAnimations];
            } else {
                [self addTabBarArrowAtIndex:selectedIndex];
                addTabBarArrow = YES;
            }
        } else {
            UIImage *buttonPressedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabIcon%tu.png", selectedIndex]];
            [button setImage:buttonPressedImage forState:UIControlStateNormal];
            
            button.selected = NO;
            button.highlighted = NO;
        }
        if (addTabBarArrow) {
            [self bringSubviewToFront:button];
        }
    }
}

- (void)touchDownAction:(UIButton *)button {

    BOOL isLogin = [UserDefaultManagement instance].isLogined;
    if (!isLogin && [self.buttons indexOfObject:button] == 2) {
        PinNavigationController *navigationController = [[PinNavigationController alloc] init];
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        [paramsDic setObject:[NSNumber numberWithInteger:PinLoginType_PublishMy] forKey:@"pinLoginType"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
        [pinSheAppDelegate().pinNavigationController presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    [self dimAllButtonsExcept:button];
    if ([self.delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)]) {
        [self.delegate touchDownAtItemAtIndex:[self.buttons indexOfObject:button]];
    }
}

- (void)selectItemAtIndex:(NSInteger)index {
    UIButton *button = [self.buttons objectAtIndex:index];
    [self dimAllButtonsExcept:button];
}

- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex {
    UIImageView *tabBarArrow = (UIImageView *)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
    CGFloat tabItemWidth = self.frame.size.width / self.buttons.count;
    CGFloat arrowWidth;
    if (tabBarArrow) {
        arrowWidth = FITWITH(30);
    } else {
        arrowWidth = [self.delegate tabBarArrowImage].size.width;
    }
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (arrowWidth / 2.0);
    return (tabIndex *tabItemWidth) + halfTabItemWidth;
}

- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex {
    UIImage *tabBarArrowImage = [self.delegate tabBarArrowImage];
    UIImageView *tabBarArrow = [[UIImageView alloc] initWithImage:tabBarArrowImage];
    tabBarArrow.tag = TAB_ARROW_IMAGE_TAG;
    tabBarArrow.frame = CGRectMake([self horizontalLocationFor:itemIndex], 0, FITWITH(30), FITWITH(30));
    [self addSubview:tabBarArrow];
}

- (UIButton *)buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
    UIImage *rawButtonImage = [self.delegate imageFor:self atIndex:itemIndex];
    if (rawButtonImage) {
        UIImage *buttonImage = [self tabBarImage:rawButtonImage size:button.frame.size backgroundImage:nil];
        UIImage *buttonPressedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabIconSel%tu.png", itemIndex]];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
        [button setImage:buttonPressedImage forState:UIControlStateSelected];
    }
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

- (UIImage *)tabBarImage:(UIImage *)startImage size:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImageSource {
    UIImage *backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];
    UIImage *bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage), CGImageGetHeight(bwImage.CGImage), CGImageGetBitsPerComponent(bwImage.CGImage), CGImageGetBitsPerPixel(bwImage.CGImage), CGImageGetBytesPerRow(bwImage.CGImage), CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
    
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
    
    UIImage *tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];
    
    CGImageRelease(imageMask);
    CGImageRelease(tabBarImageRef);
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage *)startImage {
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextFillRect(context, imageRect);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage {
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backgroundImage) {
        [backgroundImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    } else {
        [[UIColor lightGrayColor] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }
    
    UIImage *finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalBackgroundImage;
}

@end
