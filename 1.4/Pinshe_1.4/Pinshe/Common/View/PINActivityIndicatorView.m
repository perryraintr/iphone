//
//  PINActivityIndicatorView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/5.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINActivityIndicatorView.h"

@implementation PINActivityIndicatorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.loadingView = Building_UIImageViewWithSuperView(self, nil);
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png", i]]];
        }
        [self.loadingView setAnimationImages:array];
        [self.loadingView setAnimationDuration:1.5f];
        
    }
    return self;
}

- (void)startAnimating {
    if (self.loadingView.isAnimating) {
        return;
    }
    [self.loadingView startAnimating];
}

- (void)stopAnimating {
    [self.loadingView stopAnimating];
}

@end

static char UIViewNODataViewStatic;

@implementation UIView (activityIndicator)
#pragma mark - Property Methods

- (PINActivityIndicatorView *)activityIndicatorView
{
    return objc_getAssociatedObject(self,
                                    &UIViewNODataViewStatic);
}

- (void)setActivityIndicatorView:(UIView *)noDataView
{
    [self willChangeValueForKey:@"noDataView"];
    objc_setAssociatedObject(self,
                             &UIViewNODataViewStatic,
                             noDataView,
                             OBJC_ASSOCIATION_RETAIN);
    [self addSubview:noDataView];
    [self didChangeValueForKey:@"noDataView"];
}

- (void)startActivityAnimating
{
    if (![self activityIndicatorView]) {
        PINActivityIndicatorView *view = [[PINActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, FITWITH(80), FITWITH(80))];
        [view setHidden:YES];
        [self setActivityIndicatorView:view];
    }
    [[self activityIndicatorView] setHidden:NO];
    [self bringSubviewToFront:[self activityIndicatorView]];
    
    [[self activityIndicatorView] setCenter:CGPointMake(SCREEN_WITH/2, (SCREEN_HEIGHT - 64 - FITWITH(40)) / 2 - 22 - 5)];
    
    [[self activityIndicatorView] startAnimating];
}

- (void)stopActivityAnimating
{
    [self sendSubviewToBack:[self activityIndicatorView]];
    [[self activityIndicatorView] setHidden:YES];
    [[self activityIndicatorView] stopAnimating];
}

@end


