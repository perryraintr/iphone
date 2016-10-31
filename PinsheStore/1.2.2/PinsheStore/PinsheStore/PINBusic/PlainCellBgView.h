//
//  PlainCellBgView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlainCellBgView : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL needFirstCellTopLine;
@property (nonatomic, assign) NSInteger leftOffset;
@property (nonatomic, assign) NSInteger rightOffset;

+ (id)cellBgWithSelected:(BOOL)selected needFirstCellTopLine:(BOOL)needFirstCellTopLine;
+ (id)cellBgWithSelected:(BOOL)selected needFirstCellTopLine:(BOOL)needFirstCellTopLine leftOffset:(NSInteger)offset;
+ (id)cellBgWithSelected:(BOOL)selected needFirstCellTopLine:(BOOL)needFirstCellTopLine leftOffset:(NSInteger)offset rightOffset:(NSInteger)rightOffSet;
@end
