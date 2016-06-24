//
//  PINProductImageCell.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINProductImageCell.h"
#import "XRCarouselView.h"

@implementation PINProductImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xRCarouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, SCREEN_WITH)];
        [self.xRCarouselView setPageColor:HEXCOLOR(pinColorLightGray) andCurrentPageColor:HEXCOLOR(pinColorOrange)];
        self.xRCarouselView.pagePosition = PositionBottomRight;
        [self.contentView addSubview:_xRCarouselView];
    }
    return self;
}

- (void)resetPINProductImagesCell:(NSArray *)images {
    self.xRCarouselView.imageArray = images;
}

@end
