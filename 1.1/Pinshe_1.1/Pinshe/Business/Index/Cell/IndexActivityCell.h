//
//  IndexActivityCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/8.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexVote, CompareView;
typedef void (^ShareBlock) (IndexVote *indexVote);
typedef void (^CompareBolck) (IndexVote *indexVote, BOOL isLeft); // 在首页请求接口

@interface IndexActivityCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *questionLabel; // 问题
@property (nonatomic, strong) UILabel *currentPageLabel; // 当前页数
@property (nonatomic, strong) UIButton *shareButton; // 分享按钮
@property (nonatomic, copy) ShareBlock shareBlock;

@property (nonatomic, strong) CompareView *compareView;

@property (nonatomic, strong) UIView *chooseView; // 选择视图
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) CompareBolck compareBolck;

// 用户头像，名字视图
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *leftHeadView;
@property (nonatomic, strong) UIView *rightHeadView;
@property (nonatomic, strong) UIImageView *headImageview_a;
@property (nonatomic, strong) UILabel *nameLabel_a;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIImageView *headImageview_b;
@property (nonatomic, strong) UILabel *nameLabel_b;

// 用户浏览回复数量视图
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *leftInfoView;
@property (nonatomic, strong) UIView *rightInfoView;
@property (nonatomic, strong) UIImageView *browserImageview_a;
@property (nonatomic, strong) UILabel *browserLabel_a;
@property (nonatomic, strong) UIImageView *replyImageview_a;
@property (nonatomic, strong) UILabel *replyLabel_a;
@property (nonatomic, strong) UIButton *detailButton_a;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *browserImageview_b;
@property (nonatomic, strong) UILabel *browserLabel_b;
@property (nonatomic, strong) UIImageView *replyImageview_b;
@property (nonatomic, strong) UILabel *replyLabel_b;
@property (nonatomic, strong) UIButton *detailButton_b;

@property (nonatomic, strong) IndexVote *indexvote;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)resetIndexActivityCell:(IndexVote *)model withIndexPath:(NSIndexPath *)indexPath;
- (void)shareDetail:(ShareBlock)block;
- (void)compareviewBolck:(CompareBolck)block;

@end
