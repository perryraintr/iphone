//
//  PINStoreFeatureCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/8.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreFeatureCell.h"
#import "PINStoreFeatureModel.h"

@implementation PINStoreFeatureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.bgView = Building_UIViewWithSuperView(self.contentView);
    self.lineView = Building_UIViewWithSuperView(self.contentView);
    self.lineView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(1));
    }];
}


- (void)resetFeatureCell:(NSArray *)features {
    
    for (UIView *subview in self.bgView.subviews) {
        [subview removeFromSuperview];
    }
    
    float allWidth = SCREEN_WITH - 60;
    float imageWith = (SCREEN_WITH - 90) / 4.0;
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    for (int i = 0; i < features.count; i++) {
        NSArray *featureArr = features[i];
        
        for (int j = 0; j < featureArr.count; j++) {
            PINStoreFeatureModel *model = featureArr[j];
            
            UIImageView *iconImageview = Building_UIImageViewWithSuperView(self.bgView, nil);
            [iconImageview sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
            
            if (featureArr.count == 1) {
                iconImageview.frame = CGRectMake((allWidth - imageWith) / 2.0, (imageWith + 15) * i, imageWith, imageWith);

            } else if (featureArr.count == 2) {
                float interval = allWidth / 4.0 - imageWith / 2.0;
                iconImageview.frame = CGRectMake(j * (interval * 2 + imageWith) + interval, (imageWith + 15) * i, imageWith, imageWith);
                
            } else if (featureArr.count == 3) {
                float interval = allWidth / 6.0 - imageWith / 2.0;
                iconImageview.frame = CGRectMake(j * (interval * 2 + imageWith) + interval, (imageWith + 15) * i, imageWith, imageWith);
                
            } else if (featureArr.count == 4) {
                iconImageview.frame = CGRectMake(j * (15 + imageWith), (imageWith + 15) * i, imageWith, imageWith);
            }
        }
    }
    
}

@end
