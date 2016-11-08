//
//  PINTextFiledCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINTextFiledCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameTextField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
