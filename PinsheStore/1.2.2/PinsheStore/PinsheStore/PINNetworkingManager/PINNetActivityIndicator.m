//
//  PINNetActivityIndicator.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/16.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINNetActivityIndicator.h"

#define kLoadingWidth FITWITH(80)
#define kLoadingHeight FITWITH(80)

static PINNetActivityIndicator *pinNetActivityIndicator = nil;

@interface PINNetActivityIndicator ()

@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation PINNetActivityIndicator
+ (void)startActivityIndicator:(PINIndicatorStyle)indicatorStyle {
    if (indicatorStyle == PINIndicatorStyle_DefaultIndicator || indicatorStyle == PINIndicatorStyle_NoStopIndicator) {
        [[PINNetActivityIndicator instance] showStartActivityIndicator];
    }
}

+ (void)stopActivityIndicator:(PINIndicatorStyle)indicatorStyle {
    if (indicatorStyle == PINIndicatorStyle_DefaultIndicator || indicatorStyle == PINIndicatorStyle_NoStartIndicator) {
        [[PINNetActivityIndicator instance] showStopActivityIndicator];
    }
}

+ (PINNetActivityIndicator *)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pinNetActivityIndicator = [[PINNetActivityIndicator alloc] init];
    });
    return pinNetActivityIndicator;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.size = CGSizeMake(kLoadingWidth, kLoadingHeight);
        _loadingImageView.center = CGPointMake(SCREEN_WITH / 2, (SCREEN_HEIGHT - FITWITH(40)) / 2);
        
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 1; i < 9; i ++) {
            UIImage *image = IMG_Name(Format(@"loading%zd.png", i));
            [imageArray addObject:image];
        }
        
        _loadingImageView.animationImages = imageArray;
        _loadingImageView.animationDuration = 1.5f;
    }
    return _loadingImageView;
}

- (void)showStartActivityIndicator {
    if (self.loadingImageView.isAnimating) {
        return;
    }
    [UIWindow addSubview:self.loadingImageView];
    [_loadingImageView startAnimating];
}

- (void)showStopActivityIndicator {
    [_loadingImageView stopAnimating];
    PIN_VIEW_SAFE_RELEASE(_loadingImageView);
}
@end
