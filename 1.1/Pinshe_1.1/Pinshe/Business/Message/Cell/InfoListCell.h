//
//  InfoListCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@interface InfoListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageview;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *picImageview;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)resetInfoListCell:(MessageModel *)messageModel;

@end
