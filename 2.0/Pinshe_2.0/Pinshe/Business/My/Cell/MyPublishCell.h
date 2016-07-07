//
//  MyPublishCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyPublishEditBlock)(NSInteger tag);

@interface MyPublishCell : UITableViewCell
@property (nonatomic, copy) MyPublishEditBlock myPublishEditBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetMyPublishCell:(NSMutableArray *)publishArray;

- (void)editAction:(MyPublishEditBlock)block;

@end
