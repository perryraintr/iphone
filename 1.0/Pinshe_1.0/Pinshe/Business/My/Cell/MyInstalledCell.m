//
//  MyInstalledCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyInstalledCell.h"

@implementation MyInstalledCell

- (void)awakeFromNib {
    self.picImageview.layer.masksToBounds = YES;
    self.picImageview.layer.cornerRadius = (FITHEIGHT(100) - 36) / 2.0;
}

@end
