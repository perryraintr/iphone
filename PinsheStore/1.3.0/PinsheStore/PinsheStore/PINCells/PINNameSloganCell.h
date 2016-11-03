//
//  PINNameSloganCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINStoreModel;
@interface PINNameSloganCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *sloganLabel;

@property (nonatomic, strong) UIView *startView;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIView *lineView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetNameSloganCell:(PINStoreModel *)model;

@end
