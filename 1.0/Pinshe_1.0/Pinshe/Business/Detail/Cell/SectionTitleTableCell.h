//
//  SectionTitleTableCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionTitleTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *verticalImageview;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetSectionTitleTableCell:(NSString *)titleStr;

@end
