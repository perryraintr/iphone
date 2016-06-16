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
    self.picImageview.clipsToBounds = YES;
    self.picImageview.contentMode = UIViewContentModeScaleAspectFill;
    [self getImageShadow:self.picImageview];
    
    self.topNumImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont17), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 1);
    self.pinShareImageview1 = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageCircle:self.pinShareImageview1];
    self.pinShareImageview2 = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageCircle:self.pinShareImageview2];
    self.pinShareImageview3 = Building_UIImageViewWithSuperView(self.contentView, nil);
    [self getImageCircle:self.pinShareImageview3];

    self.pinShareLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont14), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 1);
    
    self.splitLineView = Building_UIViewWithSuperView(self.contentView);
    self.splitLineView.backgroundColor = HEXCOLOR(pinColorLightGray);
    
    self.supporImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"topProductSupportSel"));
    self.supportNumLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont14), HEXCOLOR(pinColorPink), NSTextAlignmentLeft, 1);
    
    self.firstPriceLabel = Building_UILabelWithSuperView(self.contentView, Font(20), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    self.firstPriceLabel.text = @"￥";
    self.allPriceLabel = Building_UILabelWithSuperView(self.contentView, Font(24), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 0);
    
    self.detailImageView = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"topProductShowDetail"));
}

- (void)layoutUI {
    float leftOffset = FITHEIGHT(24);
    [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(FITHEIGHT(15));
        make.width.height.equalTo(@(FITHEIGHT(100)));
    }];
    
    [self.topNumImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picImageview.mas_top).offset(-(FITWITH(12)));
        make.left.equalTo(self.picImageview.mas_right).offset(-(FITWITH(12)));
        make.width.height.equalTo(@(FITWITH(24)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageview.mas_right).offset(leftOffset);
        make.top.equalTo(self.picImageview.mas_top);
        make.right.equalTo(self.contentView).offset(-FITWITH(10));
        make.height.equalTo(@(FITHEIGHT(20)));
    }];
    
    [self.pinShareImageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageview.mas_right).offset(leftOffset);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(FITHEIGHT(10));
        make.width.height.equalTo(@(FITHEIGHT(20)));
    }];
    
    [self.pinShareImageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinShareImageview1.mas_right).offset(2);
        make.top.equalTo(self.pinShareImageview1.mas_top);
        make.width.height.equalTo(@(FITHEIGHT(20)));
    }];
    
    [self.pinShareImageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinShareImageview2.mas_right).offset(2);
        make.top.equalTo(self.pinShareImageview1.mas_top);
        make.width.height.equalTo(@(FITHEIGHT(20)));
    }];
    
    [self.firstPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(16));
        make.width.height.equalTo(@(FITWITH(20)));
    }];
    
    [self.allPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstPriceLabel.mas_right);
        make.top.equalTo(self.firstPriceLabel.mas_top).offset(-FITHEIGHT(5));
        make.height.equalTo(@(FITHEIGHT(27)));
    }];
    
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(16));
        make.right.equalTo(self.contentView).offset(-FITWITH(15));
        make.width.equalTo(@(FITWITH(89)));
        make.height.equalTo(@(FITHEIGHT(30)));
    }];
    
}

- (void)restLayoutUI:(int)userCount {
    if (userCount == 1) {
        [self.pinShareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareImageview1.mas_right).offset(FITHEIGHT(5));
            make.top.equalTo(self.pinShareImageview1.mas_top);
            make.bottom.equalTo(self.pinShareImageview1.mas_bottom);
        }];
    } else if (userCount == 2) {
        [self.pinShareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareImageview2.mas_right).offset(FITHEIGHT(5));
            make.top.equalTo(self.pinShareImageview2.mas_top);
            make.bottom.equalTo(self.pinShareImageview2.mas_bottom);
        }];
    } else {
        [self.pinShareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareImageview3.mas_right).offset(FITHEIGHT(5));
            make.top.equalTo(self.pinShareImageview3.mas_top);
            make.bottom.equalTo(self.pinShareImageview3.mas_bottom);
        }];
    }
    
    if (userCount > 0) {
        [self.splitLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinShareLabel.mas_right).offset(FITWITH(5));
            make.centerY.equalTo(self.pinShareLabel);
            make.width.equalTo(@(1));
            make.height.equalTo(@(FITHEIGHT(15)));
        }];
        
        [self.supportNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.splitLineView.mas_right).offset(FITWITH(5));
            make.top.bottom.equalTo(self.splitLineView);
        }];
    } else {
        
        [self.supportNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.picImageview.mas_right).offset(FITWITH(24));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(FITHEIGHT(10));
            make.height.equalTo(@(FITHEIGHT(15)));
        }];
    }
    
    
    [self.supporImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.supportNumLabel.mas_right).offset(FITWITH(2));
        make.top.equalTo(self.supportNumLabel.mas_top);
        make.width.equalTo(@(FITWITH(19)));
        make.height.equalTo(@(FITHEIGHT(15)));
    }];
    
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
        
    self.firstPriceLabel.hidden = YES;
    self.allPriceLabel.hidden = YES;
    self.allPriceLabel.text = @"";
    if (model.product_price != 0) {
        self.firstPriceLabel.hidden = NO;
        self.allPriceLabel.hidden = NO;
        self.allPriceLabel.attributedText = [self getPrice:model.product_price];
    }
    
    [self restLayoutUI:model.user_count];
}

- (void)getImageCircle:(UIImageView *)imageview {
    imageview.layer.cornerRadius = FITHEIGHT(20) / 2.0;
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

- (NSMutableAttributedString *)getPrice:(float)price {
    NSString *allPriceStr = [NSString stringWithFormat:@"%.2f", price];
    NSString *priceStr = [[allPriceStr componentsSeparatedByString:@"."] firstObject];
    NSString *decimalPrice = [[allPriceStr componentsSeparatedByString:@"."] lastObject];
    
    NSMutableAttributedString *replyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", allPriceStr]];
    // ----- 设置字体大小 -----
    [replyString addAttribute:NSFontAttributeName value:(Font(24)) range:NSMakeRange(0, priceStr.length)];
    [replyString addAttribute:NSFontAttributeName value:(Font(20)) range:NSMakeRange(priceStr.length + 1, decimalPrice.length)];
    return replyString;
}

@end
