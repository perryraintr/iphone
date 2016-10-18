//
//  PINStoreCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreCell.h"

@implementation PINStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 0);
    self.sloganLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 0);
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
         make.right.equalTo(self.contentView).offset(-15);
    }];
}

@end
