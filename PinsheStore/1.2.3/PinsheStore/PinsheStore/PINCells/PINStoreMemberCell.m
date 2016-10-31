//
//  PINStoreMemberCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/29.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreMemberCell.h"
#import "PINStoreMemberMOdel.h"

@implementation PINStoreMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    
//    self.iconImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
//    self.iconImageview.layer.masksToBounds = YES;
//    self.iconImageview.layer.cornerRadius = FITHEIGHT(25);
//    
//    self.nameLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    self.telphoneLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 1);
    
    [self.telphoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];

}

//- (void)layoutUI:(BOOL)hasAvatar  {
//    if (hasAvatar) {
//        self.iconImageview.hidden = NO;
//        self.nameLabel.hidden = NO;
//        self.telphoneLabel.hidden = NO;
//        
//        [self.iconImageview mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(15);
//            make.centerY.equalTo(self.contentView);
//            make.width.height.equalTo(@(FITHEIGHT(50)));
//        }];
//        
//        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconImageview.mas_right).offset(8);
//            make.right.equalTo(self.contentView).offset(-15);
//            make.centerY.equalTo(self.contentView).offset(-FITHEIGHT(10));
//        }];
//        
//        [self.telphoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconImageview.mas_right).offset(8);
//            make.right.equalTo(self.contentView).offset(-15);
//            make.centerY.equalTo(self.contentView).offset(FITHEIGHT(10));
//        }];
//        
//    } else {
//        self.iconImageview.hidden = YES;
//        self.nameLabel.hidden = YES;
//        self.telphoneLabel.hidden = NO;
//        
//        [self.telphoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//            make.centerY.equalTo(self.contentView);
//        }];
//    }
//}

- (void)resetStoreMemberCell:(PINStoreMemberModel *)model {
   
//    if (model.member_avatar.length == 0) {
//        [self layoutUI:NO];
//    } else {
//        [self layoutUI:YES];
//    }
//    
//    [self.iconImageview sd_setImageWithURL:[NSURL URLWithString:model.member_avatar] placeholderImage:nil];
//    self.nameLabel.text = model.member_name;
    self.telphoneLabel.text = model.member_phone;
}

@end
