//
//  DetailCompareCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DetailComparePushProductDetailBlock)(int productId);

@class DetailVoteModel;
@interface DetailCompareCell : UITableViewCell

// 问题
@property (nonatomic, strong) UIView *describeView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *picView;
@property (nonatomic, strong) UIImageView *picImageviewLeft;
@property (nonatomic, strong) UIImageView *picImageviewLeftIcon;

@property (nonatomic, strong) UIImageView *picImageviewRight;
@property (nonatomic, strong) UIImageView *picImageviewRightIcon;

@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) DetailVoteModel *detailVote;

@property (nonatomic, copy) DetailComparePushProductDetailBlock detailBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetRecommendCell:(DetailVoteModel *)detailVote;

- (void)pushProductDetail:(DetailComparePushProductDetailBlock)block;

@end
