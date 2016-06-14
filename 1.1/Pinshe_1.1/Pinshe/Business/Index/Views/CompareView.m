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
    self.nameLabel = Building_UILabelWithSuperView(self, Font(fFont18), HEXCOLOR(pinColorWhite), NSTextAlignmentCenter, 2);

    self.leftLabel = Building_UILabelWithSuperView(self, Font(fFont18), [UIColor clearColor], NSTextAlignmentCenter, 0);
    self.rightLabel = Building_UILabelWithSuperView(self, Font(fFont18), [UIColor clearColor],NSTextAlignmentCenter, 0);

    self.detailButton = Building_UIButtonWithSuperView(self, self, @selector(detailButtonAction:), nil);
    [self.detailButton setTitle:@"详情" forState:UIControlStateNormal];
    [self.detailButton setTitleColor:HEXCOLOR(pinColorYellow) forState:UIControlStateNormal];
    self.detailButton.titleLabel.font = Font(fFont14);
    [self.detailButton setImage:[UIImage imageNamed:@"detailIcon.png"] forState:UIControlStateNormal];
    
    [self.detailButton setTitleEdgeInsets:UIEdgeInsetsMake(30, -25, 0, 0)];
    [self.detailButton setImageEdgeInsets:UIEdgeInsetsMake(12, 21, 31, 21)];
    
    self.nextPageButton = Building_UIButtonWithSuperView(self, self, @selector(nextPageButtonAction), nil);
    [self.nextPageButton setBackgroundImage:IMG_Name(@"shareCompare") forState:UIControlStateNormal];
    if ([WXApi isWXAppInstalled]) {
        [self.nextPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-50);
            make.width.equalTo(@89);
            make.height.equalTo(@37);
        }];
    }
}

- (void)detailButtonAction:(UIButton *)button {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithBool:self.indexvote.vote_user_id > 0 ? YES : NO] forKey:@"isOne"];
    [userInfo setObject:[NSNumber numberWithInteger:button.tag] forKey:@"id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIndexDetail object:nil userInfo:userInfo];
    
    [NSObject event:@"PX002" label:@"弹层点击详情"];
}

- (void)freshData:(IndexVote *)indexVoteModel isLeft:(BOOL)isLeft {
    for (CALayer *subLayer in [self.layer.sublayers copy]) {
        if ([subLayer isKindOfClass:[CAShapeLayer class]] || [subLayer isKindOfClass:[CATextLayer class]]) {
            [subLayer removeFromSuperlayer];
        }
    }
    self.indexvote = indexVoteModel;
    
    self.nameLabel.hidden = YES;
    if (indexVoteModel.vote_user_id == 0) {
        self.nameLabel.hidden = NO;

        if (isLeft) {
            float NameHeight = [NSString getTextHeight:(self.width / 2.0 - FITWITH(10) * 2) text:indexVoteModel.posta_name fontSize:fFont18 isSuo:YES];
            self.nameLabel.frame =  CGRectMake(FITWITH(10), FITHEIGHT(72) / 2.0, self.width / 2.0 - FITWITH(15) * 2 , NameHeight);
            self.nameLabel.text = indexVoteModel.posta_name;
        } else {
            float NameHeight = [NSString getTextHeight:(self.width / 2.0 - FITWITH(10) * 2) text:indexVoteModel.postb_name fontSize:fFont18 isSuo:YES];
            self.nameLabel.frame =  CGRectMake(self.width / 2.0 + FITWITH(10), FITHEIGHT(72) / 2.0, self.width / 2.0 - FITWITH(15) * 2 , NameHeight);
            self.nameLabel.text = indexVoteModel.postb_name;
        }
    }
    
    float leftPercent = 0.00;
    float rightPercent = 0.00;
    if (isLeft) {
        leftPercent = [indexVoteModel vote_rate_a:isLeft];
        rightPercent = [indexVoteModel vote_rate_b:isLeft];
    } else {
        rightPercent = [indexVoteModel vote_rate_b:isLeft];
        leftPercent = [indexVoteModel vote_rate_a:isLeft];
    }
    
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
    
    if (isLeft) {
        self.detailButton.frame = CGRectMake(leftCenter - 31, allHeight - 67 - 35, 67, 67);
        self.detailButton.tag = (indexVoteModel.vote_user_id == 0 ? indexVoteModel.posta_guid : indexVoteModel.vote_guid);
        if (leftPercent >= rightPercent) {
            leftColor = HEXCOLOR(pinColorPink);
        } else {
            rightColor = HEXCOLOR(pinColorPink);
        }
    } else {
        self.detailButton.frame = CGRectMake(rightCenter - 31, allHeight - 67 - 35, 67, 67);
        self.detailButton.tag = (indexVoteModel.vote_user_id == 0 ? indexVoteModel.postb_guid : indexVoteModel.vote_guid);
        if (rightPercent >= leftPercent) {
            rightColor = HEXCOLOR(pinColorPink);
        } else {
            leftColor = HEXCOLOR(pinColorPink);
        }
    }
    
    CALayer *totalLayer = [self layer];
    // 第一个百分比
    self.leftLabel.textColor = leftColor;
    self.leftLabel.text = [NSString stringWithFormat:@"%.f％", leftPercent * 100];
    self.leftLabel.frame = CGRectMake(SCREEN_WITH / 4.0 - 35, self.height - 25, 80, 20);
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(leftCenter, self.height)];
    [leftPath addLineToPoint:CGPointMake(leftCenter, leftHeight)];
    
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    leftLayer.lineWidth = 6;
    leftLayer.strokeColor = leftColor.CGColor;
    leftLayer.fillColor = [UIColor clearColor].CGColor;
    leftLayer.lineCap = kCALineCapRound;
    leftLayer.path = leftPath.CGPath;
    [totalLayer addSublayer:leftLayer];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.leftLabel.frame = CGRectMake(SCREEN_WITH / 4.0 - 35, leftHeight - 25, 80, 20);
    }];
    
    //动画
    CABasicAnimation *leftLinePathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftLinePathAnimation.duration = 0.5f;
    leftLinePathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    leftLinePathAnimation.fromValue = @0.f;
    leftLinePathAnimation.toValue = @1.0f;
    leftLayer.strokeStart = 0; //动画执行百分比
    leftLinePathAnimation.removedOnCompletion = YES;//完成后是否移除动画
    [leftLayer addAnimation:leftLinePathAnimation forKey:@"leftLinePathAnimation"];
    
    
    // 第二个百分比
    self.rightLabel.textColor = rightColor;
    self.rightLabel.text = [NSString stringWithFormat:@"%.f％", rightPercent * 100];
    self.rightLabel.frame = CGRectMake(SCREEN_WITH * 3 / 4.0 - 35, self.height - 25, 80, 20);
    
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(rightCenter,self.height)];
    [rightPath addLineToPoint:CGPointMake(rightCenter, rightHeight)];
    
    CAShapeLayer *rightLayer = [CAShapeLayer layer];
    rightLayer.lineWidth = 6;
    rightLayer.strokeColor = rightColor.CGColor;
    rightLayer.fillColor = [UIColor clearColor].CGColor;
    rightLayer.lineCap = kCALineCapRound;
    rightLayer.path = rightPath.CGPath;
    [totalLayer addSublayer:rightLayer];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.rightLabel.frame = CGRectMake(SCREEN_WITH * 3 / 4.0 - 35, rightHeight - 25, 80, 20);
    }];
    
    //动画
    CABasicAnimation *rightLinePathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightLinePathAnimation.duration = 0.5f;
    rightLinePathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rightLinePathAnimation.fromValue = @0.f;
    rightLinePathAnimation.toValue = @1.0f;
    rightLayer.strokeStart = 0; //动画执行百分比
    rightLinePathAnimation.removedOnCompletion = YES;//完成后是否移除动画
    [rightLayer addAnimation:rightLinePathAnimation forKey:@"rightLinePathAnimation"];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.detailButton.center.x, self.detailButton.center.y) radius:32 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(-90.01) clockwise:YES];
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.lineWidth = 5;
    circle.lineCap = kCALineCapRound;
    circle.strokeColor = HEXCOLOR(pinColorYellow).CGColor;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.zPosition = 1;
    circle.path = circlePath.CGPath;
    [totalLayer addSublayer:circle];
    
    //动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    pathAnimation.duration = 1;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.f;
    pathAnimation.toValue = @1.f;
    pathAnimation.delegate = self;
    circle.strokeStart = 1; //动画执行百分比
    pathAnimation.removedOnCompletion = YES;//完成后是否移除动画
    [circle addAnimation:pathAnimation forKey:@"stokeEndAn"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    PLog(@"anim =-=-=-=-=-= %@", anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    PLog(@"floag === %zd ----- %@, -=-=-=-=-=-=- %zd", flag, anim, self.currentPage);
    if (flag) {
        [self scrollNextPage];
    }
}

- (void)nextPageButtonAction {
    [NSObject event:@"PX003" label:@"弹层点击下一组"];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.indexvote forKey:@"indexVote"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIndexShareResult object:nil userInfo:userInfo];
}

- (void)scrollNextPage {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationScrollToNext object:[NSNumber numberWithInteger:self.currentPage]];
}

@end
