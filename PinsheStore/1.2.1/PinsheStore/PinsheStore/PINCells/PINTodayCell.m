//
//  PINTodayCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/10/19.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINTodayCell.h"

@implementation PINTodayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    
    self.dateLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont14), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    
    self.amountLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    self.countLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);

    self.tipLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont12), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    
    self.dateLabel.text = [NSString stringFromDateShowyyyy_MM_dd:[NSDate date]];
    self.tipLabel.text = @"不包含提现信息";
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countLabel.mas_bottom).offset(18);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

@end
