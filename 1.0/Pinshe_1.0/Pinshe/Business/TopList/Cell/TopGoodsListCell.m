//
//  TopGoodsListCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "TopGoodsListCell.h"
#import "TopProductModel.h"

@implementation TopGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(pinColorWhite);
        [self buildingUI];
        [self layoutUI];
    }
    return self;
}

- (void)buildingUI {
    self.picImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageShadow:self.picImageview];
    self.topNumImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont17), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 1);
    self.pinShareImageview1 = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageCircle:self.pinShareImageview1];
    self.pinShareImageview2 = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageCircle:self.pinShareImageview2];
    self.pinShareImageview3 = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageCircle:self.pinShareImageview3];

    self.pinShareLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont17), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 1);
    self.supporImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"supportRedSel"));
    self.supportNumLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont17), HEXCOLOR(pinColorPink), NSTextAlignmentLeft, 1);
}

- (void)layoutUI {
    float leftOffset = FITHEIGHT(24);
    [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(FITHEIGHT(15));
        make.width.height.equalTo(@(FITHEIGHT(120)));
    }];
    
    [self.topNumImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picImageview.mas_top).offset(-(FITWITH(12)));
        make.left.equalTo(self.picImageview.mas_right).offset(-(FITWITH(12)));
        make.width.height.equalTo(@(FITWITH(24)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageview.mas_right).offset(leftOffset);
        make.top.equalTo(self.picImageview.mas_top).offset(FITHEIGHT(5));
        make.right.equalTo(self.contentView).offset(-FITWITH(10));
        make.height.equalTo(@(FITHEIGHT(33)));
    }];
    
    [self.pinShareImageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageview.mas_right).offset(leftOffset);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(leftOffset));
    }];
    
    [self.pinShareImageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinShareImageview1.mas_right).offset(2);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(leftOffset));
    }];
    
    [self.pinShareImageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinShareImageview2.mas_right).offset(2);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(leftOffset));
    }];
    
    [self.supporImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageview.mas_right).offset(leftOffset);
        make.bottom.equalTo(self.picImageview.mas_bottom).offset(-FITHEIGHT(5));
        make.width.equalTo(@(FITWITH(25)));
        make.height.equalTo(@(FITHEIGHT(20)));
    }];
    
    [self.supportNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.supporImageview.mas_right).offset(FITWITH(9));
        make.top.equalTo(self.supporImageview.mas_top);
        make.bottom.equalTo(self.supporImageview.mas_bottom);
        make.right.equalTo(self.contentView).offset(-FITWITH(10));
    }];
    
}

- (void)restLayoutUI:(int)userCount {
    if (userCount == 1) {
        [self.pinShareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareImageview1.mas_right).offset(FITHEIGHT(5));
            make.top.equalTo(self.pinShareImageview1.mas_top);
            make.bottom.equalTo(self.pinShareImageview1.mas_bottom);
            make.right.equalTo(self.contentView).offset(-FITWITH(10));
        }];
    } else if (userCount == 2) {
        [self.pinShareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareImageview2.mas_right).offset(FITHEIGHT(5));
            make.top.equalTo(self.pinShareImageview2.mas_top);
            make.bottom.equalTo(self.pinShareImageview2.mas_bottom);
            make.right.equalTo(self.contentView).offset(-FITWITH(10));
        }];
    } else {
        [self.pinShareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareImageview3.mas_right).offset(FITHEIGHT(5));
            make.top.equalTo(self.pinShareImageview3.mas_top);
            make.bottom.equalTo(self.pinShareImageview3.mas_bottom);
            make.right.equalTo(self.contentView).offset(-FITWITH(10));
        }];
    }
    
}

- (void)resetTopGoodsListCell:(TopProductModel *)model {
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:model.product_image] placeholderImage:nil];
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", model.product_brand, model.product_brand.length > 0 ? [NSString stringWithFormat:@" %@", model.product_name] : model.product_name];

    self.pinShareImageview1.hidden = YES;
    self.pinShareImageview2.hidden = YES;
    self.pinShareImageview3.hidden = YES;

    if (model.user_count > 0) {
        self.pinShareLabel.text = @"推荐";
        self.pinShareImageview1.hidden = NO;
        [self.pinShareImageview1 sd_setImageWithURL:[NSURL URLWithString:model.user1_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
        if (model.user_count == 2) {
            self.pinShareImageview2.hidden = NO;
            [self.pinShareImageview2 sd_setImageWithURL:[NSURL URLWithString:model.user2_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
        } else if (model.user_count >= 3) {
            self.pinShareImageview2.hidden = NO;
            self.pinShareImageview3.hidden = NO;
            [self.pinShareImageview2 sd_setImageWithURL:[NSURL URLWithString:model.user2_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
            [self.pinShareImageview3 sd_setImageWithURL:[NSURL URLWithString:model.user3_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
        }
    }

    if (model.user_count >= 3) {
        self.pinShareLabel.text = [NSString stringWithFormat:@"等%zd位品友推荐", model.user_count];
    }
    
    self.supportNumLabel.text = [NSString stringWithFormat:@"%zd", model.product_favorite];
    [self restLayoutUI:model.user_count];
}

- (void)getImageCircle:(UIImageView *)imageview {
    imageview.layer.cornerRadius = FITHEIGHT(24) / 2.0;
    imageview.layer.masksToBounds = YES;
}

- (void)getImageShadow:(UIImageView *)imageview {
    [imageview.layer setShadowColor:HEXCOLOR(pinColorBlack).CGColor];
    imageview.layer.shadowOffset = CGSizeMake(6, 0);
    imageview.layer.shadowOpacity = 0.5;
    imageview.layer.shadowRadius = 5;
    imageview.layer.borderColor = HEXCOLOR(pinColorTextDarkGray).CGColor;
    imageview.layer.borderWidth = 0.5;
}

@end
