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
    self.leftHeadView = Building_UIViewWithSuperView(self.headView);
    self.rightHeadView = Building_UIViewWithSuperView(self.headView);
    // 第一个用户头像名字
    self.headImageview_a = Building_UIImageViewWithSuperView(self.leftHeadView, nil);
    self.headImageview_a.layer.masksToBounds = YES;
    self.headImageview_a.layer.cornerRadius = 10;
    
    self.nameLabel_a = Building_UILabelWithSuperView(self.leftHeadView, Font(fFont12), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    // 线
    self.topLineView = Building_UIViewWithSuperView(self.headView);
    self.topLineView.backgroundColor = HEXCOLOR(pinColorTextLightGray);
    
    // 第二个用户头像名字
    self.headImageview_b = Building_UIImageViewWithSuperView(self.rightHeadView, nil);
    self.headImageview_b.layer.masksToBounds = YES;
    self.headImageview_b.layer.cornerRadius = 10;
    
    self.nameLabel_b = Building_UILabelWithSuperView(self.rightHeadView, Font(fFont12), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    // 浏览回复视图
    self.infoView = Building_UIViewWithSuperView(self.chooseView);
    self.infoView.backgroundColor = HEXCOLOR(pinColorWhite);
    self.leftInfoView = Building_UIViewWithSuperView(self.infoView);
    self.rightInfoView = Building_UIViewWithSuperView(self.infoView);
    // 第一个用户浏览数
    self.browserImageview_a = Building_UIImageViewWithSuperView(self.leftInfoView, IMG_Name(@"browse"));
    self.browserLabel_a = Building_UILabelWithSuperView(self.leftInfoView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    self.replyImageview_a = Building_UIImageViewWithSuperView(self.leftInfoView, IMG_Name(@"reply"));
    self.replyLabel_a = Building_UILabelWithSuperView(self.leftInfoView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    self.detailButton_a = Building_UIButtonWithSuperView(self.leftInfoView, self, @selector(detailButton:), nil);
    [self.detailButton_a setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.detailButton_a setTitleColor:HEXCOLOR(pinColorTextLightGray) forState:UIControlStateNormal];
    self.detailButton_a.titleLabel.font = Font(fFont11);
    
    // 线
    self.bottomLineView = Building_UIViewWithSuperView(self.infoView);
    self.bottomLineView.backgroundColor = HEXCOLOR(pinColorTextLightGray);
    
    // 第二个用户浏览数
    self.browserImageview_b = Building_UIImageViewWithSuperView(self.rightInfoView, IMG_Name(@"browse"));
    self.browserLabel_b = Building_UILabelWithSuperView(self.rightInfoView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    self.replyImageview_b = Building_UIImageViewWithSuperView(self.rightInfoView, IMG_Name(@"reply"));
    self.replyLabel_b = Building_UILabelWithSuperView(self.rightInfoView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    self.detailButton_b = Building_UIButtonWithSuperView(self.rightInfoView, self, @selector(detailButton:), nil);
    [self.detailButton_b setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.detailButton_b setTitleColor:HEXCOLOR(pinColorTextLightGray) forState:UIControlStateNormal];
    self.detailButton_b.titleLabel.font = Font(fFont11);
}

- (void)layoutUI:(NSString *)questionStr withOne:(BOOL)isOne {
    float imageW = SCREEN_WITH / 2.0;
    float imageH = imageW;
    float userHeight = FITHEIGHT(72) / 2.0;
    
    [self.chooseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(imageH + FITHEIGHT(72));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WITH);
    }];
    
    float questionLabelHeight = [NSString getTextHeight:SCREEN_WITH - 50 text:questionStr fontSize:fFont18 isSuo:NO];
    
    float gapHeight = (SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT - imageH - FITHEIGHT(72)) / 2.0;
    
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
    
    if ([WXApi isWXAppInstalled]) {
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
    
    [self.leftHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headView);
        make.width.equalTo(@(SCREEN_WITH / 2.0 - 0.5));
    }];
    
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftHeadView.mas_right);
        make.top.equalTo(self.headView).offset(5);
        make.bottom.equalTo(self.headView).offset(-5);
        make.width.equalTo(@1);
    }];
    
    [self.rightHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLineView.mas_right);
        make.right.top.bottom.equalTo(self.headView);
    }];
    
    [self.headImageview_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftHeadView);
        make.left.equalTo(@12);
        make.width.height.equalTo(@20);
    }];
    
    [self.nameLabel_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview_a.mas_right).offset(3);
        make.top.bottom.equalTo(self.leftHeadView);
        make.right.equalTo(self.leftHeadView).offset(-12);
    }];
    
    [self.headImageview_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightHeadView);
        make.left.equalTo(@12);
        make.width.height.equalTo(@20);
    }];
    
    [self.nameLabel_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview_b.mas_right).offset(3);
        make.top.bottom.equalTo(self.rightHeadView);
        make.right.equalTo(self.rightHeadView).offset(-12);
    }];
    
    // 用户浏览数视图
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.chooseView);
        make.bottom.equalTo(self.chooseView);
        make.height.equalTo(@(userHeight));
    }];
    
    [self.leftInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.infoView);
        if (isOne) {
            make.width.equalTo(@(SCREEN_WITH));
        } else {
            make.width.equalTo(@(SCREEN_WITH / 2.0 - 0.5));
        }
    }];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftInfoView.mas_right);
        make.top.equalTo(self.infoView).offset(5);
        make.bottom.equalTo(self.infoView).offset(-5);
        make.width.equalTo(@1);
    }];
    
    [self.rightInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomLineView.mas_right);
        make.width.mas_equalTo(SCREEN_WITH / 2);
        make.top.bottom.equalTo(self.infoView);
    }];
    
    float height = FRAME_HEIGHT(32);
    
    // 第一个用户
    [self.browserImageview_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftInfoView).offset(12);
        make.centerY.equalTo(self.leftInfoView);
        make.width.equalTo(@14);
        make.height.equalTo(@(height));
    }];
    
    [self.browserLabel_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.browserImageview_a.mas_right).offset(3);
        make.centerY.equalTo(self.leftInfoView);
        make.height.equalTo(@(height));
    }];
    
    [self.replyImageview_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.browserLabel_a.mas_right).offset(6);
        make.centerY.equalTo(self.leftInfoView);
        make.width.equalTo(@14);
        make.height.equalTo(@(height));
    }];
    
    [self.replyLabel_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyImageview_a.mas_right).offset(3);
        make.centerY.equalTo(self.leftInfoView);
        make.height.equalTo(@(height));
    }];
    
    [self.detailButton_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftInfoView);
        make.centerY.equalTo(self.leftInfoView);
        make.width.equalTo(@(FITWITH(70)));
    }];
    
    // 第二个用户
    [self.browserImageview_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightInfoView).offset(12);
        make.centerY.equalTo(self.rightInfoView);
        make.width.equalTo(@14);
        make.height.equalTo(@(height));
    }];
    
    [self.browserLabel_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.browserImageview_b.mas_right).offset(3);
        make.centerY.equalTo(self.rightInfoView);
        make.height.equalTo(@(height));
    }];
    
    [self.replyImageview_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.browserLabel_b.mas_right).offset(6);
        make.centerY.equalTo(self.rightInfoView);
        make.width.equalTo(@14);
        make.height.equalTo(@(height));
    }];
    
    [self.replyLabel_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyImageview_b.mas_right).offset(3);
        make.centerY.equalTo(self.rightInfoView);
        make.height.equalTo(@(height));
    }];
    
    [self.detailButton_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightInfoView);
        make.centerY.equalTo(self.rightInfoView);
        make.width.equalTo(@(FITWITH(70)));
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
    } else {
        self.shareButton.hidden = NO;
        self.compareView.hidden = YES;
    }
    // 问题
    self.questionLabel.text = indexVoteModel.vote_name;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.posta_image] placeholderImage:nil];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.postb_image] placeholderImage:nil];

    self.leftButton.tag = Left_Button_tag + indexPath.item;
    self.rightButton.tag = Right_Button_tag + indexPath.item;
    self.shareButton.tag = indexPath.item;
    
    // 初始状态
    self.topLineView.hidden = YES;
    self.headImageview_b.hidden = YES;
    self.nameLabel_b.hidden = YES;
    self.bottomLineView.hidden = YES;
    self.browserImageview_b.hidden = YES;
    self.browserLabel_b.hidden = YES;
    self.replyImageview_b.hidden = YES;
    self.replyLabel_b.hidden = YES;
    self.detailButton_b.hidden = YES;
    
    // 第一个用户头像,名字
    [self.headImageview_a sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.usera_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    self.nameLabel_a.text = indexVoteModel.usera_name;
    self.browserLabel_a.text = [NSString stringWithFormat:@"%zd", indexVoteModel.vote_view];
    self.replyLabel_a.text = [NSString stringWithFormat:@"%zd", indexVoteModel.vote_comment];
    if (indexVoteModel.vote_user_id == 0) { // 有2个用户
        self.topLineView.hidden = NO;
        self.headImageview_b.hidden = NO;
        self.nameLabel_b.hidden = NO;
        self.bottomLineView.hidden = NO;
        self.browserImageview_b.hidden = NO;
        self.browserLabel_b.hidden = NO;
        self.replyImageview_b.hidden = NO;
        self.replyLabel_b.hidden = NO;
        self.detailButton_b.hidden = NO;
        [self.headImageview_b sd_setImageWithURL:[NSURL URLWithString:indexVoteModel.userb_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
        self.nameLabel_b.text = indexVoteModel.usera_name;
        
        self.browserLabel_a.text = [NSString stringWithFormat:@"%zd", indexVoteModel.posta_view];
        self.replyLabel_a.text = [NSString stringWithFormat:@"%zd", indexVoteModel.posta_comment];
        self.browserLabel_b.text = [NSString stringWithFormat:@"%zd", indexVoteModel.postb_view];
        self.replyLabel_b.text = [NSString stringWithFormat:@"%zd", indexVoteModel.postb_comment];
        
    }
    [self layoutUI:self.questionLabel.text withOne:(indexVoteModel.vote_user_id == 0 ? NO : YES)];
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
    self.indexvote.isOpen = YES;
    self.shareButton.hidden = YES;
    self.compareView.hidden = NO;
    self.compareView.currentPage = isLeft ? (button.tag -  Left_Button_tag) : (button.tag - Right_Button_tag);
    
    [self.compareView freshData:self.indexvote isLeft:isLeft];
}

- (void)showCompareView {
    
}

// 查看详情
- (void)detailButton:(UIButton *)button {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithBool:self.indexvote.vote_user_id > 0 ? YES : NO] forKey:@"isOne"];
    if (self.indexvote.vote_user_id > 0) {
        [userInfo setObject:@(self.indexvote.vote_guid) forKey:@"id"];
    } else {
        if (self.clickedLeft) {
            [userInfo setObject:@(self.indexvote.posta_guid) forKey:@"id"];
        } else {
            [userInfo setObject:@(self.indexvote.postb_guid) forKey:@"id"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIndexDetail object:nil userInfo:userInfo];
    [NSObject event:@"PX001" label:@"首页查看详情"];
}

@end
