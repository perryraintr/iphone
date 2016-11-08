//
//  PINStoreCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreCell.h"
#import "PINStoreModel.h"

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

    self.iconImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.iconImageview.layer.masksToBounds = YES;
    self.iconImageview.layer.cornerRadius = FITHEIGHT(25);
    
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    self.deleteLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorRed), NSTextAlignmentRight, 1);
    self.deleteLabel.text = @"待审核";
    
    self.chooseImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"choose"));
    self.chooseImageview.hidden = YES;
    
    [self.iconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(FITHEIGHT(50)));
    }];
    
    [self.chooseImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(FITHEIGHT(16)));
    }];
    
    [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseImageview.mas_left).offset(-10);
        make.width.equalTo(@(55));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)resetStoreListCell:(PINStoreModel *)model {
    [self.iconImageview sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.nameLabel.text = model.name;
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageview.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset((model.is_delete == 1 ? -75 : -15));
        make.centerY.equalTo(self.contentView);
    }];
    self.deleteLabel.hidden = (model.is_delete == 1 ? NO : YES);
    
    if ([PINUserDefaultManagement instance].sid == model.guid) {
        self.chooseImageview.hidden = NO;
    } else {
        self.chooseImageview.hidden = YES;
    }

}

@end
