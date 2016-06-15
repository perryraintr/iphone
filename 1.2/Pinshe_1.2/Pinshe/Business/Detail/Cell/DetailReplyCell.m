//
//  DetailReplyCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailReplyCell.h"
#import "CommentModel.h"

@implementation DetailReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.nameLabel = Building_UILabelWithSuperView(self.contentView, FontNotSou(fFont14), HEXCOLOR(pinColorLightGray), NSTextAlignmentLeft, 0);
}

- (void)layoutUI {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FITWITH(26));
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-FITWITH(26));
    }];
}

- (void)resetDetailReplyCell:(CommentModel *)commentModel {
    NSString *markString = [NSString stringWithFormat:@"%@：%@", commentModel.user_name, commentModel.reply_name.length > 0 ? [NSString stringWithFormat:@"回复%@ ", commentModel.reply_name] : @""];
    
    self.nameLabel.attributedText = getAttributedString(markString, pinColorBule, commentModel.message, pinColorLightGray, fFont14, fFont14, NO);
    [self layoutUI];
}

@end
