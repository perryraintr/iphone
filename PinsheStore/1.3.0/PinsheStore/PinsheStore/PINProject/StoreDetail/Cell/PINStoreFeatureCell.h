//
//  PINStoreFeatureCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/8.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINStoreFeatureCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetFeatureCell:(NSArray *)features;

@end
