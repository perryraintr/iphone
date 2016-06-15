//
//  InfoListCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "InfoListCell.h"
#import "MessageModel.h"

@implementation InfoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.headImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.headImageview.layer.masksToBounds = YES;
    self.headImageview.layer.cornerRadius = FITWITH(35) / 2.0;
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont14), HEXCOLOR(pinColorBule), NSTextAlignmentLeft, 1);
    self.infoLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont12), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 0);
    self.timeLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont12), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 0);
    self.picImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
}

- (void)layoutUI {
    CGFloat topOffset = FITHEIGHT(10);
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FITWITH(15));
        make.top.equalTo(self.contentView).offset(topOffset);
        make.width.height.equalTo(@(FITWITH(35)));
    }];
    
    [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(topOffset);
        make.right.equalTo(self.contentView).offset(-FITWITH(15));
        make.width.height.equalTo(@(FITHEIGHT(65)));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview.mas_right).offset(FITWITH(15));
        make.top.equalTo(self.headImageview);
        make.height.equalTo(@(FITHEIGHT(16)));
        make.width.equalTo(@(SCREEN_WITH - FITWITH(155)));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(FITHEIGHT(8));
        make.width.equalTo(@(SCREEN_WITH - FITWITH(155)));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.contentView).offset(-topOffset);
        make.width.equalTo(@(FITWITH(150)));
        make.height.equalTo(@(FITHEIGHT(14)));
    }];
    
}

- (void)resetInfoListCell:(MessageModel *)messageModel {
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:messageModel.user_avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    self.nameLabel.text = messageModel.user_name;
    self.infoLabel.text = messageModel.message;
    self.timeLabel.text = messageModel.modify_time;
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:messageModel.post_image] placeholderImage:nil];
    [self layoutUI];
}

@end
