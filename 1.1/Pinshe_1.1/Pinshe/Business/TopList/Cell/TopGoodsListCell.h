//
//  TopGoodsListCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopProductModel;
@interface TopGoodsListCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *picImageview;

@property (nonatomic, strong) UIImageView *topNumImageview;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *pinShareImageview1;

@property (nonatomic, strong) UIImageView *pinShareImageview2;

@property (nonatomic, strong) UIImageView *pinShareImageview3;

@property (nonatomic, strong) UILabel *pinShareLabel;

@property (nonatomic, strong) UIView *splitLineView;

@property (nonatomic, strong) UIImageView *supporImageview;

@property (nonatomic, strong) UILabel *supportNumLabel;

@property (nonatomic, strong) UILabel *firstPriceLabel;

@property (nonatomic, strong) UILabel *allPriceLabel;

@property (nonatomic, strong) UIImageView *detailImageView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)resetTopGoodsListCell:(TopProductModel *)model;

@end
