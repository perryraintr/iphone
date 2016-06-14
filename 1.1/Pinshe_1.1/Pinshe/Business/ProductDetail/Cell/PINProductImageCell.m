//
//  PINProductImageCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINProductImageCell.h"

@implementation PINProductImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.picImageview = Building_UIImageViewWithSuperView(self.contentView, nil);
        self.picImageview.clipsToBounds = YES;
        self.picImageview.contentMode = UIViewContentModeScaleAspectFill;
        [self.picImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)resetPINProductImageCell:(NSString *)oneImage {
    [self.picImageview sd_setImageWithURL:[NSURL URLWithString:oneImage] placeholderImage:nil];
}

@end
