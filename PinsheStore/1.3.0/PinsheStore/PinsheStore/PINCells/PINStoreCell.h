//
//  PINStoreCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINStoreModel;
@interface PINStoreCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageview;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *deleteLabel;

@property (nonatomic, strong) UIImageView *chooseImageview;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetStoreListCell:(PINStoreModel *)model;

@end
