//
//  PINForgetCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINForgetCell.h"

@implementation PINForgetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.nameLabel =  Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentCenter, 0);
    self.nameLabel.text = @"请输入提现金额";
    
    self.signLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont20), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 0);
    self.signLabel.text = @"￥";
    
    self.priceTextFiled = Building_UITextFieldWithFrameWithSuperView(self.contentView, CGRectZero, HEXCOLOR(pinColorTextDarkGray), Font(fFont24), NSTextAlignmentLeft, @"");
    self.priceTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.priceTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    self.priceTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.priceTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.priceTextFiled.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    self.priceTextFiled.placeholder = @"请输入提现金额";
    
    self.lineView = Building_UIViewWithSuperView(self.contentView);
    self.lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    
    self.sureButton = Building_UIButtonWithSuperView(self.contentView, self, @selector(sureAction), [UIColor clearColor]);
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = Font(fFont18);
    [self.sureButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
    self.sureButton.layer.cornerRadius = 5;
    self.sureButton.layer.masksToBounds = YES;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50);
        make.left.right.equalTo(self.contentView);
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(40);
        make.left.equalTo(self.contentView).offset(FITWITH(80));
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    
    [self.priceTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signLabel.mas_right).offset(5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(27);
        make.right.equalTo(self.contentView).offset(-FITWITH(80));
        make.height.equalTo(@(50));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signLabel.mas_bottom).offset(5);
        make.left.equalTo(self.signLabel.mas_left).offset(-10);
        make.right.equalTo(self.priceTextFiled.mas_right).offset(10);
        make.height.equalTo(@(0.5));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.width.equalTo(@(SCREEN_WITH - 40));
        make.height.equalTo(@(FITHEIGHT(50)));
    }];
}

- (void)sureAction {
    if (_cashAddBlock) {
        _cashAddBlock(self.priceTextFiled.text);
    }
}

- (void)cashAddBlockAction:(CashAddBlock)block {
    self.cashAddBlock = block;
}

@end
