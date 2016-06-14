//
//  DetailFooterView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/25.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailRecommendModel;

@protocol DetailFooterViewDelegate <NSObject>
@optional
- (void)detailSupportAction;
- (void)detailReplyAction;
- (void)detailAddCollectAction;

@end

@interface DetailFooterView : UIView

@property (nonatomic, strong) UILabel *supportNumLabel;
@property (nonatomic, strong) UIImageView *supportImageview;
@property (nonatomic, strong) UIButton *supportButton;

@property (nonatomic, strong) UILabel *replyNumLabel;
@property (nonatomic, strong) UIImageView *replyImageview;
@property (nonatomic, strong) UIButton *replyButton;

@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, weak) id <DetailFooterViewDelegate>delegate;

- (instancetype)init;

- (void)resetDetailCompareWithReply:(int)replyNum;
- (void)resetPostDetailWith:(DetailRecommendModel *)model;

@end
