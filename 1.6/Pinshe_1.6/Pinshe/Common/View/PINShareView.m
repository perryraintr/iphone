//
//  PINShareView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINShareView.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface PINShareView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *shareView;

@end

@implementation PINShareView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildingUI];
        self.showShareView = NO;
    }
    return self;
}

- (void)buildingUI {
    self.backgroundView = Building_UIViewWithSuperView(pinSheAppDelegate().window);
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    self.backgroundView.backgroundColor = HEXCOLOR(pinColorBlack);
    self.backgroundView.alpha = 0;
    self.backgroundView.opaque = NO;
    self.backgroundView.hidden = YES;
    [self.backgroundView addTapAction:@selector(closeShareView:) target:self];
    
    self.shareView = Building_UIViewWithSuperView(pinSheAppDelegate().window);
    self.shareView.backgroundColor = HEXCOLOR(pinColorWhite);
    self.shareView.hidden = YES;
    self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WITH, 0);
    
    // 好友
    UIButton *wxFriendButton = Building_UIButtonWithSuperView(self.shareView, self, @selector(wxFriendButtonAction:), nil);
    wxFriendButton.frame = CGRectMake(0, 0, SCREEN_WITH / 2.0, 100);
    
    // 朋友圈
    UIButton *wxGroupButton = Building_UIButtonWithSuperView(self.shareView, self, @selector(wxGroupButtonAction:), nil);
    wxGroupButton.frame = CGRectMake(SCREEN_WITH / 2.0, 0, SCREEN_WITH / 2.0, FITHEIGHT(100));
    
    UIImageView *wxFriendImageview = Building_UIImageViewWithSuperView(self.shareView, IMG_Name(@"shareWxFriend"));
    wxFriendImageview.frame = CGRectMake(SCREEN_WITH / 2.0 - 64, 18, 44, 44);
    
    UILabel *wxFriendLabel = Building_UILabelWithFrameAndSuperView(self.shareView, CGRectMake(SCREEN_WITH / 2.0 - 64, 62, 44, 20), Font(fFont14), HEXCOLOR(pinColorLightGray), NSTextAlignmentCenter, 0);
    wxFriendLabel.text = @"微信";
    
    UIImageView *wxGroupImageview = Building_UIImageViewWithSuperView(self.shareView, IMG_Name(@"shareWxGroup"));
    wxGroupImageview.frame = CGRectMake(SCREEN_WITH / 2.0 + 20, 18, 44, 44);
    
    UILabel *wxGroupLabel = Building_UILabelWithFrameAndSuperView(self.shareView, CGRectMake(SCREEN_WITH / 2.0 + 20, 62, 44, 20), Font(fFont14), HEXCOLOR(pinColorLightGray), NSTextAlignmentCenter, 0);
    wxGroupLabel.text = @"朋友圈";
    
    // 取消
    UIButton *cancleButton = Building_UIButtonWithSuperView(self.shareView, self, @selector(cancelButtonAction:), nil);
    [cancleButton setTitleColor:HEXCOLOR(pinColorBlack) forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = FontNotSou(fFont14);
    cancleButton.frame = CGRectMake(0, 100, SCREEN_WITH, FITHEIGHT(56));
    
    UIView *lineView = Building_UIViewWithSuperView(self.shareView);
    lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    lineView.frame = CGRectMake(0, 99, SCREEN_WITH, 1);
    
}
- (void)setShowShareView:(BOOL)showShareView {
    _showShareView = showShareView;
    if (_showShareView) {
        // 弹出分享弹框
        [self setPopShow];
    } else {
        // 隐藏弹框
        [self setPopHidden];
    }
}

- (void)wxFriendButtonAction:(UIButton *)button {
    PLog(@"微信");
    self.showShareView = NO;
    [self shareDetailWithTypes:@[UMShareToWechatSession]];
}

- (void)wxGroupButtonAction:(UIButton *)button {
    self.showShareView = NO;
    PLog(@"微信朋友圈");
    [self shareDetailWithTypes:@[UMShareToWechatTimeline]];
}

- (void)cancelButtonAction:(UIButton *)button {
    self.showShareView = NO;
}

- (void)closeShareView:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapPoint = [tapGesture locationInView:_backgroundView];
    if (!CGRectContainsPoint(self.shareView.frame, tapPoint)) {
        self.showShareView = NO;
    }
}

- (void)setPopHidden {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundView.alpha = 0;
                         self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WITH, 0);
                     } completion:^(BOOL finished) {
                         self.backgroundView.hidden = YES;
                         self.shareView.hidden = YES;
                     }];
}

- (void)setPopShow {
    self.backgroundView.hidden = NO;
    self.shareView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundView.alpha = 0.7;
                         self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT - FITHEIGHT(56) - 100, SCREEN_WITH, FITHEIGHT(56) + 100);
                     } completion:^(BOOL finished) {
                     }];
    
}

- (void)shareDetailWithTypes:(NSArray *)types {
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    
    UMSocialUrlResource *image = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.shareImageUrl];
    
    //分享点击链接
    [UMSocialWechatHandler setWXAppId:WeChatAppleID appSecret:WeChatSecret url:self.shareUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:types
                                                        content:self.shareContent
                                                          image:nil
                                                       location:nil
                                                    urlResource:image
                                            presentedController:self.sharePresentController
                                                     completion:^(UMSocialResponseEntity *response)
     {
         if (response.responseCode == UMSResponseCodeSuccess) {
             [self.sharePresentController chatShowHint:@"分享成功"];
         } else {
             [self.sharePresentController chatShowHint:@"分享失败"];
             [NSObject event:@"PX003" label:@"品选取消分享"];
         }
     }];
    

}


@end
