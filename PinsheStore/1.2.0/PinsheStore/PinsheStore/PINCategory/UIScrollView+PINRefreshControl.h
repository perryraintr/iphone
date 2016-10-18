//
//  UIScrollView+PINRefreshControl.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PINRefreshCompletion) ();

@interface UIScrollView (PINRefreshControl)

- (void)addRefreshHeaderWithCompletion:(PINRefreshCompletion)completion;

- (void)addRefreshFooterWithCompletion:(PINRefreshCompletion)completion;

- (void)endRefreshing;

@end
