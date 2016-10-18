//
//  PINCashCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINCashCell.h"
#import "PINCashModel.h"

@implementation PINCashCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.ordernoLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 0);
    
    self.amountLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentLeft, 0);

    self.statusLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorDarkBlack), NSTextAlignmentRight, 0);

    self.storeCurrentLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont13), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 0);
    
    self.creatTimeLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont13), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 0);
}

- (void)layoutUI:(BOOL)isPay { // 是否是（提现）
    float topOffset = FITHEIGHT(10);
    [self.ordernoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (isPay) {
            make.top.equalTo(self.contentView).offset(0);
            make.height.equalTo(@(3));
        } else {
            make.top.equalTo(self.contentView).offset(topOffset);
            make.height.equalTo(@(FITHEIGHT(25)));
        }
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ordernoLabel.mas_bottom).offset(topOffset);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(topOffset);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.storeCurrentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(topOffset);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.creatTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(topOffset);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)resetCashCell:(PINCashModel *)model {
    if (model.type == -1) {
        self.ordernoLabel.hidden = YES;
        self.ordernoLabel.text = @"";
        if (model.status == 0) {
            self.statusLabel.text = @"提取中";
        } else {
            self.statusLabel.text = @"提取成功";
        }
        self.amountLabel.text = [NSString stringWithFormat:@"-%.2f元", model.amount];
        [self layoutUI:YES];
    } else {
        self.ordernoLabel.hidden = NO;
        self.ordernoLabel.text = [NSString stringWithFormat:@"订单编号:%@", model.order_order_no];
        self.statusLabel.text = [NSString stringWithFormat:@"%@支付成功", model.member_name];
        self.amountLabel.text = [NSString stringWithFormat:@"+%.2f元", model.amount];
        [self layoutUI:NO];
    }
    self.storeCurrentLabel.text = [NSString stringWithFormat:@"余额: %.2f元", model.total];
    self.creatTimeLabel.text = [NSString stringWithFormat:@"%@", model.create_time];
}

@end
