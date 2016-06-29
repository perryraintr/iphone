//
//  UIScrollView+PinRefreshControl.h
//  MJScrollView
//
//  Created by shiyaorong on 16/4/6.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PinRefreshCompletion) ();

@protocol PINRefreshNoMoreDataDelegate <NSObject>

- (void)scrollViewHasNoMoreData;

@end

@interface UIScrollView (PinRefreshControl)

@property (nonatomic, weak) id <PINRefreshNoMoreDataDelegate>PINDelegate;

#pragma mark -
#pragma mark - 添加刷新控件
/// 添加 Refresh Header
- (void)addRefreshHeaderWithCompletion:(PinRefreshCompletion)completion;
/// 添加 Refresh Footer (自动加载)
- (void)addRefreshFooterWithCompletion:(PinRefreshCompletion)completion;
/// 添加 Refresh Footer (手动上拉加载)
- (void)addRefreshFooterManualPullLoadWithCompletion:(PinRefreshCompletion)completion;
/// 添加 Refresh Header 及 Refresh Footer (自动加载)
- (void)addRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andRefreshFooter:(PinRefreshCompletion)footerCompletion;
/// 添加 Refresh Header 及 Refresh Footer (手动上拉加载)
- (void)addRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andRefreshFooterManualPullLoad:(PinRefreshCompletion)footerCompletion;


/// Gif 刷新
/// 添加 Refresh Header
- (void)addGifRefreshHeaderWithCompletion:(PinRefreshCompletion)completion;
/// 添加 Refresh Footer (自动加载)
- (void)addGifRefreshFooterWithCompletion:(PinRefreshCompletion)completion;
/// 添加 Refresh Footer (手动上拉加载)
- (void)addGifRefreshFooterManualPullLoadWithCompletion:(PinRefreshCompletion)completion;
/// 添加 Refresh Header 及 Refresh Footer (自动加载)
- (void)addGifRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andGifRefreshFooter:(PinRefreshCompletion)footerCompletion;
/// 添加 Refresh Header 及 Refresh Footer (手动上拉加载)
- (void)addGifRefreshHeaderWithCompletion:(PinRefreshCompletion)headerCompletion andGifRefreshFooterManualPullLoad:(PinRefreshCompletion)footerCompletion;

- (void)addFooter:(BOOL)needAddFootView;

#pragma mark -
#pragma mark - 移除刷新控件
/// 移除 Refresh Header
- (void)removeRefreshHeader;
/// 移除 Refresh Footer
- (void)removeRefreshFooter;


#pragma mark -
#pragma mark - 开始刷新
- (void)beginHeaderRefreshing;
- (void)beginFooterRefreshing;
- (void)beginRefreshing;


#pragma mark -
#pragma mark - 结束刷新
- (void)endHeaderRefreshing;
- (void)endFooterRefreshing;
- (void)endRefreshing;

#pragma mark -
#pragma mark - Refresh Footer 提示用户已经是最后一页
- (void)endRefreshingNoMoreData;
- (void)endRefreshingNoMoreDataWithMessage:(NSString *)message;

@end
