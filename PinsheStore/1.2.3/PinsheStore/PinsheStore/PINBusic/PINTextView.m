//
//  PINTextView.m
//  PINTextView
//
//  Created by shiyaorong on 16/4/20.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINTextView.h"

@implementation PINTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildingDefaultParamsAndAddObserver];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingDefaultParamsAndAddObserver];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildingDefaultParamsAndAddObserver];
    }
    return self;
}

- (void)buildingDefaultParamsAndAddObserver {
    _placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    _shouldDrawPlaceholder = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChange:(NSNotification *)notification {
    [self updateShouldDrawPlaceholder];
}

- (void)setText:(NSString *)string {
    [super setText:string];
    [self updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }
    _placeholder = string;
    [self updateShouldDrawPlaceholder];
}

- (void)updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
        NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
        if (_placeholderColor) {
            [attribute setObject:_placeholderColor forKey:NSForegroundColorAttributeName];
        }
        if (self.font) {
            [attribute setObject:self.font forKey:NSFontAttributeName];
        }
        [_placeholder drawInRect:CGRectMake(4.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withAttributes:attribute];
    }
}

@end
