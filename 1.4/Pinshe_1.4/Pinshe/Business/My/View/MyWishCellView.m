//
//  MyWishCellView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyWishCellView.h"
#import "MyWishVoteModel.h"
#import "MyWishPostModel.h"

@implementation MyWishCellView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, (SCREEN_WITH - 30) / 2.0, FITHEIGHT(375));
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.bgView = Building_UIViewWithSuperView(self);
    self.bgView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    self.topView = Building_UIViewWithSuperView(self.bgView);
    self.topView.backgroundColor = HEXCOLOR(pinColorWhite);
    self.lineView = Building_UIViewWithSuperView(self.bgView);
    self.lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    self.bottomView = Building_UIViewWithSuperView(self.bgView);
    self.bottomView.backgroundColor = HEXCOLOR(pinColorWhite);
    
    self.picImageview = Building_UIImageViewWithSuperView(self.topView, nil);
    self.picImageview.clipsToBounds = YES;
    self.picImageview.contentMode = UIViewContentModeScaleAspectFill;
    self.titleLabel = Building_UILabelWithSuperView(self.topView, Font(fFont14), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 2);
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
        make.left.top.bottom.right.equalTo(self);
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

- (void)resetMyWishPostCellView:(MyWishPostModel *)model {
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

- (void)resetMyWishVoteCellView:(MyWishVoteModel *)model {
    if (model.product_a_guid > 0) {
        [self.picImageview sd_setImageWithURL:[NSURL URLWithString:model.product_a_image] placeholderImage:nil];
    } else {
        [self.picImageview sd_setImageWithURL:[NSURL URLWithString:model.posta_image] placeholderImage:nil];
    }

    self.titleLabel.text = @"";
    
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:model.vote_user_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    self.nameLabel.text = model.vote_user_name;
    
    self.descriptionLabel.text = model.vote_name;
    self.timeLabel.text = model.vote_modify_time;
    self.browserNumLabel.text = [NSString stringWithFormat:@"%zd", model.vote_view];
    self.replyNumLabel.text = [NSString stringWithFormat:@"%zd", model.vote_comment];
    [self layoutUI];
}

@end