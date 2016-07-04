//
//  PINTopicView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/7/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PINTopicView;
@class PSModel;

typedef void (^ClickClosure) (PINTopicView *totalView);

@interface PINTopicView : UIView

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, strong, readonly) PSModel *model;

- (instancetype)initWithSelected:(BOOL)selected model:(PSModel *)model;

- (void)handleClickWithClosure:(ClickClosure)closure;

@end
