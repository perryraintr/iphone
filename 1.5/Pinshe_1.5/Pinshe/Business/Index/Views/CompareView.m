//
//  CompareView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/8.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "CompareView.h"
#import "IndexVote.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation CompareView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HEXACOLOR(pinColorShell, 0.75);
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.nameLabel = Building_UILabelWithSuperView(self, Font(fFont14), HEXCOLOR(pinColorWhite), NSTextAlignmentLeft, 0);

    self.leftLabel = Building_UILabelWithSuperView(self, Font(fFont18), [UIColor clearColor], NSTextAlignmentCenter, 0);
    self.rightLabel = Building_UILabelWithSuperView(self, Font(fFont18), [UIColor clearColor],NSTextAlignmentCenter, 0);

    self.detailButton = Building_UIButtonWithSuperView(self, self, @selector(detailButtonAction:), nil);
    [self.detailButton setTitle:@"详情" forState:UIControlStateNormal];
    [self.detailButton setTitleColor:HEXCOLOR(pinColorYellow) forState:UIControlStateNormal];
    self.detailButton.titleLabel.font = Font(fFont14);
    [self.detailButton setImage:[UIImage imageNamed:@"detailIcon.png"] forState:UIControlStateNormal];
    
    [self.detailButton setTitleEdgeInsets:UIEdgeInsetsMake(30, -25, 0, 0)];
    [self.detailButton setImageEdgeInsets:UIEdgeInsetsMake(12, 21, 31, 21)];
    
    self.shareButton = Building_UIButtonWithSuperView(self, self, @selector(ShareAction), nil);
    [self.shareButton setBackgroundImage:IMG_Name(@"shareCompare") forState:UIControlStateNormal];
    if (isWXAppInstalled()) {
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-50);
            make.width.equalTo(@89);
            make.height.equalTo(@37);
        }];
    }
}

- (void)detailButtonAction:(UIButton *)button {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInteger:button.tag] forKey:@"id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIndexDetail object:nil userInfo:userInfo];
    
    [NSObject event:@"PX001" label:@"弹层点击详情"];
}

- (void)freshData:(IndexVote *)indexVoteModel isLeft:(BOOL)isLeft {
    for (CALayer *subLayer in [self.layer.sublayers copy]) {
        if ([subLayer isKindOfClass:[CAShapeLayer class]] || [subLayer isKindOfClass:[CATextLayer class]]) {
            [subLayer removeFromSuperlayer];
        }
    }
    self.indexvote = indexVoteModel;
    
    self.nameLabel.hidden = YES;
    
/// 1.2 版本不需要展示商品的名称， 下一版增加
//    if (indexVoteModel.product_a_guid > 0) {
//        self.nameLabel.hidden = NO;
//
//        if (isLeft) {
//            NSString *brand = indexVoteModel.product_a_brand.length > 0 ? [NSString stringWithFormat:@"%@\n", indexVoteModel.product_a_brand] : @"";
//            NSString *price = indexVoteModel.product_a_price > 0 ? [NSString stringWithFormat:@"\n\n￥%.f", indexVoteModel.product_a_price] : @"";
//            NSString *textName = [NSString stringWithFormat:@"%@%@%@", brand, indexVoteModel.product_a_name, price];
//            float NameHeight = [NSString getTextHeight:(self.width / 2.0 - FITWITH(15) * 2) text:textName fontSize:fFont14 isSuo:YES];
//            self.nameLabel.frame =  CGRectMake(FITWITH(15), FITHEIGHT(4), self.width / 2.0 - FITWITH(15) * 2 , NameHeight);
//            self.nameLabel.text = textName;
//        } else {
//            NSString *brand = indexVoteModel.product_b_brand.length > 0 ? [NSString stringWithFormat:@"%@\n", indexVoteModel.product_b_brand] : @"";
//            NSString *price = indexVoteModel.product_b_price > 0 ? [NSString stringWithFormat:@"\n\n￥%.f", indexVoteModel.product_b_price] : @"";
//            NSString *textName = [NSString stringWithFormat:@"%@%@%@", brand, indexVoteModel.product_b_name, price];
//            float NameHeight = [NSString getTextHeight:(self.width / 2.0 - FITWITH(15) * 2) text:textName fontSize:fFont14 isSuo:YES];
//            self.nameLabel.frame =  CGRectMake(self.width / 2.0 + FITWITH(15), FITHEIGHT(4), self.width / 2.0 - FITWITH(15) * 2 , NameHeight);
//            self.nameLabel.text = textName;
//        }
//    }
    
    float leftPercent = indexVoteModel.vote_rate_a;
    float rightPercent = indexVoteModel.vote_rate_b;
    
    CGFloat allHeight = 0.50 * self.height;
    CGFloat leftHeight = 0.0;
    CGFloat rightHeight = 0.0;
  
    if (leftPercent > rightPercent) {
        leftHeight = allHeight;
        rightHeight = self.height - allHeight * (rightPercent / leftPercent);
    } else {
        rightHeight = (rightPercent == 0 ? self.height : allHeight);
        leftHeight = (rightPercent == 0 ? self.height : self.height - allHeight * (leftPercent / rightPercent));
    }
    
    CGFloat leftCenter = SCREEN_WITH / 4.0 + 3;
    CGFloat rightCenter = SCREEN_WITH * 3 / 4.0 + 3;
    
    UIColor *leftColor = HEXCOLOR(pinColorWhite);
    UIColor *rightColor = HEXCOLOR(pinColorWhite);
    
    self.detailButton.tag = indexVoteModel.vote_guid;
    if (isLeft) {
        self.detailButton.frame = CGRectMake(leftCenter - 31, allHeight - 67 - 35, 67, 67);
        if (leftPercent >= rightPercent) {
            leftColor = HEXCOLOR(pinColorPink);
        } else {
            rightColor = HEXCOLOR(pinColorPink);
        }
    } else {
        self.detailButton.frame = CGRectMake(rightCenter - 31, allHeight - 67 - 35, 67, 67);
        if (rightPercent >= leftPercent) {
            rightColor = HEXCOLOR(pinColorPink);
        } else {
            leftColor = HEXCOLOR(pinColorPink);
        }
    }
    
    if (indexVoteModel.isAnimation) {
        [self beginAnimationWithLeftHeight:leftHeight leftPercent:leftPercent leftCenter:leftCenter leftColor:leftColor rightHeight:rightHeight rightPercent:rightPercent rightCenter:rightCenter rightColor:rightColor];
    } else {
        [self stopAnimationWithLeftHeight:leftHeight leftPercent:leftPercent leftCenter:leftCenter leftColor:leftColor rightHeight:rightHeight rightPercent:rightPercent rightCenter:rightCenter rightColor:rightColor];
    }
    
}

- (void)stopAnimationWithLeftHeight:(CGFloat)leftHeight leftPercent:(float)leftPercent leftCenter:(CGFloat)leftCenter leftColor:(UIColor *)leftColor rightHeight:(CGFloat)rightHeight rightPercent:(float)rightPercent rightCenter:(CGFloat)rightCenter rightColor:(UIColor *)rightColor {
    
    CALayer *totalLayer = [self layer];
    // 第一个百分比
    self.leftLabel.textColor = leftColor;
    self.leftLabel.text = [NSString stringWithFormat:@"%.f％", leftPercent * 100];
    self.leftLabel.frame = CGRectMake(SCREEN_WITH / 4.0 - 35, leftHeight - 25, 80, 20);

    UIBezierPath *leftPath = [self createBezierPathWithCenter:leftCenter height:leftHeight];
    CAShapeLayer *leftLayer = [self createShapeLayerWithPath:leftPath color:leftColor];
    [totalLayer addSublayer:leftLayer];

    // 第二个百分比
    self.rightLabel.textColor = rightColor;
    self.rightLabel.text = [NSString stringWithFormat:@"%.f％", rightPercent * 100];
    self.rightLabel.frame = CGRectMake(SCREEN_WITH * 3 / 4.0 - 35, rightHeight - 25, 80, 20);
    
    UIBezierPath *rightPath = [self createBezierPathWithCenter:rightCenter height:rightHeight];
    
    CAShapeLayer *rightLayer = [self createShapeLayerWithPath:rightPath color:rightColor];
    [totalLayer addSublayer:rightLayer];
 
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.detailButton.center.x, self.detailButton.center.y) radius:32 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(-90) clockwise:NO];
    
    CAShapeLayer *circle = [self createShapeLayerWithPath:circlePath color:HEXCOLOR(pinColorYellow)];
    circle.lineWidth = 5;
    circle.zPosition = 0;
    [totalLayer addSublayer:circle];
}

- (void)beginAnimationWithLeftHeight:(CGFloat)leftHeight leftPercent:(float)leftPercent leftCenter:(CGFloat)leftCenter leftColor:(UIColor *)leftColor rightHeight:(CGFloat)rightHeight rightPercent:(float)rightPercent rightCenter:(CGFloat)rightCenter rightColor:(UIColor *)rightColor {
    
    CALayer *totalLayer = [self layer];
    // 第一个百分比
    self.leftLabel.textColor = leftColor;
    self.leftLabel.text = [NSString stringWithFormat:@"%.f％", leftPercent * 100];
    self.leftLabel.frame = CGRectMake(SCREEN_WITH / 4.0 - 35, self.height - 25, 80, 20);
    
    UIBezierPath *leftPath = [self createBezierPathWithCenter:leftCenter height:leftHeight];
    CAShapeLayer *leftLayer = [self createShapeLayerWithPath:leftPath color:leftColor];
    [totalLayer addSublayer:leftLayer];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.leftLabel.frame = CGRectMake(SCREEN_WITH / 4.0 - 35, leftHeight - 25, 80, 20);
    }];
    
    //动画
    CABasicAnimation *leftLinePathAnimation = [self createAnimationWithKeyPath:@"strokeEnd" withDuration:0.5f withFromeValue:@0.f toValue:@1.0f removeOnCompletion:YES];
    leftLayer.strokeStart = 0; //动画执行百分比
    [leftLayer addAnimation:leftLinePathAnimation forKey:@"leftLinePathAnimation"];

    // 第二个百分比
    self.rightLabel.textColor = rightColor;
    self.rightLabel.text = [NSString stringWithFormat:@"%.f％", rightPercent * 100];
    self.rightLabel.frame = CGRectMake(SCREEN_WITH * 3 / 4.0 - 35, self.height - 25, 80, 20);
    
    UIBezierPath *rightPath = [self createBezierPathWithCenter:rightCenter height:rightHeight];
    
    CAShapeLayer *rightLayer = [self createShapeLayerWithPath:rightPath color:rightColor];
    [totalLayer addSublayer:rightLayer];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.rightLabel.frame = CGRectMake(SCREEN_WITH * 3 / 4.0 - 35, rightHeight - 25, 80, 20);
    }];
    
    //动画
    CABasicAnimation *rightLinePathAnimation = [self createAnimationWithKeyPath:@"strokeEnd" withDuration:0.5f withFromeValue:@0.f toValue:@1.0f removeOnCompletion:YES];
    rightLayer.strokeStart = 0; //动画执行百分比
    [rightLayer addAnimation:rightLinePathAnimation forKey:@"rightLinePathAnimation"];

    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.detailButton.center.x, self.detailButton.center.y) radius:32 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(-90.01) clockwise:YES];
    
    CAShapeLayer *circle = [self createShapeLayerWithPath:circlePath color:HEXCOLOR(pinColorYellow)];
    circle.lineWidth = 5;
    circle.zPosition = 1;
    [totalLayer addSublayer:circle];
    
    //动画
    CABasicAnimation *pathAnimation = [self createAnimationWithKeyPath:@"strokeStart" withDuration:1.0f withFromeValue:@0.f toValue:@1.0f removeOnCompletion:YES];
    pathAnimation.delegate = self;
    circle.strokeStart = 1; //动画执行百分比
    [circle addAnimation:pathAnimation forKey:@"stokeEndAn"];
}

#pragma mark -
#pragma mark CreatePath Layer
- (UIBezierPath *)createBezierPathWithCenter:(CGFloat)center height:(CGFloat)height {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(center, self.height)];
    [path addLineToPoint:CGPointMake(center, height)];
    return path;
}

- (CAShapeLayer *)createShapeLayerWithPath:(UIBezierPath *)path color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 6;
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.path = path.CGPath;
    return layer;
}

- (CABasicAnimation *)createAnimationWithKeyPath:(NSString *)keyPath withDuration:(float)duration withFromeValue:(NSNumber *)fromValue toValue:(NSNumber *)toValue  removeOnCompletion:(BOOL)removeOnCompletion {
    //动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.removedOnCompletion = removeOnCompletion;//完成后是否移除动画
    return animation;
}

- (void)animationDidStart:(CAAnimation *)anim {
    PLog(@"anim =-=-=-=-=-= %@", anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    PLog(@"floag === %zd ----- %@, -=-=-=-=-=-=- %zd", flag, anim, self.currentPage);
    self.indexvote.isAnimation = NO;
    if (flag) {
        [self scrollNextPage];
    }
}

- (void)ShareAction {
    [NSObject event:@"PX002" label:@"品选分享"];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.indexvote forKey:@"indexVote"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIndexShareResult object:nil userInfo:userInfo];
}

- (void)scrollNextPage {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationScrollToNext object:[NSNumber numberWithInteger:self.currentPage]];
}

@end
