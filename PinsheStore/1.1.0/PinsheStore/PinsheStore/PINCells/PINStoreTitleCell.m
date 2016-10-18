//
//  PINStoreTitleCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/29.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreTitleCell.h"

@implementation PINStoreTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);

    self.amountLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(FITHEIGHT(10));
        make.height.equalTo(@(FITHEIGHT(25)));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(FITHEIGHT(5));
        make.height.equalTo(@(FITHEIGHT(25)));
    }];
}

@end
