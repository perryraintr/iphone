//
//  PINAddressDateCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINAddressDateCell : UITableViewCell

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIImageView *addressImageview;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIImageView *dateImageview;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *phoneImageview;

@property (nonatomic, strong) UILabel *phoneLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
