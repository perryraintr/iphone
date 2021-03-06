//
//  PINLoginCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINCaptchaView;
@interface PINLoginCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) PINCaptchaView *pinCaptChaview;

@property (nonatomic, strong) UIView *lineView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
