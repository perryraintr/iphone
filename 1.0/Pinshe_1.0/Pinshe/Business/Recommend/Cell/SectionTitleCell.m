//
//  SectionTitleCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/27.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "SectionTitleCell.h"

@implementation SectionTitleCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.verticalImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"sectionTitleIcon"));
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 1);
    
    [self.verticalImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(@(FITWITH(5)));
        make.height.equalTo(@(FITHEIGHT(24)));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalImageview.mas_right).offset(FITWITH(15));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)resetSectionTitleCell:(NSString *)titleStr {
    self.titleLabel.text = titleStr;
}
@end
