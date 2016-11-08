//
//  PINStoreModel.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreModel.h"
#import "PINStoreFeatureModel.h"

@implementation PINStoreModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeDescription" : @"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"feature1s": [PINStoreFeatureModel class],
             @"feature2s": [PINStoreFeatureModel class]};
}

- (void)setResultFeature1:(NSArray *)resultFeature1 {
    
}

- (NSArray *)resultFeature1 {
    NSMutableArray *resultFeature = [NSMutableArray array];
    if (self.feature1s.count <= 4) {
        [resultFeature addObject:self.feature1s];
    } else {
        for(int i = 0; i < 2; i++) {
            NSMutableArray *featureArr = [NSMutableArray array];
            if (i == 0) {
                for (int j = 0; j < 4; j++) {
                    PINStoreFeatureModel *model = self.feature1s[j];
                    [featureArr addObject:model];
                }
            } else {
                for (int j = 0; j < (((self.feature1s.count - 4) > 4) ? 4 : (self.feature1s.count - 4)); j++) {
                    PINStoreFeatureModel *model = self.feature1s[4 + j];
                    [featureArr addObject:model];
                }
            }
            
            [resultFeature addObject:featureArr];
        }
    }
    
    PLog(@"-----11 %@", resultFeature);
    return resultFeature;
}

- (NSArray *)resultFeature2 {
    NSMutableArray *resultFeature = [NSMutableArray array];
    if (self.feature2s.count <= 4) {
        [resultFeature addObject:self.feature2s];
    } else {
        for(int i = 0; i < 2; i++) {
            NSMutableArray *featureArr = [NSMutableArray array];
            if (i == 0) {
                for (int j = 0; j < 4; j++) {
                    PINStoreFeatureModel *model = self.feature2s[j];
                    [featureArr addObject:model];
                }
            } else {
                for (int j = 0; j < (((self.feature1s.count - 4) > 4) ? 4 : (self.feature2s.count - 4)); j++) {
                    PINStoreFeatureModel *model = self.feature2s[4 + j];
                    [featureArr addObject:model];
                }
            }
            
            [resultFeature addObject:featureArr];
        }
    }
    
    PLog(@"-----22 %@", resultFeature);
    return resultFeature;
}

@end
