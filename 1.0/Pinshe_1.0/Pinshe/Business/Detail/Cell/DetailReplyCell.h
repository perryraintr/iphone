//
//  DetailReplyCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;
@interface DetailReplyCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)resetDetailReplyCell:(CommentModel *)commentModel;

@end
