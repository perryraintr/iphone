//
//  FashionRecommendCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/27.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendSceneModel;
@interface FashionRecommendCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgview;

@property (nonatomic, strong) UIImageView *top1IconImageview;

@property (nonatomic, strong) UIImageView *top1Imageview;

@property (nonatomic, strong) UIImageView *top2IconImageview;

@property (nonatomic, strong) UIImageView *top2Imageview;

@property (nonatomic, strong) UIImageView *top3IconImageview;

@property (nonatomic, strong) UIImageView *top3Imageview;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *newsImageview;

@property (nonatomic, strong) UILabel *newsLabel;

- (void)resetFashionRecommendCell:(NSIndexPath *)indexPath withRecommendSceneModel:(RecommendSceneModel *)sceneModel;

@end
