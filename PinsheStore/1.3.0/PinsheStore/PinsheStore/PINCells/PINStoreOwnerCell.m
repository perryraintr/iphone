//
//  PINStoreOwnerCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreOwnerCell.h"

@implementation PINStoreOwnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageview.layer.cornerRadius = 27;
    self.avatarImageview.layer.masksToBounds = YES;
}

@end
