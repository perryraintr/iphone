//
//  UIScrollView+PinRefreshControl.m
//  MJScrollView
//
//  Created by shiyaorong on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIScrollView+PinRefreshControl.h"
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

@implementation UIScrollView (PinRefreshControl)

static char *PINDelegateKey;

- (id<PINRefreshNoMoreDataDelegate>)PINDelegate {
    return objc_getAssociatedObject(self, PINDelegateKey);
}

- (void)setPINDelegate:(id<PINRefreshNoMoreDataDelegate>)PINDelegate {
    objc_setAssociatedObject(self, PINDelegateKey, PINDelegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark -
#pragma mark - 添加刷新控件
/// 添加 Refresh Header
- (void)addRefreshHeaderWithCompletion:(PinRefreshCompletion)completion {
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
- (void)addRefreshFooterWithCompletion:(PinRefreshCompletion)completion {
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

/// 添加 Refresh Footer (手动上拉加载)
- (void)addRefreshFooterManualPullLoadWithCompletion:(PinRefreshCompletion)completion {
    if (!completion) {
        return;
    }
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:completion];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_IDLE forState:MJRefreshStateIdle];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_PULLING forState:MJRefreshStatePulling];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_REFRESHING forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_NO_MORE_DATA forState:MJRefreshStateNoMoreData];
    self.mj_footer = refreshFooter;
}

/// 添加 Refresh Header 及 Refresh Footer (自动加载)
- (void)addRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andRefreshFooter:(PinRefreshCompletion)footerCompletion {
    [self addRefreshHeaderWithCompletion:headerCompletion];
    [self addRefreshFooterWithCompletion:footerCompletion];
}

/// 添加 Refresh Header 及 Refresh Footer (手动上拉加载)
- (void)addRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andRefreshFooterManualPullLoad:(PinRefreshCompletion)footerCompletion {
    [self addRefreshHeaderWithCompletion:headerCompletion];
    [self addRefreshFooterManualPullLoadWithCompletion:footerCompletion];
}

/// Gif 刷新
/// 添加 Refresh Header
- (void)addGifRefreshHeaderWithCompletion:(PinRefreshCompletion)completion {
    if (!completion) {
        return;
    }
    MJRefreshGifHeader *refreshHeader = [MJRefreshGifHeader headerWithRefreshingBlock:completion];
    [refreshHeader setTitle:REFRESH_HEADER_STATE_IDLE forState:MJRefreshStateIdle];
    [refreshHeader setTitle:REFRESH_HEADER_STATE_PULLING forState:MJRefreshStatePulling];
    [refreshHeader setTitle:REFRESH_HEADER_STATE_REFRESHING forState:MJRefreshStateRefreshing];
    /// 这里添加图片数组
    NSMutableArray *refreshingImages = [@[] mutableCopy];
    for (NSUInteger i = 1; i <= 3; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [refreshHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = refreshHeader;
    self.mj_header.automaticallyChangeAlpha = YES;
}

/// 添加 Refresh Footer (自动加载)
- (void)addGifRefreshFooterWithCompletion:(PinRefreshCompletion)completion {
    if (!completion) {
        return;
    }
    MJRefreshAutoGifFooter *refreshFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:completion];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_IDLE forState:MJRefreshStateIdle];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_PULLING forState:MJRefreshStatePulling];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_REFRESHING forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_NO_MORE_DATA forState:MJRefreshStateNoMoreData];
    /// 这里添加图片数组
    NSMutableArray *refreshingImages = [@[] mutableCopy];
    for (NSUInteger i = 1; i <= 3; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [refreshFooter setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.mj_footer = refreshFooter;
}

/// 添加 Refresh Footer (手动上拉加载)
- (void)addGifRefreshFooterManualPullLoadWithCompletion:(PinRefreshCompletion)completion {
    if (!completion) {
        return;
    }
    MJRefreshBackGifFooter *refreshFooter = [MJRefreshBackGifFooter footerWithRefreshingBlock:completion];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_IDLE forState:MJRefreshStateIdle];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_PULLING forState:MJRefreshStatePulling];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_REFRESHING forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:REFRESH_FOOTER_STATE_NO_MORE_DATA forState:MJRefreshStateNoMoreData];
    /// 这里添加图片数组
    NSMutableArray *refreshingImages = [@[] mutableCopy];
    for (NSUInteger i = 1; i <= 3; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [refreshFooter setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.mj_footer = refreshFooter;
}

/// 添加 Refresh Header 及 Refresh Footer (自动加载)
- (void)addGifRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andGifRefreshFooter:(PinRefreshCompletion)footerCompletion {
    [self addGifRefreshHeaderWithCompletion:headerCompletion];
    [self addGifRefreshFooterWithCompletion:footerCompletion];
}

/// 添加 Refresh Header 及 Refresh Footer (手动上拉加载)
- (void)addGifRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andGifRefreshFooterManualPullLoad:(PinRefreshCompletion)footerCompletion {
    [self addGifRefreshHeaderWithCompletion:headerCompletion];
    [self addGifRefreshFooterManualPullLoadWithCompletion:footerCompletion];
}

#pragma mark -
#pragma mark - 移除刷新控件
/// 移除 Refresh Header
- (void)removeRefreshHeader {
    if (!self.mj_header) { } else {
        self.mj_header = nil;
    }
}

/// 移除 Refresh Footer
- (void)removeRefreshFooter {
    if (!self.mj_footer) { } else {
        self.mj_footer = nil;
    }
}

#pragma mark -
#pragma mark - 开始刷新
- (void)beginHeaderRefreshing {
    if (!self.mj_header) { } else {
        [self.mj_header beginRefreshing];
    }
}

- (void)beginFooterRefreshing {
    if (!self.mj_footer) { } else {
        [self.mj_footer beginRefreshing];
    }
}

- (void)beginRefreshing {
    if (!self.mj_header) { } else {
        [self.mj_header beginRefreshing];
    }
    if (!self.mj_footer) { } else {
        [self.mj_footer beginRefreshing];
    }
}

#pragma mark -
#pragma mark - 结束刷新
- (void)endHeaderRefreshing {
    if (!self.mj_header) { } else {
        [self.mj_header endRefreshing];
    }
}

- (void)endFooterRefreshing {
    if (!self.mj_footer) { } else {
        [self.mj_footer endRefreshing];
    }
}

- (void)endRefreshing {
    if (self.contentSize.height > CGRectGetHeight(self.bounds)) {
        [self.mj_footer resetHidden:NO];
    } else {
        [self.mj_footer resetHidden:YES];
    }
    if (!self.mj_header) { } else {
        [self.mj_header endRefreshing];
    }
    if (!self.mj_footer) { } else {
        [self.mj_footer endRefreshing];
    }
}

- (void)addFooter:(BOOL)needAddFootView {
    [self.mj_footer resetHidden:NO];
    if (self.mj_header.state == MJRefreshStateIdle) {
        [self.mj_header endRefreshing];
    }
    if (!needAddFootView) {
        if (self.contentSize.height > CGRectGetHeight(self.bounds)) {
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mj_footer resetHidden:YES];
        }
    } else {
        [self.mj_footer endRefreshing];
    }
}

#pragma mark -
#pragma mark - Refresh Footer 提示用户已经是最后一页
- (void)endRefreshingNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)endRefreshingNoMoreDataWithMessage:(NSString *)message {
    [((MJRefreshBackStateFooter *)self.mj_footer) setTitle:message forState:MJRefreshStateNoMoreData];
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end
