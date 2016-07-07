//
//  PINRecommendPopView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/7/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINRecommendPopView.h"
#import "PSModel.h"
#import "PINTopicView.h"

//static CGFloat const kPadding = 16.f;
//static CGFloat const kWhiteGroundViewHeight = 370.f;
#define kPadding FITHEIGHT(15)
#define kWhiteGroundViewHeight FITHEIGHT(350)

static CGFloat const kBlackGroundViewAlpha = 0.5f;
static NSInteger const kSelectedViewTag = 200000000;
static NSInteger const kTopicViewTag = 1000000;
static NSInteger const kMaxSelectedCount = 2;

@interface PINRecommendPopView ()

@property (nonatomic, copy) PublishSceneChooseBlock publishBlock;
// 搜索框
@property (nonatomic, strong) UISearchBar *searchBar;
// '请确认分享标签'
@property (nonatomic, strong) UILabel *promptLabel;
// '已选'
@property (nonatomic, strong) UILabel *selectedLabel;
// 已选部分scrollView
@property (nonatomic, strong) UIScrollView *selectedScrollView;
// '全部话题'
@property (nonatomic, strong) UIView *allTopicsView;
// 话题父视图
@property (nonatomic, strong) UIScrollView *scrollView;
// 发布按钮
@property (nonatomic, strong) UIButton *publishButton;
// 半透明背景
@property (nonatomic, strong) UIView *blackGroundView;
// 下半部分白色视图
@property (nonatomic, strong) UIView *whiteGroundView;
// 数据源
@property (nonatomic, strong) NSArray<PSModel *> *dataArray;

@end

@implementation PINRecommendPopView

- (instancetype)initWithDataArray:(NSArray<PSModel *> *)dataArray {
    self = [super init];
    if (self) {
        self.dataArray = [dataArray copy];
        self.selectedArray = [NSMutableArray array];
        [self buildingUI];
    }
    return self;
}

// 发布
- (void)publishButtonHandleAction:(UIButton *)sender {
    [self hidden];
    if (self.publishBlock) {
        PLog(@"chooseArray: －－－ %@", [self chooseArray]);
        self.publishBlock([self chooseArray]);
    }
}

- (NSMutableArray *)chooseArray {
    NSMutableArray *sureArray = [NSMutableArray array];
    for (PSModel *psModel in self.selectedArray) {
        [sureArray addObject:[NSNumber numberWithInteger:psModel.guid]];
    }
    return sureArray;
}


- (void)publishBlock:(PublishSceneChooseBlock)block {
    self.publishBlock = block;
}

- (void)buildingUI {
    self.blackGroundView.hidden = YES;
    self.whiteGroundView.hidden = YES;
    
    [self.whiteGroundView addSubview:self.searchBar];
    [self.whiteGroundView addSubview:self.publishButton];
    [self.whiteGroundView addSubview:self.promptLabel];
    [self.whiteGroundView addSubview:self.selectedLabel];
    [self.whiteGroundView addSubview:self.selectedScrollView];
    [self.whiteGroundView addSubview:self.allTopicsView];
    [self.whiteGroundView addSubview:self.scrollView];
    
    __block PINTopicView *lastView = nil;
    __block CGFloat kTopSpacing = FITHEIGHT(10);
    __block CGFloat kLineSpacing = FITHEIGHT(17);
    
    [self.dataArray enumerateObjectsUsingBlock:^(PSModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PINTopicView *topicView = [[PINTopicView alloc] initWithSelected:NO model:obj];
        topicView.tag = kTopicViewTag + idx;
        [self.scrollView addSubview:topicView];
        
        if (idx == 0) {
            topicView.top = kTopSpacing;
            topicView.left = kPadding;
        } else {
            topicView.left = lastView.right + FITHEIGHT(15);
            if (topicView.right >= SCREEN_WITH - kPadding) {
                topicView.top = lastView.bottom + kLineSpacing;
                topicView.left = kPadding;
            } else {
                topicView.top = lastView.top;
                topicView.left = lastView.right + FITWITH(15);
            }
        }
        
        // 固定三行
//        NSInteger row = idx / 3; // 行
//        NSInteger column = idx % 3; // 列
//        // 每行的间距
//        if (row == 0) {
//            topicView.top = kTopSpacing;
//        } else {
//            CGFloat heightOfRow = kLineSpacing + topicView.height;
//            topicView.top = kTopSpacing + row * heightOfRow;
//        }
//        
//#warning by shi
//        // 每列的间距
//        if (column == 0) {
//            topicView.left = kPadding;
//        } else if (column == 1) {
//            topicView.left = kPadding + FITWITH(135);
//        } else if (column == 2) {
//            topicView.left = kPadding + FITWITH(135) * 2;
//        }
        
        lastView = topicView;
        
        [topicView handleClickWithClosure:^(PINTopicView *totalView) {
            if (self.selectedArray.count == kMaxSelectedCount && totalView.isSelected) {
                totalView.selected = NO;
                return;
            }
            if (topicView.isSelected) {
                [self.selectedArray addObject:totalView.model];
            } else {
                [self.selectedArray removeObject:totalView.model];
            }
            [self reloadSelectedViews];
        }];
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WITH, lastView.bottom + 30);
}

- (void)reloadSelectedViews {
    for (int i = 0; i < self.selectedArray.count + 1; i ++) {
        PINTopicView *topicView = [self.whiteGroundView viewWithTag:kSelectedViewTag + i];
        [topicView removeFromSuperview];
        topicView = nil;
    }

    __block PINTopicView *lastView = nil;
    __block CGFloat kLineSpacing = FITHEIGHT(17);
    __block CGFloat kTopSpacing = FITHEIGHT(18);
    [self.selectedArray enumerateObjectsUsingBlock:^(PSModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PINTopicView *topicView = [[PINTopicView alloc] initWithSelected:YES model:obj];
        topicView.tag = kSelectedViewTag + idx;
        [self.selectedScrollView addSubview:topicView];
        
        NSInteger row = idx / 2; // 行
        NSInteger column = idx % 2; // 列
        
        // 每行的间距
        if (row == 0) {
            topicView.top = kTopSpacing;
        } else {
            CGFloat heightOfRow = kLineSpacing + topicView.height;
            topicView.top = kTopSpacing + row * heightOfRow;
        }
        
        if (column == 0) {
            topicView.left = FITWITH(10);
        } else {
            // 每列的间距
            topicView.left = lastView.right + FITWITH(15);
        }

        lastView = topicView;
        
        [topicView handleClickWithClosure:^(PINTopicView *totalView) {
            [self.selectedArray removeObject:totalView.model];
            [self reloadSelectedViews];
            
            [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:PINTopicView.class]) {
                    PINTopicView *subview = (PINTopicView *)obj;
                    if (subview.model.guid == totalView.model.guid) {
                        subview.selected = NO;
                    }
                }
            }];
        }];
    }];
    
    self.selectedScrollView.contentSize = CGSizeMake(self.selectedScrollView.width, lastView.bottom + 10);
    
    self.publishButton.backgroundColor = self.selectedArray.count > 0 ? HEXCOLOR(pinColorPink) : HEXCOLOR(pinColorLightGray);
    self.publishButton.userInteractionEnabled = _selectedArray.count > 0 ? YES : NO;
}

#pragma mark -
#pragma mark - building UI
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = Building_UILabel(FontBold(fFont17), HEXCOLOR(pinColorPink), 1, 0);
        _promptLabel.text = @"请确认分享标签";
        _promptLabel.backgroundColor = HEXCOLOR(pinColorWhite);
#pragma mark 添加搜索框使用 _promptLabel.top = 70;
        _promptLabel.top = FITHEIGHT(20);
        _promptLabel.size = CGSizeMake(FITHEIGHT(150), FITHEIGHT(20));
        _promptLabel.centerX = SCREEN_WITH / 2;
    }
    return _promptLabel;
}

- (UILabel *)selectedLabel {
    if (!_selectedLabel) {
        _selectedLabel = Building_UILabel(Font(fFont17), HEXCOLOR(pinColorBlack), 1, 0);
        _selectedLabel.backgroundColor = HEXCOLOR(pinColorWhite);
        _selectedLabel.text = @"已选";
        _selectedLabel.size = CGSizeMake(FITHEIGHT(50), FITHEIGHT(15));
#pragma mark 添加搜索框使用 _selectedLabel.top = 110;
        _selectedLabel.top = FITHEIGHT(70);
        _selectedLabel.left = kPadding;
    }
    return _selectedLabel;
}

- (UIScrollView *)selectedScrollView {
    if (!_selectedScrollView) {
        _selectedScrollView = [[UIScrollView alloc] init];
        _selectedScrollView.backgroundColor = [UIColor whiteColor];
        _selectedScrollView.showsVerticalScrollIndicator = YES;
        _selectedScrollView.directionalLockEnabled = YES;
        _selectedScrollView.width = SCREEN_WITH - self.selectedLabel.right - 20 - 20;
        _selectedScrollView.height = FITHEIGHT(58);
        _selectedScrollView.top = self.promptLabel.bottom + FITHEIGHT(5);
        _selectedScrollView.left = self.selectedLabel.right + FITHEIGHT(20);
    }
    return _selectedScrollView;
}

- (UIView *)allTopicsView {
    if (!_allTopicsView) {
        _allTopicsView = Building_UIView();
        _allTopicsView.size = CGSizeMake(SCREEN_WITH, FITHEIGHT(40));
        _allTopicsView.centerX = SCREEN_WITH / 2;
#pragma mark 添加搜索框使用 _allTopicsLabel.top = 150;
        _allTopicsView.top = FITHEIGHT(115);
        
        UILabel *label = Building_UILabel(Font(fFont17), HEXCOLOR(pinColorBlack), 1, 0);
        label.size = CGSizeMake(FITWITH(100), FITHEIGHT(40));
        label.centerX =  SCREEN_WITH / 2;
        label.text = @"全部话题";
        [_allTopicsView addSubview:label];
        
        UIView *leftLine = Building_UIView();
        leftLine.backgroundColor = HEXCOLOR(pinColorLightGray);
        [_allTopicsView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_allTopicsView).offset(kPadding);
            make.height.equalTo(@1);
            make.right.equalTo(label.mas_left).offset(-FITWITH(10));
            make.top.equalTo(_allTopicsView).offset(FITWITH(19.5));
        }];
        
        UIView *rightLine = Building_UIView();
        rightLine.backgroundColor = HEXCOLOR(pinColorLightGray);
        [_allTopicsView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_allTopicsView).offset(-kPadding);
            make.height.equalTo(@1);
            make.left.equalTo(label.mas_right).offset(FITWITH(10));
            make.top.equalTo(_allTopicsView).offset(FITWITH(19.5));
        }];
    }
    return _allTopicsView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        self.searchBar = [[UISearchBar alloc] init];
#pragma mark warning by shi 高度46改为0
//        _searchBar.frame = CGRectMake(kPadding, 18, SCREEN_WITH - 2 * kPadding, 46);
        _searchBar.placeholder = @"搜索兴趣与话题";
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.hidden = YES;
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            searchField.backgroundColor = HEXCOLOR(0xf4f4f4);
            searchField.layer.cornerRadius = 14.f;
            searchField.layer.borderColor = HEXCOLOR(0xff6767).CGColor;
            searchField.layer.borderWidth = 1.f;
            searchField.layer.masksToBounds = YES;
        }
    }
    return _searchBar;
}

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishButton setTitle:@"确 认 并 发 布" forState:UIControlStateNormal];
        [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishButton.titleLabel.font = Font(fFont19);
        [_publishButton addTarget:self action:@selector(publishButtonHandleAction:) forControlEvents:UIControlEventTouchUpInside];
        _publishButton.size = CGSizeMake(SCREEN_WITH, FITHEIGHT(56));
        _publishButton.bottom = kWhiteGroundViewHeight;
    }
    return _publishButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.width = SCREEN_WITH;
        _scrollView.top = self.allTopicsView.bottom + FITHEIGHT(10);
        _scrollView.left = 0;
        _scrollView.height = self.publishButton.top - self.allTopicsView.bottom - FITHEIGHT(20);
    }
    return _scrollView;
}

- (UIView *)blackGroundView {
    if (!_blackGroundView) {
        _blackGroundView = [[UIView alloc] init];
        _blackGroundView.alpha = kBlackGroundViewAlpha;
        _blackGroundView.backgroundColor = [UIColor blackColor];
        _blackGroundView.size = CGSizeMake(SCREEN_WITH, SCREEN_HEIGHT);
        /*
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBlackGroundViewAction:)];
        tap.numberOfTapsRequired = 1;
        [_blackGroundView addGestureRecognizer:tap];
         */
    }
    return _blackGroundView;
}

- (UIView *)whiteGroundView {
    if (!_whiteGroundView) {
        _whiteGroundView = [[UIView alloc] init];
        _whiteGroundView.backgroundColor = [UIColor whiteColor];
        _whiteGroundView.size = CGSizeMake(SCREEN_WITH, kWhiteGroundViewHeight);
        _whiteGroundView.top = SCREEN_HEIGHT;
    }
    return _whiteGroundView;
}

- (void)setSelectedArray:(NSMutableArray<PSModel *> *)selectedArray {
    _selectedArray = selectedArray;
    self.publishButton.backgroundColor = _selectedArray.count > 0 ? HEXCOLOR(pinColorPink) : HEXCOLOR(pinColorLightGray);
    self.publishButton.userInteractionEnabled = _selectedArray.count > 0 ? YES : NO;
    [self reloadSelectedViews];
    
    [_selectedArray enumerateObjectsUsingBlock:^(PSModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (UIView *subview in self.scrollView.subviews) {
            if ([subview isKindOfClass:[PINTopicView class]]) {
                PINTopicView *topicView = (PINTopicView *)subview;
                if (obj.guid == topicView.model.guid) {
                    topicView.selected = YES;
                }
            }
        }
    }];
}

#pragma mark -
#pragma mark - show and hidden with animation
//- (void)hiddenBlackGroundViewAction:(UITapGestureRecognizer *)sender {
//    [self hidden];
//}

- (void)show {
    [pinSheAppDelegate().window addSubview:self.blackGroundView];
    [pinSheAppDelegate().window addSubview:self.whiteGroundView];
    
    self.blackGroundView.hidden = NO;
    self.whiteGroundView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackGroundView.alpha = kBlackGroundViewAlpha;
        self.whiteGroundView.top = SCREEN_HEIGHT - kWhiteGroundViewHeight;
    } completion:nil];
}

- (void)hidden {
    [UIView animateWithDuration:0.5 animations:^{
        self.blackGroundView.alpha = 0.f;
        self.whiteGroundView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.blackGroundView.alpha = 0.f;
        self.blackGroundView.hidden = YES;
        self.whiteGroundView.hidden = YES;
        
        [self.blackGroundView removeFromSuperview];
        [self.whiteGroundView removeFromSuperview];
    }];
}

@end
