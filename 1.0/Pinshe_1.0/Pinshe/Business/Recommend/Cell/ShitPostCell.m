//
//  ShitPostCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "ShitPostCell.h"
#import "PostModel.h"

@implementation ShitPostCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.bgView = Building_UIViewWithSuperView(self.contentView);
    self.bgView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    self.topView = Building_UIViewWithSuperView(self.bgView);
    self.topView.backgroundColor = HEXCOLOR(pinColorWhite);
    self.lineView = Building_UIViewWithSuperView(self.bgView);
    self.lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    self.bottomView = Building_UIViewWithSuperView(self.bgView);
    self.bottomView.backgroundColor = HEXCOLOR(pinColorWhite);
    
    self.picImageview = Building_UIImageViewWithSuperView(self.topView, nil);
    self.titleLabel = Building_UILabelWithSuperView(self.topView, Font(fFont14), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 2);
    self.supportButton = Building_UIButtonWithSuperView(self.topView, self, @selector(supportButtonAction:), nil);
    self.supportImageview = Building_UIImageViewWithSuperView(self.topView, nil);
    self.supportLabel = Building_UILabelWithSuperView(self.bottomView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
    self.headImageview = Building_UIImageViewWithSuperView(self.bottomView, nil);
    self.headImageview.layer.masksToBounds = YES;
    self.headImageview.layer.cornerRadius = FITWITH(30) / 2.0;
    
    self.nameLabel = Building_UILabelWithSuperView(self.bottomView, Font(fFont13), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    self.descriptionLabel = Building_UILabelWithSuperView(self.bottomView, Font(fFont13), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 2);
    self.timeLabel = Building_UILabelWithSuperView(self.bottomView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
    self.browserImageview = Building_UIImageViewWithSuperView(self.bottomView, IMG_Name(@"browse"));
    self.browserNumLabel = Building_UILabelWithSuperView(self.bottomView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
    self.replyImageview = Building_UIImageViewWithSuperView(self.bottomView, IMG_Name(@"reply"));
    self.replyNumLabel = Building_UILabelWithSuperView(self.bottomView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
    
    [self layoutBaseUI];
}

- (void)layoutBaseUI {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.contentView);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView).offset(1);
        make.right.equalTo(self.bgView).offset(-1);
        make.height.equalTo(@(FITHEIGHT(246)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(1);
        make.right.equalTo(self.bgView).offset(-1);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.equalTo(@1);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(1);
        make.right.bottom.equalTo(self.bgView).offset(-1);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.topView);
        make.height.equalTo(@((SCREEN_WITH - 34) / 2.0));
    }];
    
    float offset = FITWITH(10);
    [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.topView);
        make.top.equalTo(self.picImageview.mas_bottom);
        make.width.equalTo(@(FITWITH(40)));
    }];
    
    [self.supportImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.supportButton).offset(-FITWITH(5));
        make.centerY.equalTo(self.supportButton).offset(-FITHEIGHT(5));
        make.width.equalTo(@(FITWITH(25)));
        make.height.equalTo(@(FITHEIGHT(20)));
    }];
    
    [self.supportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportImageview.mas_bottom).offset(FITHEIGHT(3));
        make.centerX.equalTo(self.supportImageview);
        make.height.equalTo(@(FITHEIGHT(15)));
    }];
    
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bottomView).offset(offset);
        make.width.height.equalTo(@(FITWITH(30)));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview.mas_right).offset(FITWITH(5));
        make.top.bottom.equalTo(self.headImageview);
        make.right.equalTo(self.bottomView).offset(-offset);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(offset);
        make.bottom.equalTo(self.bottomView).offset(-offset);
        make.height.equalTo(@(FITHEIGHT(15)));
    }];
}

- (void)layoutUI {
    float offset = FITWITH(10);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(offset);
        make.top.equalTo(self.picImageview.mas_bottom).offset(offset);
        make.right.equalTo(self.topView).offset(-(FITWITH(40)));
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(offset);
        make.top.equalTo(self.headImageview.mas_bottom).offset(offset);
        make.right.equalTo(self.bottomView).offset(-offset);
    }];
    
    [self.replyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.bottomView).offset(-offset);
        make.height.equalTo(@(FITHEIGHT(11)));
    }];
    
    [self.replyImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.replyNumLabel.mas_left).offset(-FITWITH(4));
        make.bottom.equalTo(self.bottomView).offset(-offset);
        make.width.equalTo(@(FITWITH(14)));
        make.height.equalTo(@(FITHEIGHT(11)));
    }];
    
    [self.browserNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.replyImageview.mas_left).offset(-FITWITH(9));
        make.bottom.equalTo(self.bottomView).offset(-offset);
        make.height.equalTo(@(FITHEIGHT(11)));
    }];
    
    [self.browserImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.browserNumLabel.mas_left).offset(-FITWITH(4));
        make.bottom.equalTo(self.bottomView).offset(-offset);
        make.width.equalTo(@(FITWITH(14)));
        make.height.equalTo(@(FITHEIGHT(11)));
    }];
}

- (void)resetShitPostCell:(PostModel *)model {
    
    self.supportButton.info = model;
    self.supportImageview.image = model.favorite_guid > 0 ? IMG_Name(@"supportBlackSel") : IMG_Name(@"supportGray");
    self.supportLabel.textColor = model.favorite_guid > 0 ? HEXCOLOR(pinColorBlack) : HEXCOLOR(pinColorTextLightGray);
    self.supportLabel.text = [NSString stringWithFormat:@"%zd", model.post_favorite];
    
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:model.post_image] placeholderImage:nil];
    
    self.titleLabel.text = model.post_name;
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:model.user_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    
    self.nameLabel.text = model.user_name;
    self.descriptionLabel.text = model.post_description;
    self.timeLabel.text = model.post_modify_time;
    self.browserNumLabel.text = [NSString stringWithFormat:@"%zd", model.post_view];
    self.replyNumLabel.text = [NSString stringWithFormat:@"%zd", model.post_comment];
    [self layoutUI];
}

- (void)supportButtonAction:(UIButton *)sender {
    if (self.postSupportSelBlock) {
        self.postSupportSelBlock((PostModel *)sender.info);
    }
}

- (void)postSupportSelBlock:(PostSupportSelBlock)block {
    self.postSupportSelBlock = block;
}

@end
