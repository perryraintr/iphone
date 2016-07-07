//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshFooter.h"

@interface MJRefreshFooter()

@property (strong, nonatomic) NSMutableArray *willExecuteBlocks;

@end

@implementation MJRefreshFooter
- (NSMutableArray *)willExecuteBlocks
{
    if (!_willExecuteBlocks) {
        self.willExecuteBlocks = [NSMutableArray array];
    }
    return _willExecuteBlocks;
}

#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.mj_h = MJRefreshFooterHeight;
    
    // 默认不会自动隐藏
    self.automaticallyHidden = NO;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        // 监听scrollView数据的变化
        if ([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]]) {
            [self.scrollView setMj_reloadDataBlock:^(NSInteger totalDataCount) {
                if (self.isAutomaticallyHidden) {
                    self.hidden = (totalDataCount == 0);
                }
            }];
        }
    }
}

#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData
{
    self.state = MJRefreshStateNoMoreData;
}

- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    self.state = MJRefreshStateIdle;
}

#pragma mark - 公共方法
- (void)setHidden:(BOOL)hidden
{
    __weak typeof(self) weakSelf = self;
    BOOL lastHidden = weakSelf.isHidden;
    CGFloat h = weakSelf.mj_h;
    [weakSelf.willExecuteBlocks addObject:^{
        if (!lastHidden && hidden) {
            weakSelf.state = MJRefreshStateIdle;
            _scrollView.mj_insetB -= (h);
        } else if (lastHidden && !hidden) {
            _scrollView.mj_insetB += (h);
            
            [weakSelf adjustFrameWithContentSize];
        }
    }];
    [weakSelf setNeedsDisplay]; // 放到drawRect是为了延迟执行，防止因为修改了inset，导致循环调用数据源方法
    
    [super setHidden:hidden];
}

- (void)adjustFrameWithContentSize
{
    // 设置位置
    self.mj_y = _scrollView.mj_contentH;
}

- (void)resetHidden:(BOOL)hidden {
    __weak typeof(self) weakSelf = self;
    BOOL lastHidden = weakSelf.isHidden;
    CGFloat h = weakSelf.mj_h;
    [weakSelf.willExecuteBlocks addObject:^{
        if (!lastHidden && hidden) {
            _scrollView.mj_insetB -= (h);
        } else if (lastHidden && !hidden) {
            _scrollView.mj_insetB += (h);
            [weakSelf adjustFrameWithContentSize];
        }
    }];
    [weakSelf setNeedsDisplay];
    [super setHidden:hidden];
}

@end
