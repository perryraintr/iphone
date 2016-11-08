//
//  PINPaymentListCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINPaymentListCell.h"

@implementation PINPaymentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.holderLabel.font = Font(fFont16);
    self.accountLabel.font = Font(fFont16);
    self.companyLabel.font = Font(fFont16);
    
}

@end
