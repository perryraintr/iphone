//
//  DetailHeaderView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/23.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeaderView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImageview;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *tagView;

- (instancetype)init;
- (void)resetDetailHeaderView:(NSArray *)tagArray withUserName:(NSString *)userName withUserImageUrl:(NSString *)imageUrl isShit:(BOOL)isShit;

@end
