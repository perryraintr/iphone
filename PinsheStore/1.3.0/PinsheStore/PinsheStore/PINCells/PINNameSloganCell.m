//
//  PINNameSloganCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINNameSloganCell.h"
#import "PINStoreModel.h"

@implementation PINNameSloganCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont20), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    self.sloganLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont20), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
    
    self.startView = Building_UIViewWithSuperView(self.contentView);
    
    self.commentLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont14), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 1);
    
    self.lineView = Building_UIViewWithSuperView(self.contentView);
    self.lineView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    
}

- (void)layoutUI:(int)starNum {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@(FITHEIGHT(25)));
    }];
    
    [self.sloganLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(FITHEIGHT(5));
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sloganLabel.mas_bottom).offset(FITHEIGHT(5));
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@(18 * starNum));
        make.height.equalTo(@(18));
    }];
    
    [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startView.mas_top).offset(2);
        make.left.equalTo(self.startView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(15);
        make.height.equalTo(@(1));
    }];
}

- (void)resetNameSloganCell:(PINStoreModel *)model {
    for (UIView *subView in self.startView.subviews) {
        [subView removeFromSuperview];
    }
    
    float starNum = floorf(model.star / model.comment);
    
    for (int i = 0; i < starNum; i++) {
        UIImageView *starImageview = Building_UIImageViewWithSuperView(self.startView, IMG_Name(@"starSel"));
        starImageview.frame = CGRectMake(i * 18, 0, 16, 16);
    }
    self.nameLabel.text = model.name;
    self.sloganLabel.text = model.slogan;
    self.commentLabel.text = [NSString stringWithFormat:@"%zd · %@", model.star, model.feature3];
    [self layoutUI:starNum];
}

@end
