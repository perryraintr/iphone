//
//  SectionTitleCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/27.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionTitleCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *verticalImageview;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)resetSectionTitleCell:(NSString *)titleStr;
@end
