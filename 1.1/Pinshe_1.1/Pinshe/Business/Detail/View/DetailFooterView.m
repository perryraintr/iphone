//
//  DetailFooterView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailFooterView.h"
#import "DetailRecommendModel.h"
#import "PINProductDetailModel.h"

@implementation DetailFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = HEXCOLOR(pinColorWhite);
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.supportNumLabel = Building_UILabelWithSuperView(self, FontNotSou(fFont14), HEXCOLOR(pinColorGray), NSTextAlignmentLeft, 0);
    self.supportImageview = Building_UIImageViewWithSuperView(self, IMG_Name(@"support"));
    self.supportButton = Building_UIButtonWithSuperView(self, self, @selector(supportButtonAction), nil);
    
    self.replyNumLabel = Building_UILabelWithSuperView(self, FontNotSou(fFont14), HEXCOLOR(pinColorGray), NSTextAlignmentLeft, 0);
    self.replyImageview = Building_UIImageViewWithSuperView(self, IMG_Name(@"productDetailReply"));
    self.replyButton = Building_UIButtonWithSuperView(self, self, @selector(replyButtonAction), nil);

    self.collectButton = Building_UIButtonWithSuperView(self, self, @selector(collectButtonAction), nil);
}

- (void)layoutUI:(BOOL)isPinXuan {
    if (!isPinXuan) {
        [self.supportNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(FITWITH(15));
            make.centerY.equalTo(self).offset(FITHEIGHT(3));
            make.height.equalTo(@16);
        }];
        
        [self.supportImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.supportNumLabel.mas_right).offset(FITWITH(5));
            make.centerY.equalTo(self);
            make.width.equalTo(@(FITWITH(28)));
            make.height.equalTo(@(FITHEIGHT(23)));
        }];

        [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(self.supportImageview.mas_right);
        }];
        
        [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.equalTo(@(FITWITH(137)));
        }];
    }
    
    [self.replyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isPinXuan) {
            make.left.equalTo(self).offset(FITWITH(15));
        } else {
            make.left.equalTo(self.supportButton.mas_right).offset(FITWITH(25));
        }
        make.centerY.equalTo(self).offset(FITHEIGHT(5));
        make.height.equalTo(@16);
    }];
    
    [self.replyImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyNumLabel.mas_right).offset(FITWITH(5));
        make.centerY.equalTo(self);
        make.width.equalTo(@(FITWITH(28)));
        make.height.equalTo(@(FITHEIGHT(23)));
    }];
    
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyNumLabel.mas_left);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.replyImageview.mas_right);
    }];
    
}

- (void)resetDetailCompareWithReply:(int)replyNum {
    self.hidden = NO;
    self.replyNumLabel.text = [NSString stringWithFormat:@"%zd", replyNum];
    [self layoutUI:YES];
}

- (void)resetPostDetailWith:(DetailRecommendModel *)model {
    self.hidden = NO;
    
    if (model.favorite_guid > 0) {
        if (model.tag_t1_id == 1) { // 推荐
            self.supportImageview.image = IMG_Name(@"supportDetailRedSel");
            self.supportNumLabel.textColor = HEXCOLOR(pinColorPink);
        } else { // 吐槽
            self.supportImageview.image = IMG_Name(@"supportDetailBlackSel");
            self.supportNumLabel.textColor = HEXCOLOR(pinColorBlack);
        }
    } else {
        self.supportImageview.image = IMG_Name(@"supportDetailGray");
        self.supportNumLabel.textColor = HEXCOLOR(pinColorGray);
    }

    [self.collectButton setBackgroundImage:model.wish_guid > 0 ? IMG_Name(@"collectIconSel") : IMG_Name(@"collectIcon") forState:UIControlStateNormal];

    self.supportNumLabel.text = [NSString stringWithFormat:@"%zd", model.post_favorite];
    self.replyNumLabel.text = [NSString stringWithFormat:@"%zd", model.post_comment];
    
    [self layoutUI:NO];
}

- (void)resetProductDetailWith:(PINProductDetailModel *)model {
    self.hidden = NO;

    self.supportImageview.image = IMG_Name(@"supportDetailRedSel");
    self.supportNumLabel.textColor = HEXCOLOR(pinColorPink);
    self.supportNumLabel.text = [NSString stringWithFormat:@"%zd", model.product_favorite];

    [self.collectButton setBackgroundImage:IMG_Name(@"PINShareExperience") forState:UIControlStateNormal];
    
    [self.supportNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FITWITH(15));
        make.centerY.equalTo(self).offset(FITHEIGHT(3));
        make.height.equalTo(@16);
    }];
    
    [self.supportImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.supportNumLabel.mas_right).offset(FITWITH(5));
        make.centerY.equalTo(self);
        make.width.equalTo(@(FITWITH(28)));
        make.height.equalTo(@(FITHEIGHT(23)));
    }];

    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@(FITWITH(137)));
    }];
}

- (void)supportButtonAction {
    if (self.delegate) {
        [self.delegate detailSupportAction];
    }
}

- (void)replyButtonAction {
    if (self.delegate) {
        [self.delegate detailReplyAction];
    }
}

- (void)collectButtonAction {
    if (self.delegate) {
        [self.delegate detailAddCollectAction];
    }
}

@end
