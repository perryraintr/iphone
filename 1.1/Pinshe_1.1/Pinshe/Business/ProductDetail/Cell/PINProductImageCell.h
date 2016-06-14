//
//  PINProductImageCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINProductImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *picImageview;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)resetPINProductImageCell:(NSString *)oneImage;

@end
