//
//  PINTopicView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/7/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINTopicView.h"
#import "PSModel.h"

@interface PINTopicView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) ClickClosure closure;
@property (nonatomic, strong, readwrite) PSModel *model;

@end

@implementation PINTopicView

- (instancetype)initWithSelected:(BOOL)selected model:(PSModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        
        self.label = [[UILabel alloc] init];
        _label.text = model.name;
        _label.font = Font(fFont16);
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        
        self.imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        CGSize textSize = [model.name sizeWithFont:_label.font maxSize:CGSizeMake(SCREEN_WITH, CGFLOAT_MAX)];
//        CGFloat kWidth = 12 + textSize.width + 28;
//        CGFloat kHeight = 24;
        CGFloat kWidth = FITHEIGHT(12) + textSize.width + FITHEIGHT(28);
        CGFloat kHeight = FITHEIGHT(30);
        
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.layer.cornerRadius = kHeight / 2;
        self.layer.borderColor = HEXCOLOR(0xff6767).CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.masksToBounds = YES;
        
//        _label.left = 13;
        _label.left = FITHEIGHT(13);
        _label.width = textSize.width + 1;
        _label.height = textSize.height + 1;
        _label.centerY = self.height / 2;
        
//        _imageView.size = CGSizeMake(13, 13);
//        _imageView.right = self.width - 10;
        _imageView.size = CGSizeMake(FITHEIGHT(13), FITHEIGHT(13));
        _imageView.right = self.width - FITHEIGHT(10);
        _imageView.centerY = self.height / 2;
        
        self.selected = selected;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];    
    }
    return self;
}

- (void)handleClickWithClosure:(ClickClosure)closure {
    _closure = closure;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        _label.textColor = [UIColor whiteColor];
        _imageView.image = [UIImage imageNamed:@"mutiple.png"];
        self.backgroundColor = HEXCOLOR(0xff6767);
    } else {
        _label.textColor = HEXCOLOR(0xff6767);
        _imageView.image = [UIImage imageNamed:@"plus.png"];
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    self.selected = !self.isSelected;
    if (_closure) {
        _closure(self);
    }
}

@end
