//
//  PINProductContentCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINProductDetailModel;
@interface PINProductContentCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *titleImageview;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UILabel *firstPriceLabel;

@property (nonatomic, strong) UILabel *allPriceLabel;

@property (nonatomic, strong) UIImageView *buyImageview;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)resetPINProductContentCell:(PINProductDetailModel *)model;

@end
