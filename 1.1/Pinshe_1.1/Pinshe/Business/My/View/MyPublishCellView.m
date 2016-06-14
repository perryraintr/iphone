//
//  MyPublishCellView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyPublishCellView.h"
#import "MyPublishVoteModel.h"
#import "MyPublishPostModel.h"

@implementation MyPublishCellView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, (SCREEN_WITH - 30) / 2.0, FITHEIGHT(246));
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.bgView = Building_UIViewWithSuperView(self);
    self.bgView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    self.topView = Building_UIViewWithSuperView(self.bgView);
    self.topView.backgroundColor = HEXCOLOR(pinColorWhite);

    self.picImageview = Building_UIImageViewWithSuperView(self.topView, nil);
    self.picImageview.clipsToBounds = YES;
    self.picImageview.contentMode = UIViewContentModeScaleAspectFill;
    self.questionLabel = Building_UILabelWithSuperView(self.topView, Font(fFont15), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 2);
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView).offset(1);
        make.right.bottom.equalTo(self.bgView).offset(-1);
    }];
    
    [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.topView);
        make.height.equalTo(@((SCREEN_WITH - 34) / 2.0));
    }];
    
}

- (void)layoutUI {
    float offset = FITWITH(10);
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(offset);
        make.top.equalTo(self.picImageview.mas_bottom).offset(offset);
        make.right.equalTo(self.topView).offset(-(FITWITH(30)));
    }];
}

- (void)resetMyPublishVoteCellView:(MyPublishVoteModel *)myPublishVoteModel {
    self.questionLabel.text = myPublishVoteModel.vote_name;
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:myPublishVoteModel.posta_image] placeholderImage:nil];
    [self layoutUI];
}

- (void)resetMyPublishPostCellView:(MyPublishPostModel *)myPublishPostModel {
    self.questionLabel.text = myPublishPostModel.post_name;
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:myPublishPostModel.post_image] placeholderImage:nil];
    [self layoutUI];
}

@end
