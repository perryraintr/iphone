//
//  PINStoreMemberCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/29.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINStoreMemberModel;

@interface PINStoreMemberCell : UITableViewCell

//@property (nonatomic, strong) UIImageView *iconImageview;
//
//@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *telphoneLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetStoreMemberCell:(PINStoreMemberModel *)model;

@end
