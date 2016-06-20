//
//  PINProductImageCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRCarouselView;
@interface PINProductImageCell : UICollectionViewCell

@property (nonatomic, strong) XRCarouselView *xRCarouselView;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)resetPINProductImagesCell:(NSArray *)images;

@end
