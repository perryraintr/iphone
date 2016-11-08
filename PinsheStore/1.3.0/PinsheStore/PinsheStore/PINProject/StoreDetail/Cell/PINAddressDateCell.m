//
//  PINAddressDateCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINAddressDateCell.h"

@implementation PINAddressDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    
    self.topLineView = Building_UIViewWithSuperView(self.contentView);
    self.topLineView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    
    self.addressImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"detailAddress"));
    
    self.addressLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    self.dateImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"detailDate"));
    
    self.dateLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    self.phoneImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"detailPhone"));
    
    self.phoneLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
 
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(1);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@(1));
    }];
    
    [self.addressImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.topLineView.mas_bottom).offset(15);
        make.width.height.equalTo(@(17));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImageview.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.addressImageview);
    }];
    
    [self.dateImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.addressImageview.mas_bottom).offset(8);
        make.width.height.equalTo(@(17));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateImageview.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.dateImageview);
    }];
    
    [self.phoneImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(8);
        make.width.height.equalTo(@(17));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageview.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.phoneImageview);
    }];
}

@end
