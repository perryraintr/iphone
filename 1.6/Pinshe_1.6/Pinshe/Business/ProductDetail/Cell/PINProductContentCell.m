//
//  PINProductContentCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINProductContentCell.h"
#import "PINProductDetailModel.h"

@implementation PINProductContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(pinColorWhite);
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.titleImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"detailTitleIcon"));
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, FontNotSou(fFont14), HEXCOLOR(pinColorDarkOrange), NSTextAlignmentLeft, 0);
    self.describeLabel = Building_UILabelWithSuperView(self.contentView, FontNotSou(fFont14), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    
    self.firstPriceLabel = Building_UILabelWithSuperView(self.contentView, FontWithName(@"Arial-BoldMT", 24), HEXCOLOR(pinColorPink), NSTextAlignmentLeft, 0);
    self.firstPriceLabel.text = @"￥";
    self.allPriceLabel = Building_UILabelWithSuperView(self.contentView, FontWithName(@"Arial-BoldMT", 24), HEXCOLOR(pinColorPink), NSTextAlignmentLeft, 0);
    self.buyImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"PINProductBuyIcon"));
}

- (void)layoutUI:(NSString *)brand description:(NSString *)description {
    float leftOffset = FITWITH(26);

    [self.titleImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(FITHEIGHT(12));
        make.width.equalTo(@(FITWITH(5)));
        make.height.equalTo(@(FITHEIGHT(24)));
    }];
    
    CGFloat brandHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(16) - 5) text:brand withLineHiehtMultipe:1.0 withLineSpacing:0 fontSize:fFont14 isSuo:NO];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageview.mas_right).offset(5);
        make.top.equalTo(self.contentView).offset(FITHEIGHT(12));
        make.width.equalTo(@(SCREEN_WITH - FITWITH(16) - 5));
        if (brandHeight > FITHEIGHT(24)) {
            make.height.equalTo(@(brandHeight));
        } else {
            make.height.equalTo(@(FITHEIGHT(24)));
        }
    }];
    
    CGFloat descriptionHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(26) * 2) text:description withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];
    
    [self.describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(FITHEIGHT(7));
        make.left.equalTo(self.contentView).offset(leftOffset);
        make.right.equalTo(self.contentView).offset(-leftOffset);
        make.height.equalTo(@(descriptionHeight));
    }];
    
    [self.firstPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(leftOffset);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(FITHEIGHT(20));
        make.width.height.equalTo(@(FITWITH(26)));
    }];
    
    [self.allPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstPriceLabel.mas_right).offset(FITWITH(2));
        make.centerY.equalTo(self.firstPriceLabel).offset(-FITHEIGHT(2));
    }];
    
    [self.buyImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-leftOffset);
        make.height.equalTo(@(FITHEIGHT(30)));
        make.width.equalTo(@(FITWITH(89)));
        make.centerY.equalTo(self.allPriceLabel);
    }];
    
}

- (void)resetPINProductContentCell:(PINProductDetailModel *)model {
    self.titleImageview.hidden = YES;
    if (model.product_name.length > 0) {
        self.titleImageview.hidden = NO;
    }
    self.titleLabel.attributedText = resetLineHeightMultiple(1.0, 0, model.product_name);
    self.describeLabel.attributedText = resetLineHeightMultiple(1.0, 5, model.product_description);

    // 价格
    self.firstPriceLabel.hidden = YES;
    self.allPriceLabel.hidden = YES;
    self.allPriceLabel.text = @"";
    if (model.product_price != 0) {
        self.firstPriceLabel.hidden = NO;
        self.allPriceLabel.hidden = NO;
        self.allPriceLabel.text = [NSString stringWithFormat:@"%.2f", model.product_price];
    }

    self.buyImageview.hidden = model.product_address.length > 0 ? NO : YES;
    
    [self layoutUI:model.product_name description:model.product_description];
}

@end
