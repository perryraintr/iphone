//
//  PublishSceneView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PublishSceneChooseBlock)(NSMutableArray *array);

@interface PublishSceneView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *sceneView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray *sceneArray;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@property (nonatomic, copy) PublishSceneChooseBlock publishBlock;

- (instancetype)initWithPinTopSceneType:(PinTopSceneType)pinTopSceneType withTag2Array:(NSArray *)tag2Array;
- (void)homeFrame;
- (void)showFrame;

- (void)publishBlock:(PublishSceneChooseBlock)block;

@end
