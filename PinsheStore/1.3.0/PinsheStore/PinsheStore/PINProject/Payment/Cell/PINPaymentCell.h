//
//  PINPaymentCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINPaymentCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameTextField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
