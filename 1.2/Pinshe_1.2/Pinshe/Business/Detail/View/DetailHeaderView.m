//
//  DetailHeaderView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/23.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailHeaderView.h"

@implementation DetailHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidden = YES;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.bgView = Building_UIViewWithSuperView(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    self.bgView.backgroundColor = HEXACOLOR(pinColorWhite, 0.8);
    self.headImageview = Building_UIImageViewWithSuperView(self.bgView, nil);
    self.headImageview.layer.cornerRadius = FITHEIGHT(30) / 2.0;
    self.headImageview.layer.masksToBounds = YES;
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(FITHEIGHT(10));
        make.centerY.equalTo(self.bgView);
        make.width.height.equalTo(@(FITHEIGHT(30)));
    }];
    self.nameLabel = Building_UILabelWithSuperView(self.bgView, FontNotSou(fFont14), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 0);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageview.mas_right).offset(FITWITH(7));
        make.top.bottom.equalTo(self.bgView);
    }];
    
    self.tagView = Building_UIViewWithSuperView(self.bgView);
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(FITWITH(10));
        make.right.equalTo(self.bgView).offset(-FITHEIGHT(10));
        make.top.bottom.equalTo(self.bgView);
    }];
}

- (void)resetDetailHeaderView:(NSArray *)tagArray withUserName:(NSString *)userName withUserImageUrl:(NSString *)imageUrl isShit:(BOOL)isShit  {
    self.hidden = NO;

    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    self.nameLabel.text = userName;
    
    for (UIView *view in self.tagView.subviews) {
        if (view.tag > 5000) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lastLabel = nil;
    for (int i = 0; i < tagArray.count; i++) {
        UILabel *label = Building_UILabelWithSuperView(self.tagView, FontNotSou(fFont12), isShit ? HEXCOLOR(pinColorBlack) : HEXCOLOR(pinColorPink), NSTextAlignmentCenter, 0);
        label.tag = 5000 + i;
        label.text = [tagArray objectAtIndex:i];
        
        UIImageView *imageview = Building_UIImageViewWithSuperView(self.tagView, [IMG_Name(isShit ? @"detailBlackBoard" : @"detailRedBoard") resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]);
        imageview.tag = 6000 + i;
        
        weakSelf(self);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastLabel) {
                make.right.equalTo(lastLabel.mas_left).offset(-FITWITH(28));
            } else {
                make.right.equalTo(weakSelf.tagView).offset(-FITWITH(10));
            }
            make.centerY.equalTo(weakSelf.tagView);
            make.height.equalTo(@(FITHEIGHT(20)));
        }];
        
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_left).offset(-FITHEIGHT(8));
            make.top.equalTo(label.mas_top).offset(-FITHEIGHT(5));
            make.right.equalTo(label.mas_right).offset(FITHEIGHT(8));
            make.bottom.equalTo(label.mas_bottom).offset(FITHEIGHT(5));
        }];
        
        lastLabel = label;
    }

}

@end
