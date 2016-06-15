//
//  PINActivityIndicatorView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/5.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINActivityIndicatorView : UIView

@property (nonatomic, strong) UIImageView *loadingView;

- (void)startAnimating;
- (void)stopAnimating;

@end

@interface UIView (activityIndicator)

- (void)startActivityAnimating;
- (void)stopActivityAnimating;

@end

