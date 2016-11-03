//
//  PINDescCell.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DescBlock)();

@class PINStoreModel;
@interface PINDescCell : UITableViewCell

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *descButton;

@property (nonatomic, copy) DescBlock descBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetDescCell:(PINStoreModel *)model isExpand:(BOOL)isExpand;

- (void)descBlockAction:(DescBlock)block;

@end
