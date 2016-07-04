//
//  PINRecommendPopView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/7/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSModel;

typedef void (^PublishSceneChooseBlock)(NSMutableArray *array);

@interface PINRecommendPopView : UIView

// 选中数据源
@property (nonatomic, strong) NSMutableArray<PSModel *> *selectedArray;

- (void)publishBlock:(PublishSceneChooseBlock)block;

- (instancetype)initWithDataArray:(NSArray<PSModel *> *)dataArray;

- (void)show;

- (void)hidden;

@end
