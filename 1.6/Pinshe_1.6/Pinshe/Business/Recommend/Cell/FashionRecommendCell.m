//
//  FashionRecommendCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/27.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "FashionRecommendCell.h"
#import "RecommendSceneModel.h"

@implementation FashionRecommendCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(pinColorWhite);
        [self buildingUI];
        [self layoutUI];
    }
    return self;
}

- (void)buildingUI {
    self.bgview = Building_UIViewWithSuperView(self.contentView);
    
    self.top1Imageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"top1Icon"));
    [self getImageShadow:_top1Imageview];
    self.top2Imageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"top1Icon"));
    [self getImageShadow:_top2Imageview];
    self.top3Imageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"top1Icon"));
    [self getImageShadow:_top3Imageview];
    
    self.top1IconImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"top1Icon"));
    self.top2IconImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"top2Icon"));
    self.top3IconImageview = Building_UIImageViewWithSuperView(self.contentView, IMG_Name(@"top3Icon"));
    
    self.titleLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont19), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 1);
    self.descriptionLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont13), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 1);
    
    self.newsImageview = Building_UIImageViewWithSuperView(self.contentView, [IMG_Name(@"newPost") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]);
    self.newsLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont13), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 1);
}

- (void)layoutUI {
    
    float topOffset = FITWITH(28);
    float imageWith = FITWITH(100);
    [self.top1Imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(topOffset);
        make.width.height.equalTo(@(imageWith));
    }];
    
    [self.top2Imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(topOffset);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(imageWith));
    }];
    
    [self.top3Imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(topOffset);
        make.right.equalTo(self.contentView).offset(-topOffset);
        make.width.height.equalTo(@(imageWith));
    }];
    
    float topIconOffset = FITWITH(4);
    float topIconImageWidth = FITHEIGHT(20);
    [self.top1IconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top1Imageview.mas_left).offset(-topIconOffset);
        make.bottom.equalTo(self.top1Imageview.mas_bottom).offset(topIconOffset);
        make.width.height.equalTo(@(topIconImageWidth));
    }];
    
    [self.top2IconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top2Imageview.mas_left).offset(-topIconOffset);
        make.bottom.equalTo(self.top2Imageview.mas_bottom).offset(topIconOffset);
        make.width.height.equalTo(@(topIconImageWidth));
    }];
    
    [self.top3IconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top3Imageview.mas_left).offset(-topIconOffset);
        make.bottom.equalTo(self.top3Imageview.mas_bottom).offset(topIconOffset);
        make.width.height.equalTo(@(topIconImageWidth));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top1Imageview.mas_bottom).offset(FITHEIGHT(15));
        make.left.equalTo(self.top1Imageview.mas_left);
        make.right.equalTo(self.contentView);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(20));
        make.left.equalTo(self.titleLabel.mas_left);
        make.height.equalTo(@(FITHEIGHT(20)));
    }];
    
}

- (void)getImageShadow:(UIImageView *)imageview {
    [imageview.layer setShadowColor:HEXCOLOR(pinColorBlack).CGColor];
    imageview.layer.shadowOffset = CGSizeMake(6, 0);
    imageview.layer.shadowOpacity = 0.5;
    imageview.layer.shadowRadius = 5;
    imageview.layer.borderColor = HEXCOLOR(pinColorTextDarkGray).CGColor;
    imageview.layer.borderWidth = 0.5;
}

- (void)layoutNewsUI:(BOOL)lastIndexRow {
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        if (lastIndexRow) {
            make.bottom.equalTo(self.contentView);
        } else {
            make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(3));
        }
    }];
    
    [self.newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.top3Imageview.mas_right).offset(-FITWITH(11));
        make.top.equalTo(self.descriptionLabel.mas_top);
        make.bottom.equalTo(self.descriptionLabel.mas_bottom);
    }];
    
    [self.newsImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_top);
        make.bottom.equalTo(self.descriptionLabel.mas_bottom);
        make.right.equalTo(self.newsLabel.mas_right).offset(FITWITH(11));
        make.left.equalTo(self.newsLabel.mas_left).offset(-FITWITH(11));
    }];
}

- (void)resetFashionRecommendCell:(NSIndexPath *)indexPath withRecommendSceneModel:(RecommendSceneModel *)sceneModel {
    NSArray *bgColorArray = @[HEXCOLOR(0xe1d8c3), HEXCOLOR(0xe8e8e8), HEXCOLOR(0x396873), HEXCOLOR(0x645e56)];
    NSArray *textColorArray = @[HEXCOLOR(pinColorBlack), HEXCOLOR(pinColorBlack), HEXCOLOR(pinColorWhite), HEXCOLOR(pinColorWhite)];
    NSArray *titleArray = @[@"白领居家", @"办公室小确幸", @"人在旅途", @"生命在于运动"];
    NSArray *descrptionArray = @[@"从早上起床到晚上睡觉，让家里的生活更美好", @"工作再辛苦，我们也要有专属的小确幸", @"不论出差或是旅行，身体和心灵总有一个在路上", @"夏天来了，要美丽，要健康，要运动"];
    self.bgview.backgroundColor = [bgColorArray objectAtIndex:indexPath.row];
    self.titleLabel.textColor = [textColorArray objectAtIndex:indexPath.row];
    self.descriptionLabel.textColor = [textColorArray objectAtIndex:indexPath.row];
    self.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    self.descriptionLabel.text = [descrptionArray objectAtIndex:indexPath.row];
    
    NSArray *newsArray = @[@(sceneModel.tag1_count), @(sceneModel.tag2_count), @(sceneModel.tag3_count), @(sceneModel.tag4_count)];
    self.newsLabel.text = [NSString stringWithFormat:@"+%zd New", [[newsArray objectAtIndex:indexPath.row] intValue]];
    
    NSArray *top1ImageArray = @[sceneModel.tag1_product1_image?:@"", sceneModel.tag2_product1_image?:@"", sceneModel.tag3_product1_image?:@"", sceneModel.tag4_product1_image?:@""];
    NSString *top1ImageString = [top1ImageArray objectAtIndex:indexPath.row];
    [self.top1Imageview sd_setImageWithURL:[NSURL URLWithString:top1ImageString] placeholderImage:nil];
    
    NSArray *top2ImageArray = @[sceneModel.tag1_product2_image?:@"", sceneModel.tag2_product2_image?:@"", sceneModel.tag3_product2_image?:@"", sceneModel.tag4_product2_image?:@""];
    NSString *top2ImageString = [top2ImageArray objectAtIndex:indexPath.row];
    [self.top2Imageview sd_setImageWithURL:[NSURL URLWithString:top2ImageString] placeholderImage:nil];
    
    NSArray *top3ImageArray = @[sceneModel.tag1_product3_image?:@"", sceneModel.tag2_product3_image?:@"", sceneModel.tag3_product3_image?:@"", sceneModel.tag4_product3_image?:@""];
    NSString *top3ImageString = [top3ImageArray objectAtIndex:indexPath.row];
    [self.top3Imageview sd_setImageWithURL:[NSURL URLWithString:top3ImageString] placeholderImage:nil];
    
    [self layoutNewsUI:(indexPath.row == 3 ? YES : NO)];
}

@end
