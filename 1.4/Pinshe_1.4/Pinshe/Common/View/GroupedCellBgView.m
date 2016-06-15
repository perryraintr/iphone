//
//  GroupedCellBgView.m
//  Lvmm
//
//  Created by zhouyi on 13-4-2.
//  Copyright (c) 2013年 lvmama. All rights reserved.
//

#import "GroupedCellBgView.h"

@implementation GroupedCellBgView

+ (GroupedCellStyle)checkCellStyle:(NSUInteger)count index:(NSInteger)index {
    if (count > 0) {
        if (count == 1) {
            return GroupedCellStyle_Single;
        } else {
            if (index == 0) {
                return GroupedCellStyle_Top;
            } else if (index == count - 1) {
                return GroupedCellStyle_Bottom;
            } else {
                return GroupedCellStyle_Middle;
            }
        }
    }
    return GroupedCellStyle_None;
}

- (id)initWithFrame:(CGRect)frame withDataSourceCount:(NSUInteger)count withIndex:(NSInteger)index isSelected:(BOOL)isSelected {
    _groupedCellStyle = [GroupedCellBgView checkCellStyle:count index:index];
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WITH, CGRectGetHeight(frame))];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        _isSelected = isSelected;
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef _context = UIGraphicsGetCurrentContext();
    CGColorRef _contextColor = _isSelected ? HEXCOLOR(pinColorCellLineBackground).CGColor : HEXCOLOR(pinColorWhite).CGColor;
    CGContextBeginPath(_context);
    CGContextSetFillColorWithColor(_context, _contextColor);//设置颜色
    CGContextFillRect(_context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    CGContextStrokePath(_context);
    
    CGFloat minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect), miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
    
    switch (_groupedCellStyle) {
        case GroupedCellStyle_Top:
        {
            CGContextSetStrokeColorWithColor(_context, HEXCOLOR(pinColorCellLineBackground).CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, miny);
            CGContextAddLineToPoint(_context, maxx, miny);
            CGContextStrokePath(_context);
        }
            break;
        case GroupedCellStyle_Middle:
        {
            CGContextSetStrokeColorWithColor(_context, HEXCOLOR(pinColorCellLineBackground).CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx + 14, miny);
            CGContextAddLineToPoint(_context, maxx, miny);
            CGContextStrokePath(_context);
        }
            break;
        case GroupedCellStyle_Bottom:
        {
            CGContextSetStrokeColorWithColor(_context, HEXCOLOR(pinColorCellLineBackground).CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx + 14, miny);
            CGContextAddLineToPoint(_context, maxx, miny);
            CGContextStrokePath(_context);
            
            CGContextSetStrokeColorWithColor(_context, HEXCOLOR(pinColorCellLineBackground).CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, maxy);
            CGContextAddLineToPoint(_context, maxx, maxy);
            CGContextStrokePath(_context);
        }
            break;
        case GroupedCellStyle_Single:
        {
            minx = CGRectGetMinX(rect);
            CGContextSetStrokeColorWithColor(_context, HEXCOLOR(pinColorCellLineBackground).CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, miny);
            CGContextAddLineToPoint(_context, maxx, miny);
            CGContextStrokePath(_context);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, maxy);
            CGContextAddLineToPoint(_context, maxx, maxy);
            CGContextStrokePath(_context);
        }
            break;
        case GroupedCellStyle_None:
            break;
        default:
            break;
    }
}

@end
