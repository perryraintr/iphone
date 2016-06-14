//
//  DetailCompareCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexVote;
@interface DetailCompareCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picImageviewLeft;
@property (nonatomic, strong) UIImageView *picImageviewRight;

@property (nonatomic, strong) UIView *describeView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)resetRecommendCell:(IndexVote *)detailVote;

@end
