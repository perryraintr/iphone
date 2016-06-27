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

- (void)layoutNewsUI {
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(3));
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

    int index = indexPath.row % 4;
    
    self.bgview.backgroundColor = [bgColorArray objectAtIndex:index];
    self.titleLabel.textColor = [textColorArray objectAtIndex:index];
    self.descriptionLabel.textColor = [textColorArray objectAtIndex:index];
    
    self.titleLabel.text = sceneModel.tag_name;
    self.descriptionLabel.text = sceneModel.tag_description;
    self.newsLabel.text = [NSString stringWithFormat:@"+%zd New", sceneModel.tag_count];
    
    [self.top1Imageview sd_setImageWithURL:[NSURL URLWithString:sceneModel.tag_product1_image] placeholderImage:nil];
    [self.top2Imageview sd_setImageWithURL:[NSURL URLWithString:sceneModel.tag_product2_image] placeholderImage:nil];
    [self.top3Imageview sd_setImageWithURL:[NSURL URLWithString:sceneModel.tag_product3_image] placeholderImage:nil];
    
    [self layoutNewsUI];
}

@end
