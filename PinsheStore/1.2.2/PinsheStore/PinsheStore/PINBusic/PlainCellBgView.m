//
//  PlainCellBgView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PlainCellBgView.h"

@implementation PlainCellBgView

+ (id)cellBgWithSelected:(BOOL)selected needFirstCellTopLine:(BOOL)needFirstCellTopLine leftOffset:(NSInteger)offset{
    PlainCellBgView *plainCellBgView = [[PlainCellBgView alloc] init];
    plainCellBgView.selected = selected;
    plainCellBgView.leftOffset = offset;
    plainCellBgView.rightOffset = 0;
    plainCellBgView.needFirstCellTopLine = needFirstCellTopLine;
    [plainCellBgView setNeedsDisplay];
    return plainCellBgView;
}

+ (id)cellBgWithSelected:(BOOL)selected needFirstCellTopLine:(BOOL)needFirstCellTopLine leftOffset:(NSInteger)offset rightOffset:(NSInteger)rightOffSet {
    PlainCellBgView *plainCellBgView = [[PlainCellBgView alloc] init];
    plainCellBgView.selected = selected;
    plainCellBgView.leftOffset = offset;
    plainCellBgView.rightOffset = rightOffSet;
    plainCellBgView.needFirstCellTopLine = needFirstCellTopLine;
    [plainCellBgView setNeedsDisplay];
    return plainCellBgView;
}

+ (id)cellBgWithSelected:(BOOL)selected needFirstCellTopLine:(BOOL)needFirstCellTopLine {
    return  [self cellBgWithSelected:selected needFirstCellTopLine:needFirstCellTopLine leftOffset:0];
}

- (void)drawRect:(CGRect)rect {
    CGColorRef _contextColor = self.selected ? HEXCOLOR(pinColorMainBackground).CGColor : HEXCOLOR(pinColorWhite).CGColor;
    CGContextRef _context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(_context);
    CGContextSetFillColorWithColor(_context, _contextColor);//设置颜色
    CGContextFillRect(_context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    CGContextStrokePath(_context);
    
    CGFloat minx = self.leftOffset, maxx = CGRectGetMaxX(rect)-self.rightOffset, miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
    
    CGContextSetStrokeColorWithColor(_context, HEXCOLOR(pinColorCellLineBackground).CGColor);
    if (self.needFirstCellTopLine) {
        CGContextBeginPath(_context);
        CGContextMoveToPoint(_context, minx, miny);
        CGContextAddLineToPoint(_context, maxx, miny);
        CGContextStrokePath(_context);
    }
    
    CGContextBeginPath(_context);
    CGContextMoveToPoint(_context, minx, maxy);
    CGContextAddLineToPoint(_context, maxx, maxy);
    CGContextStrokePath(_context);
}

@end
