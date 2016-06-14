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
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChange:(NSNotification *)notification {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.text.length > 0) { } else {
        NSDictionary *dictionary = @{NSFontAttributeName: self.font, NSForegroundColorAttributeName: _placeholderColor};
        [self.placeholder drawInRect:CGRectMake(4.0f, 8.0f, self.frame.size.width, self.frame.size.height) withAttributes:dictionary];
    }
}

@end
