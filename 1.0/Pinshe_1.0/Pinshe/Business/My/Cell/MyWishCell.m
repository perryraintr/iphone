//
//  MyWishCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyWishCell.h"
#import "MyWishModel.h"
#import "MyWishCellView.h"

@implementation MyWishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HEXCOLOR(pinColorMainBackground);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)resetMyWishCell:(NSMutableArray *)collectArray {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    float viewWidth = (SCREEN_WITH - 30) / 2.0;
    float viewHeight = FITHEIGHT(375);
    NSArray *buttonArray = @[@(10), @(viewWidth+20)];
 
    for (int i = 0; i < collectArray.count; i++) {
        int row = i/2;
        int colu = i%2;
        MyWishModel *myWishModel = [collectArray objectAtIndex:i];

        UIView *cellContentView = Building_UIViewWithFrameAndSuperView(self.contentView, CGRectMake([buttonArray[colu] integerValue], row * viewHeight + (row + 1) * 10, viewWidth, viewHeight));
        cellContentView.backgroundColor = [UIColor clearColor];
        cellContentView.info = myWishModel;
        [self.contentView addSubview:cellContentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [cellContentView addGestureRecognizer:tap];
        
        
        MyWishCellView *myWishCellView = [[MyWishCellView alloc] init];
        [myWishCellView resetMyWishCellView:myWishModel];
        [cellContentView addSubview:myWishCellView];
        
        UIButton *supportButton = Building_UIButtonWithSuperView(self, self, @selector(buttonSupportAction:), nil);
        supportButton.info = myWishModel;
        [myWishCellView addSubview:supportButton];
        
        [supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(myWishCellView);
            make.top.equalTo(myWishCellView.picImageview.mas_bottom);
            make.width.equalTo(@(FITWITH(40)));
            make.bottom.equalTo(myWishCellView.topView.mas_bottom);
        }];

        UIImageView *supportImageview = Building_UIImageViewWithSuperView(myWishCellView, nil);
        UILabel *supportLabel = Building_UILabelWithSuperView(myWishCellView, Font(fFont11), HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
        supportLabel.tag = 20000 + myWishModel.post_guid;
        
        [supportImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(supportButton).offset(-FITWITH(5));
            make.centerY.equalTo(supportButton).offset(-FITHEIGHT(5));
            make.width.equalTo(@(FITWITH(25)));
            make.height.equalTo(@(FITHEIGHT(20)));
        }];
        
        [supportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(supportImageview.mas_bottom).offset(FITHEIGHT(3));
            make.centerX.equalTo(supportImageview);
            make.height.equalTo(@(FITHEIGHT(15)));
        }];
        
        supportImageview.image = myWishModel.favorite_guid > 0 ? (myWishModel.type == 1 ? IMG_Name(@"supportRedSel") : IMG_Name(@"supportBlackSel")) : IMG_Name(@"supportGray");
        supportLabel.textColor = myWishModel.favorite_guid > 0 ? (myWishModel.type == 1 ?  HEXCOLOR(pinColorPink) :  HEXCOLOR(pinColorBlack)) : HEXCOLOR(pinColorTextLightGray);
        supportLabel.text = [NSString stringWithFormat:@"%zd", myWishModel.post_favorite];
    }

}

- (void)tap:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;

    if (self.myWishPushDetailBlock) {
        self.myWishPushDetailBlock((MyWishModel *)view.info);
    }
}

- (void)wishPushDetail:(MyWishPushDetailBlock)block {
    self.myWishPushDetailBlock = block;
}

- (void)buttonSupportAction:(UIButton *)button {
    PLog(@"%@", button);
    MyWishModel *mywishModel = button.info;
    if (self.myWishSupportBlock) {
        self.myWishSupportBlock(mywishModel);
    }
}

- (void)wishSupoort:(MyWishSupportBlock)block {
    self.myWishSupportBlock = block;
}

@end
