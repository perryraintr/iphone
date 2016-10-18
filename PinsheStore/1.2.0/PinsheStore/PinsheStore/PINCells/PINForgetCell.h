//
//  PINForgetCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CashAddBlock) (NSString *priceString);

@interface PINForgetCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *signLabel;

@property (nonatomic, strong) UITextField *priceTextFiled;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, copy) CashAddBlock cashAddBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)cashAddBlockAction:(CashAddBlock)block;


@end
