//
//  DetailCompareCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailCompareCell.h"
#import "IndexVote.h"

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
    self.picImageviewLeft = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.picImageviewLeft.clipsToBounds = YES;
    self.picImageviewLeft.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageviewRight = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.picImageviewRight.clipsToBounds = YES;
    self.picImageviewRight.contentMode = UIViewContentModeScaleAspectFill;

    self.describeView = Building_UIViewWithSuperView(self.contentView);
    self.describeView.backgroundColor = HEXCOLOR(pinColorWhite);
    
    self.describeLabel = Building_UILabelWithSuperView(self.describeView, FontNotSou(fFont14), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    self.timeLabel = Building_UILabelWithSuperView(self.describeView, Font(fFont13), HEXCOLOR(pinColorGray), NSTextAlignmentLeft, 0);
}

- (void)layoutUI:(NSString *)voteTitle {
    CGFloat imageWidth = SCREEN_WITH / 2.0;
    
    [self.picImageviewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.height.equalTo(@(imageWidth));
    }];
    
    [self.picImageviewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.width.height.equalTo(@(imageWidth));
    }];
    
    CGFloat leftOffset = FITWITH(27);
    
    CGFloat contentTextHeight = [NSString getTextHeight:(SCREEN_WITH - leftOffset * 2) text:voteTitle withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];
    
    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(imageWidth);
        make.height.equalTo(@(contentTextHeight + leftOffset * 2 + FITHEIGHT(15)));
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.describeView).offset(leftOffset);
        make.right.equalTo(self.describeView).offset(-leftOffset);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.describeView).offset(-FITWITH(8));
        make.right.equalTo(self.describeView).offset(-FITWITH(10));
        make.height.equalTo(@(FITWITH(20)));
    }];
}

- (void)resetRecommendCell:(IndexVote *)detailVote {
    [self.picImageviewLeft sd_setImageWithURL:[NSURL URLWithString:detailVote.posta_image] placeholderImage:nil];
    [self.picImageviewRight sd_setImageWithURL:[NSURL URLWithString:detailVote.postb_image] placeholderImage:nil];

    self.describeLabel.attributedText = resetLineHeightMultiple(1.0, 5, detailVote.vote_name);
    self.timeLabel.text = [NSString stringWithFormat:@"发布于%@", detailVote.vote_modify_time];
    [self layoutUI:detailVote.vote_name];
}

@end
