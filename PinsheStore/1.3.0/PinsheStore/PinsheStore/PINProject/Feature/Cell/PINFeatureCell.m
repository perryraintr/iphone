//
//  PINFeatureCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/3.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINFeatureCell.h"

@implementation PINFeatureCell

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
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
