//
//  PINCreatStoreCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINCreatStoreCell.h"

@implementation PINCreatStoreCell

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
    
    self.avatarImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.avatarImageview.layer.masksToBounds = YES;
    self.avatarImageview.layer.cornerRadius = FITHEIGHT(40) / 2.0;
    self.avatarImageview.hidden = YES;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(FITWITH(65)));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    
    [self.avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(FITHEIGHT(40)));
    }];
    
}

@end
