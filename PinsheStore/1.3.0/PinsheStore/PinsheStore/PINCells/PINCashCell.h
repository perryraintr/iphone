//
//  PINCashCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINCashModel;

@interface PINCashCell : UITableViewCell

@property (strong, nonatomic) UILabel *ordernoLabel;

@property (strong, nonatomic) UILabel *amountLabel;

@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UILabel *creatTimeLabel;

@property (strong, nonatomic) UILabel *storeCurrentLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetCashCell:(PINCashModel *)model;

@end
