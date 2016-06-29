//
//  RecommendCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/14.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailRecommendModel;
@interface RecommendCell : UITableViewCell

@property (nonatomic, strong) UIImageView *titleImageview;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIImageView *showProductImageview;

@property (nonatomic, strong) UILabel *timeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)resetRecommendCell:(DetailRecommendModel *)model;

@end
