//
//  UIScrollView+PINRefreshControl.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIScrollView+PINRefreshControl.h"
#import "MJRefresh.h"

/// Refresh Header 状态显示文字
static NSString *const REFRESH_HEADER_STATE_IDLE = @"下拉即可刷新...";
static NSString *const REFRESH_HEADER_STATE_PULLING = @"松开即可刷新...";
static NSString *const REFRESH_HEADER_STATE_REFRESHING = @"正在刷新, 请稍后...";
/// Refresh Footer 状态显示文字
static NSString *const REFRESH_FOOTER_STATE_IDLE = @"点击即可加载...";
static NSString *const REFRESH_FOOTER_STATE_PULLING = @"松开即可加载...";
static NSString *const REFRESH_FOOTER_STATE_REFRESHING = @"正在刷新, 请稍后...";
static NSString *const REFRESH_FOOTER_STATE_NO_MORE_DATA = @"亲, 没有更多数据了...";

@implementation UIScrollView (PINRefreshControl)

#pragma mark -
#pragma mark - 添加刷新控件
/// 添加 Refresh Header
- (void)addRefreshHeaderWithCompletion:(PINRefreshCompletion)completion {
    if (!completion) {
        return;
    }
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:completion];
    [refreshHeader setTitle:REFRESH_HEADER_STATE_IDLE forState:MJRefreshStateIdle];
    [refreshHeader setTitle:REFRESH_HEADER_STATE_PULLING forState:MJRefreshStatePulling];
    [refreshHeader setTitle:REFRESH_HEADER_STATE_REFRESHING forState:MJRefreshStateRefreshing];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = refreshHeader;
    self.mj_header.automaticallyChangeAlpha = YES;
}

/// 添加 Refresh Footer (自动加载)
- (void)addRefreshFooterWithCompletion:(PINRefreshCompletion)completion {
    if (!completion) {
        return;
    }
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:completion];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_IDLE forState:MJRefreshStateIdle];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_PULLING forState:MJRefreshStatePulling];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_REFRESHING forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_NO_MORE_DATA forState:MJRefreshStateNoMoreData];
    self.mj_footer = refreshFooter;
}

- (void)endRefreshing {
    if (!self.mj_header) { } else {
        [self.mj_header endRefreshing];
    }
    if (!self.mj_footer) { } else {
        [self.mj_footer endRefreshing];
    }
}

@end
