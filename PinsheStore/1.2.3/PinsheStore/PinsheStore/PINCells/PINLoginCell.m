//
//  PINLoginCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINLoginCell.h"
#import "PINCaptchaView.h"

@implementation PINLoginCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    self.nameTextField = Building_UITextFieldWithFrameWithSuperView(self.contentView, CGRectZero, HEXCOLOR(pinColorTextDarkGray), Font(fFont16), NSTextAlignmentLeft, @"");
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTextField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.lineView = Building_UIViewWithSuperView(self.contentView);
    self.lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    
    self.pinCaptChaview = [[PINCaptchaView alloc] initWithFrame:CGRectMake(SCREEN_WITH - FITWITH(95) - 20, 10, FITWITH(95), FITHEIGHT(30))];
    self.pinCaptChaview.hidden = YES;
    [self.contentView addSubview:_pinCaptChaview];
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.backgroundColor = [UIColor clearColor];
    self.codeButton.titleLabel.font = Font(fFont15);
    [self.codeButton setTitleColor:HEXCOLOR(pinColorDarkBlack) forState:UIControlStateNormal];
    [self.codeButton setBackgroundImage:[IMG_Name(@"btnWhiteGrayBorder.png") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)] forState:UIControlStateNormal];
    [self.codeButton setBackgroundImage:[IMG_Name(@"btnWhiteGrayBorder.png") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)] forState:UIControlStateHighlighted];
    [self.codeButton setBackgroundImage:[IMG_Name(@"btnWhiteGrayBorderSel.png") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)] forState:UIControlStateDisabled];
    [self.contentView addSubview:self.codeButton];
    self.codeButton.hidden = YES;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(5);
        make.width.equalTo(@(80));
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(5);
        make.right.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-4);
        make.height.equalTo(@(1));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(15));
        make.width.equalTo(@(FITWITH(95)));
        make.height.equalTo(@(FITHEIGHT(30)));
    }];
    
}

@end
