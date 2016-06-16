//
//  PINShareView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PINShareView : UIView

@property (nonatomic, strong) NSString *shareContent; // 分享内容

@property (nonatomic, strong) NSString *shareImageUrl; // 分享图片地址

@property (nonatomic, strong) NSString *shareUrl; // 分享链接

@property (nonatomic, assign) BOOL showShareView; // 是否展示分享框

@property (nonatomic, strong) UIViewController *sharePresentController;

- (instancetype)init;

@end
