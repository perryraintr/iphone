//
//  SectionTitleTableCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "SectionTitleTableCell.h"

@implementation SectionTitleTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HEXCOLOR(pinColorMainBackground);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.verticalImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"sectionTitleIcon"));
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, FontNotSou(fFont14), HEXCOLOR(pinColorDarkOrange), NSTextAlignmentLeft, 1);
    
    [self.verticalImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(@(FITWITH(5)));
        make.height.equalTo(@(FITHEIGHT(24)));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalImageview.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)resetSectionTitleTableCell:(NSString *)titleStr {
    self.titleLabel.text = titleStr;
}

@end
