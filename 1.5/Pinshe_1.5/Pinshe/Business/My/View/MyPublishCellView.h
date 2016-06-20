//
//  MyPublishCellView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MyPublishVoteModel, MyPublishPostModel;
@interface MyPublishCellView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *picImageview;
@property (nonatomic, strong) UILabel *questionLabel;

- (instancetype)init;
- (void)resetMyPublishVoteCellView:(MyPublishVoteModel *)myPublishVoteModel;
- (void)resetMyPublishPostCellView:(MyPublishPostModel *)myPublishPostModel;

@end
