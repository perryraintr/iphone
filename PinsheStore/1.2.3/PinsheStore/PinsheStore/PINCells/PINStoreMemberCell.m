//
//  PINStoreMemberCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/29.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreMemberCell.h"
#import "PINStoreMemberMOdel.h"

@implementation PINStoreMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {

    self.telphoneLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    [self.telphoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];

    self.delButton = Building_UIButtonWithSuperView(self.contentView, self, @selector(delButtonAction:), nil);
    [self.delButton setBackgroundImage:IMG_Name(@"del") forState:UIControlStateNormal];
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.height.equalTo(@(FITHEIGHT(20)));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)delButtonAction:(UIButton *)button {
    if (_delBlock) {
        _delBlock(button);
    }
}

- (void)delBlockAction:(DeltelphoneBlock)block {
    self.delBlock = block;
}

- (void)resetStoreMemberCell:(PINStoreMemberModel *)model {
    self.telphoneLabel.text = model.member_phone;
}

@end
