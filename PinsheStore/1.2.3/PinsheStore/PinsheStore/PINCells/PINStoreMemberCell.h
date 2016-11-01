//
//  PINStoreMemberCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/29.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeltelphoneBlock)(UIButton *button);

@class PINStoreMemberModel;

@interface PINStoreMemberCell : UITableViewCell

@property (nonatomic, strong) UILabel *telphoneLabel;

@property (nonatomic, strong) UIButton *delButton;

@property (nonatomic, copy) DeltelphoneBlock delBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetStoreMemberCell:(PINStoreMemberModel *)model;

- (void)delBlockAction:(DeltelphoneBlock)block;

@end
