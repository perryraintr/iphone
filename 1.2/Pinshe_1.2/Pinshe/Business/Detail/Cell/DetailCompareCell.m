//
//  DetailCompareCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailCompareCell.h"
#import "DetailVoteModel.h"

@implementation DetailCompareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.describeView = Building_UIViewWithSuperView(self.contentView);
    self.describeView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    
    self.describeLabel = Building_UILabelWithSuperView(self.describeView, FontNotSou(fFont14), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    self.timeLabel = Building_UILabelWithSuperView(self.describeView, FontNotSou(fFont13), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 0);

    self.picView = Building_UIViewWithSuperView(self.contentView);
    self.picImageviewLeft = Building_UIImageViewWithSuperView(self.picView, nil);
    self.picImageviewLeft.clipsToBounds = YES;
    self.picImageviewLeft.contentMode = UIViewContentModeScaleAspectFill;
    [self.picImageviewLeft addTapAction:@selector(leftTap) target:self];
    
    self.picImageviewLeftIcon = Building_UIImageViewWithSuperView(self.picView, IMG_Name(@"detailComparePushIcon"));
    
    self.picImageviewRight = Building_UIImageViewWithSuperView(self.picView, nil);
    self.picImageviewRight.clipsToBounds = YES;
    self.picImageviewRight.contentMode = UIViewContentModeScaleAspectFill;
    [self.picImageviewRight addTapAction:@selector(rightTap) target:self];
    self.picImageviewRightIcon = Building_UIImageViewWithSuperView(self.picView, IMG_Name(@"detailComparePushIcon"));
    
    self.resultView = Building_UIViewWithSuperView(self.contentView);
    self.resultView.backgroundColor = HEXCOLOR(pinColorWhite);
    self.leftLabel = Building_UILabelWithSuperView(self.resultView, FontWithNameNotSou(@"Arial-BoldMT", 18), HEXCOLOR(pinColorBlack), NSTextAlignmentCenter, 0);
    self.rightLabel = Building_UILabelWithSuperView(self.resultView, FontWithNameNotSou(@"Arial-BoldMT", 18), HEXCOLOR(pinColorBlack), NSTextAlignmentCenter, 0);
}

- (void)layoutUI:(NSString *)voteTitle {
    CGFloat imageWidth = SCREEN_WITH / 2.0;
    
    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@(FITHEIGHT(160)));
    }];
    
    CGFloat contentTextHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(20) * 2) text:voteTitle withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeView).offset((FITHEIGHT(160) - contentTextHeight) / 2.0 - FITHEIGHT(10));
        make.centerX.equalTo(self.describeView);
        if (contentTextHeight > 28) {
            make.width.equalTo(@(SCREEN_WITH - FITWITH(20) * 2));
        } else {
            make.height.equalTo(@(contentTextHeight));
        }
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.describeView).offset(-FITWITH(8));
        make.right.equalTo(self.describeView).offset(-FITWITH(10));
        make.height.equalTo(@(FITWITH(20)));
    }];
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.describeView.mas_bottom);
        make.height.equalTo(@(imageWidth));
    }];
    
    [self.picImageviewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.picView);
        make.width.height.equalTo(@(imageWidth));
    }];
    
    [self.picImageviewLeftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.picImageviewLeft).offset(-7);
        make.width.height.equalTo(@(FITWITH(20)));
    }];
    
    [self.picImageviewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.picView);
        make.width.height.equalTo(@(imageWidth));
    }];
    
    [self.picImageviewRightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.picImageviewRight).offset(-7);
        make.width.height.equalTo(@(FITWITH(20)));
    }];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.picView.mas_bottom);
        make.height.equalTo(@(FITHEIGHT(72)));
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.resultView);
        make.width.equalTo(@(imageWidth));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.resultView);
        make.width.equalTo(@(imageWidth));
    }];
}

- (void)resetRecommendCell:(DetailVoteModel *)detailVote {
    self.detailVote = detailVote;
    
    [self.picImageviewLeft sd_setImageWithURL:[NSURL URLWithString:detailVote.posta_image] placeholderImage:nil];
    [self.picImageviewRight sd_setImageWithURL:[NSURL URLWithString:detailVote.postb_image] placeholderImage:nil];

    self.describeLabel.attributedText = resetLineHeightMultiple(1.0, 5, detailVote.vote_name);
    self.timeLabel.text = [NSString stringWithFormat:@"发布于%@", detailVote.vote_modify_time];
    
    self.leftLabel.text = [NSString stringWithFormat:@"%.f％", detailVote.vote_rate_a * 100];
    self.rightLabel.text = [NSString stringWithFormat:@"%.f％", detailVote.vote_rate_b * 100];
    if (detailVote.vote_count_a > detailVote.vote_count_b) {
        self.leftLabel.textColor = HEXCOLOR(pinColorPink);
        self.rightLabel.textColor = HEXCOLOR(pinColorBlack);
    } else {
        self.leftLabel.textColor = HEXCOLOR(pinColorBlack);
        self.rightLabel.textColor = HEXCOLOR(pinColorPink);
    }
    
    self.picImageviewLeftIcon.hidden = YES;
    if (detailVote.producta_guid > 0) {
        self.picImageviewLeftIcon.hidden = NO;
    }
    self.picImageviewRightIcon.hidden = YES;
    if (detailVote.productb_guid > 0) {
        self.picImageviewRightIcon.hidden = NO;
    }
    [self layoutUI:detailVote.vote_name];
}

- (void)leftTap {
    if (self.detailVote.producta_guid > 0) {
        if (self.detailBlock) {
            self.detailBlock(self.detailVote.producta_guid);
        }
    }
}

- (void)rightTap {
    if (self.detailVote.productb_guid > 0) {
        if (self.detailBlock) {
            self.detailBlock(self.detailVote.productb_guid);
        }
    }
}

- (void)pushProductDetail:(DetailComparePushProductDetailBlock)block {
    self.detailBlock = block;
}

- (void)dealloc {
    self.detailBlock = nil;
}

@end
