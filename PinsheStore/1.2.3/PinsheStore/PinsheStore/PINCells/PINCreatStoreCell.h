//
//  PINCreatStoreCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINCreatStoreCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIImageView *avatarImageview;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
