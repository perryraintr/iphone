//
//  PINStorePushCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINStorePushCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIImageView *nameImageview;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
