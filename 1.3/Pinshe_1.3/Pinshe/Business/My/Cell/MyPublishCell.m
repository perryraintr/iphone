
//
//  MyPublishCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyPublishCell.h"
#import "MyPublishModel.h"
#import "MyPublishCellView.h"

@implementation MyPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HEXCOLOR(pinColorMainBackground);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)resetMyPublishCell:(NSMutableArray *)publishArray {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    float viewWidth = (SCREEN_WITH - 30) / 2.0;
    float viewHeight = FITHEIGHT(246);
    NSArray *buttonArray = @[@(10), @(viewWidth+20)];

    for (int i = 0; i < publishArray.count; i++) {
        int row = i/2;
        int colu = i%2;
        
        UIView *cellContentView = Building_UIViewWithFrameAndSuperView(self.contentView, CGRectMake([buttonArray[colu] integerValue], row * viewHeight + (row + 1) * 10, viewWidth, viewHeight));
        cellContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellContentView];
        
        MyPublishModel *myPublishModel = [publishArray objectAtIndex:i];
        
        if (myPublishModel.type == PinMyCentralType_CentralComapre) { // 比较的发布
            
            MyPublishCellView *cellView = [[MyPublishCellView alloc] init];
            [cellView resetMyPublishVoteCellView:myPublishModel.myVoteModel];
            [cellContentView addSubview:cellView];

            UIButton *button = Building_UIButtonWithSuperView(self, self, @selector(buttonEditAction:), nil);
            button.tag = i;
            [button setImage:IMG_Name(@"myPublishEdit") forState:UIControlStateNormal];
            [cellView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cellView);
                make.top.equalTo(cellView.picImageview.mas_bottom);
                make.width.equalTo(@(FITWITH(40)));
                make.bottom.equalTo(cellView);
            }];
        } else { // 推荐或吐槽的帖子的发布
            
            MyPublishCellView *postCellView = [[MyPublishCellView alloc] init];
            [postCellView resetMyPublishPostCellView:myPublishModel.myPostModel];
            [cellContentView addSubview:postCellView];
            
            UIButton *button = Building_UIButtonWithSuperView(self, self, @selector(buttonEditAction:), nil);
            button.tag = i;
            [button setImage:IMG_Name(@"myPublishEdit") forState:UIControlStateNormal];
            [postCellView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(postCellView);
                make.top.equalTo(postCellView.picImageview.mas_bottom);
                make.width.equalTo(@(FITWITH(40)));
                make.bottom.equalTo(postCellView);
            }];
        }
    }
}

- (void)buttonEditAction:(UIButton *)button {
    if (self.myPublishEditBlock) {
        self.myPublishEditBlock(button.tag);
    }
}

- (void)editAction:(MyPublishEditBlock)block {
    self.myPublishEditBlock = block;
}

@end
