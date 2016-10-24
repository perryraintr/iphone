//
//  PINStoreSettingCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/10/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreSettingCell.h"

@implementation PINStoreSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    self.descTextField = Building_UITextFieldWithFrameWithSuperView(self.contentView, CGRectZero, HEXCOLOR(pinColorTextDarkGray), Font(fFont16), NSTextAlignmentLeft, @"");
    self.descTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.descTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.descTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.descTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.descTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.descTextField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.descTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

@end
