//
//  IndexActivityCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/8.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "IndexActivityCell.h"
#import "CompareView.h"
#import "IndexVote.h"

#define Left_Button_tag 10000000
#define Right_Button_tag 20000000

@interface IndexActivityCell ()

@property (nonatomic, assign) BOOL clickedLeft;

@end


@implementation IndexActivityCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.questionLabel = Building_UILabelWithSuperView(self.contentView, FontNotSou(fFont18), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);

    self.currentPageLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont12), HEXCOLOR(pinColorPink), NSTextAlignmentCenter, 0);
    
    self.shareButton = Building_UIButtonWithSuperView(self.contentView, self, @selector(shareButtonAction:), nil);
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    self.chooseView = Building_UIViewWithSuperView(self.contentView);
    self.leftButton = Building_UIButtonWithSuperView(self.chooseView, self, @selector(leftButton:), nil);
    self.rightButton = Building_UIButtonWithSuperView(self.chooseView, self, @selector(rightButton:), nil);
    self.leftImageView = Building_UIImageViewWithSuperView(self.chooseView, nil);
    self.leftImageView.clipsToBounds = YES;
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImageView = Building_UIImageViewWithSuperView(self.chooseView, nil);
    self.rightImageView.clipsToBounds = YES;
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 选择视图
    self.compareView = [[CompareView alloc] init];
    [self.contentView addSubview:_compareView];
    self.compareView.clipsToBounds = YES;
    self.compareView.hidden = YES;
    
    // 视图
    self.headView = Building_UIViewWithSuperView(self.chooseView);
    self.headView.backgroundColor = HEXCOLOR(pinColorWhite);
    // 用户头像名字
    self.headImageview_a = Building_UIImageViewWithSuperView(self.headView, nil);
    self.headImageview_a.layer.masksToBounds = YES;
    self.headImageview_a.layer.cornerRadius = 10;
    
    self.nameLabel_a = Building_UILabelWithSuperView(self.headView, Font(fFont12), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);

}

- (void)layoutUI:(NSString *)questionStr {
    float imageW = SCREEN_WITH / 2.0;
    float imageH = imageW;
    float userHeight = FITHEIGHT(72) / 2.0;
    
    float questionLabelHeight = [NSString getTextHeight:SCREEN_WITH - 50 text:questionStr fontSize:fFont18 isSuo:NO];
    
    float gapHeight = (SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT - imageH - userHeight) / 2.0;
    
    [self.chooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(imageH + userHeight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WITH);
    }];
    
    
    [self.questionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset((gapHeight - questionLabelHeight) / 2.0 - 15);
        make.centerX.equalTo(self.contentView);
        if (questionLabelHeight > 28) {
            make.width.equalTo(@(SCREEN_WITH - 50));
        } else {
            make.height.equalTo(@(questionLabelHeight));
        }
    }];
    
    [self.currentPageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.chooseView.mas_top).offset(-15);
        make.width.equalTo(@100);
    }];
    
    if (isWXAppInstalled()) {
        [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-(gapHeight - FITHEIGHT(37)) / 2.0);
            make.width.equalTo(@(FITWITH(119)));
            make.height.equalTo(@(FITHEIGHT(37)));
        }];
    }
    
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseView).offset(userHeight);
        make.left.equalTo(self.chooseView);
        make.width.equalTo(@(imageW));
        make.height.equalTo(@(imageH));
    }];
    
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.leftButton);
    }];
    
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseView).offset(userHeight);
        make.right.equalTo(self.chooseView);
        make.width.equalTo(@(imageW));
        make.height.equalTo(@(imageH));
    }];
    
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rightButton);
    }];
    
    // 用户头像视图
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.chooseView);
        make.height.equalTo(@(userHeight));
    }];

    [self.headImageview_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView);
        make.left.equalTo(@12);
        make.width.height.equalTo(@20);
    }];
    
    [self.nameLabel_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview_a.mas_right).offset(3);
        make.top.bottom.equalTo(self.headView);
        make.right.equalTo(self.headView).offset(-12);
    }];

    [self.compareView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseView);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(7));
    }];
}

- (void)resetIndexActivityCell:(IndexVote *)indexVoteModel withIndexPath:(NSIndexPath *)indexPath {
    self.indexvote = indexVoteModel;
    
    if (self.indexvote.isOpen) {
        self.shareButton.hidden = YES;
        self.compareView.hidden = NO;
        [self.compareView freshData:self.indexvote isLeft:indexVoteModel.isLeft];
    } else {
        self.shareButton.hidden = NO;
        self.compareView.hidden = YES;
    }
    // 问题
    self.questionLabel.text = indexVoteModel.vote_name;
    if (indexVoteModel.product_a_guid > 0) { // 商品的品选
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.product_a_image] placeholderImage:nil];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.product_b_image] placeholderImage:nil];
    } else {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.posta_image] placeholderImage:nil];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.postb_image] placeholderImage:nil];
    }

    self.leftButton.tag = Left_Button_tag + indexPath.item;
    self.rightButton.tag = Right_Button_tag + indexPath.item;
    self.shareButton.tag = indexPath.item;

    // 用户头像,名字
    [self.headImageview_a sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.vote_user_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    self.nameLabel_a.text = indexVoteModel.vote_user_name;

    [self layoutUI:self.questionLabel.text];
}

#pragma mark -
#pragma mark button Action

// 分享
- (void)shareButtonAction:(UIButton *)button {
    if (_shareBlock) {
        _shareBlock(self.indexvote);
    }
}

- (void)shareDetail:(ShareBlock)block {
    self.shareBlock = block;
}

- (void)compareviewBolck:(CompareBolck)block {
    self.compareBolck = block;
}

// 显示动画
- (void)leftButton:(UIButton *)button {
    [self showCampare:YES button:button];
}

- (void)rightButton:(UIButton *)button {
    [self showCampare:NO button:button];
}

- (void)showCampare:(BOOL)isLeft button:(UIButton *)button {
    PLog(@"leftButton : %zd", button.tag);
    self.clickedLeft = isLeft;
    
    if (self.compareBolck) {
        self.compareBolck(self.indexvote, isLeft);
    }

    self.compareView.currentPage = isLeft ? (button.tag -  Left_Button_tag) : (button.tag - Right_Button_tag);
}

@end
