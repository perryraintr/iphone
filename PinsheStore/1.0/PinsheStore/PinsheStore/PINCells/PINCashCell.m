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
    self.ordernoLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    
    self.bgView = Building_UIViewWithSuperView(self.contentView);
    self.bgView.backgroundColor = HEXCOLOR(0xfafafa);
    
    self.amountLabel = Building_UILabelWithSuperView(self.bgView, Font(fFont16), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);

    self.statusLabel = Building_UILabelWithSuperView(self.bgView, Font(fFont16), HEXCOLOR(pinColorBlack), NSTextAlignmentRight, 0);

    self.creatTimeLabel = Building_UILabelWithSuperView(self.bgView, Font(fFont16), HEXCOLOR(pinColorBlack), NSTextAlignmentLeft, 0);
    
    self.lineView = Building_UIViewWithSuperView(self.contentView);
    self.lineView.backgroundColor = HEXCOLOR(0xe0e0e0);
    
}

- (void)layoutUI:(BOOL)isPay { // 是否是（提现）
    float topOffset = FITHEIGHT(10);
    [self.ordernoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(topOffset);
        make.width.equalTo(@(SCREEN_WITH));
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (isPay) {
            make.top.equalTo(self.contentView).offset(topOffset);
        } else {
            make.top.equalTo(self.ordernoLabel.mas_bottom).offset(FITHEIGHT(10));
        }
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(2));
    }];
    
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(topOffset);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(topOffset);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
    [self.creatTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.amountLabel.mas_bottom).offset(topOffset);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(FITHEIGHT(2)));
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
    self.creatTimeLabel.text = [NSString stringWithFormat:@"%@", model.create_time];
    
}

@end
