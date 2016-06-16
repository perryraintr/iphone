//
//  PublishSceneCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/27.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PublishSceneCell.h"

@implementation PublishSceneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.borderImageview = Building_UIImageViewWithSuperView(self.contentView, [IMG_Name(@"sceneGrayBorder") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]);
    [self.borderImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(FITWITH(167)));
        make.height.equalTo(@(FITHEIGHT(40)));
    }];
    
    self.sceneLabel = Building_UILabelWithSuperView(self.borderImageview, Font(fFont16), HEXCOLOR(pinColorLightGray), NSTextAlignmentCenter, 1);
    [self.sceneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.borderImageview);
    }];
}

- (void)resetPublishSceneCell:(BOOL)isSelected withStr:(NSString *)str {
    self.sceneLabel.text = str;
    self.sceneLabel.textColor = isSelected ? HEXCOLOR(pinColorLightPink) : HEXCOLOR(pinColorLightGray);
    self.borderImageview.image = [IMG_Name(isSelected ? @"sceneRedBorder" : @"sceneGrayBorder") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
}

@end
