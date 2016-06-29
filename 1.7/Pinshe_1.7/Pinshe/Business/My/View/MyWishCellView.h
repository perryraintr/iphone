//
//  MyWishCellView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyWishVoteModel, MyWishPostModel;
@interface MyWishCellView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *picImageview;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *headImageview;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *browserImageview;

@property (nonatomic, strong) UILabel *browserNumLabel;

@property (nonatomic, strong) UIImageView *replyImageview;

@property (nonatomic, strong) UILabel *replyNumLabel;

- (instancetype)init;

- (void)resetMyWishPostCellView:(MyWishPostModel *)model;

- (void)resetMyWishVoteCellView:(MyWishVoteModel *)model;

@end
