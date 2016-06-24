//
//  GroupedCellBgView.h
//  Lvmm
//
//  Created by zhouyi on 13-4-2.
//  Copyright (c) 2013年 lvmama. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, GroupedCellStyle) {
    GroupedCellStyle_None,
    GroupedCellStyle_Top,
    GroupedCellStyle_Middle,
    GroupedCellStyle_Bottom,
    GroupedCellStyle_Single
};

@interface GroupedCellBgView : UIView {
    GroupedCellStyle _groupedCellStyle;
    BOOL _isSelected;
}

- (id)initWithFrame:(CGRect)frame withDataSourceCount:(NSUInteger)count withIndex:(NSInteger)index isSelected:(BOOL)isSelected;
+ (GroupedCellStyle)checkCellStyle:(NSUInteger)count index:(NSInteger)index;

@end
