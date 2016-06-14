//
//  RecommendCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/14.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "RecommendCell.h"
#import "DetailRecommendModel.h"

@implementation RecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.picImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
    self.picImageview.clipsToBounds = YES;
    self.picImageview.contentMode = UIViewContentModeScaleAspectFill;
    
    self.describeView = Building_UIViewWithSuperView(self.contentView);
    self.describeView.backgroundColor = HEXCOLOR(pinColorWhite);
    
    self.titleImageview = Building_UIImageViewWithSuperView(self.describeView, IMG_Name(@"detailTitleIcon"));
    self.titleLabel = Building_UILabelWithSuperView(self.describeView, FontNotSou(fFont14), HEXCOLOR(pinColorDarkOrange), NSTextAlignmentLeft, 0);
    
    self.describeLabel = Building_UILabelWithSuperView(self.describeView, FontNotSou(fFont14), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    self.timeLabel = Building_UILabelWithSuperView(self.describeView, Font(fFont13), HEXCOLOR(pinColorGray), NSTextAlignmentLeft, 0);
}

- (void)layoutUI:(NSString *)brand description:(NSString *)description {
    [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(@(SCREEN_WITH));
    }];
    
    float leftOffset = FITWITH(26);
    float rightOffset = FITWITH(11);
    
    CGFloat brandHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(16) - 5) text:brand withLineHiehtMultipe:1.0 withLineSpacing:0 fontSize:fFont14 isSuo:NO];
    
    CGFloat descriptionHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(27) * 2) text:description withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];

    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.picImageview.mas_bottom);
        make.height.equalTo(@(brandHeight + descriptionHeight + FITHEIGHT(50) + FITHEIGHT(10)));
    }];
    
    [self.titleImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.describeView);
        make.top.equalTo(self.describeView).offset(FITHEIGHT(12));
        make.width.equalTo(@(FITWITH(5)));
        make.height.equalTo(@(FITHEIGHT(24)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageview.mas_right).offset(5);
        make.top.equalTo(self.describeView).offset(FITHEIGHT(12));
        make.width.equalTo(@(SCREEN_WITH - FITWITH(16) - 5));
        if (brandHeight > FITHEIGHT(24)) {
            make.height.equalTo(@(brandHeight));
        } else {
            make.height.equalTo(@(FITHEIGHT(24)));
        }
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(FITHEIGHT(7));
        make.left.equalTo(self.describeView).offset(leftOffset);
        make.right.equalTo(self.describeView).offset(-leftOffset);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeLabel.mas_bottom).offset(FITHEIGHT(10));
        make.right.equalTo(self.describeView).offset(-rightOffset);
        make.height.equalTo(@(FITHEIGHT(15)));
    }];
    
}

- (void)resetRecommendCell:(DetailRecommendModel *)model {
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:model.post_image] placeholderImage:nil];
    self.titleLabel.attributedText = resetLineHeightMultiple(1.0, 0, model.post_name);
    self.titleImageview.hidden = YES;
    if (model.post_name.length > 0) {
        self.titleImageview.hidden = NO;
    }
    self.describeLabel.attributedText = resetLineHeightMultiple(1.0, 5, model.post_description);
    self.timeLabel.text = model.post_modify_time;
    [self layoutUI:model.post_name description:model.post_description];
}

@end
