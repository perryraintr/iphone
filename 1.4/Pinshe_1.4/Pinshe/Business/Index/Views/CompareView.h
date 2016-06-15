//
//  CompareView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/8.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexVote;
@interface CompareView : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) IndexVote *indexvote;

- (instancetype)init;
- (void)freshData:(IndexVote *)indexVoteModel isLeft:(BOOL)isLeft;

@end
