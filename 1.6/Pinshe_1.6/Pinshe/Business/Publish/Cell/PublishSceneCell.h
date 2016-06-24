//
//  PublishSceneCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/27.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishSceneCell : UITableViewCell

@property (nonatomic, strong) UIImageView *borderImageview;
@property (nonatomic, strong) UILabel *sceneLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)resetPublishSceneCell:(BOOL)isSelected withStr:(NSString *)str;

@end
