//
//  MyCentralSegmentView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyCentralSegmentView.h"

@implementation MyCentralSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    UIView *view = Building_UIViewWithSuperView(self);
    view.backgroundColor = HEXCOLOR(pinColorWhite);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    NSArray *array = @[@"收藏的", @"发布的"];
    NSArray *imageArray = @[@"myCollect", @"myPublish"];
    NSArray *imageSelArray = @[@"myCollectSel", @"myPublishSel"];

    float buttonWidth = SCREEN_WITH / 2.0;
    float buttonHeight = 44;
    float leftOffset = (buttonWidth - 95) / 2.0;
    float topOffset = (buttonHeight - 16) / 2.0;
    for (int i = 0; i < 2; i++) {
        UIButton *button = Building_UIButtonWithSuperView(self, self, @selector(buttonAction:), nil);
        button.tag = 100 + i;
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(pinColorLightGray) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(pinColorDarkYellow) forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
        }
        [button setImage:IMG_Name([imageArray objectAtIndex:i]) forState:UIControlStateNormal];
        [button setImage:IMG_Name([imageSelArray objectAtIndex:i]) forState:UIControlStateSelected];
        button.titleLabel.font = Font(fFont15);

        [button setTitleEdgeInsets:UIEdgeInsetsMake(topOffset, leftOffset + 16, topOffset, leftOffset)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(topOffset, leftOffset, topOffset, leftOffset + 50)];
        
    }
    
    UIView *lineView = Building_UIViewWithFrameAndSuperView(self, CGRectMake(0, buttonHeight - 2, SCREEN_WITH / 2.0, 4));
    lineView.backgroundColor = HEXCOLOR(pinColorDarkYellow);
    lineView.tag = 200;
}

- (void)buttonAction:(UIButton *)button {
    UIView *lineView = [self viewWithTag:200];
    lineView.frame = CGRectMake((button.tag - 100) * (SCREEN_WITH / 2.0), 40, SCREEN_WITH / 2.0, 4);
    UIButton *button1 = [self viewWithTag:100];
    UIButton *button2 = [self viewWithTag:101];
    button.selected = YES;
    if (button.tag == 100) {
        button2.selected = NO;
    } else {
        button1.selected = NO;
    }
    if (self.completionIndexBlock) {
        self.completionIndexBlock(button.tag - 100);
    }}

- (void)segmentChangeSelect:(CompletionIndexBlock)completion {
    self.completionIndexBlock = completion;
}

@end
