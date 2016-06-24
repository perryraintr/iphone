//
//  FashionRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/16.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "FashionRecommendController.h"
#import "FashionRecommendCell.h"
#import "RecommendSceneModel.h"

@interface FashionRecommendController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray *sceneArray;

@end

@implementation FashionRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self initUI];
    [PINBaseRefreshSingleton instance].refreshRecommend = 0;
    [self recommendSceneRequestWith:PinIndicatorStyle_DefaultIndicator isDragup:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PINBaseRefreshSingleton instance].refreshRecommend == 1) {
        [PINBaseRefreshSingleton instance].refreshRecommend = 0;
        [self recommendSceneRequestWith:PinIndicatorStyle_NoIndicator isDragup:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initParams {
    self.sceneArray = [NSMutableArray array];
}

- (void)initUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, SCREEN_HEIGHT - 64 - FITHEIGHT(56) + FITHEIGHT(7)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[FashionRecommendCell class] forCellWithReuseIdentifier:@"fashionRecommendCellId"];
    [self.view addSubview:_collectionView];
    
    weakSelf(self);
    [self.collectionView addRefreshHeaderWithCompletion:^{
        [weakSelf recommendSceneRequestWith:PinIndicatorStyle_NoIndicator isDragup:NO];
    }];
}

- (void)recommendSceneRequestWith:(PinIndicatorStyle)indicatorStyle isDragup:(BOOL)isDragup {
    self.currentPage = (isDragup ? self.currentPage + 1 : 1);

    [self.httpService recommendSceneRequestWithCurrentPage:self.currentPage indicatorStyle:indicatorStyle finished:^(NSDictionary *result, NSString *message) {
        if (self.currentPage == 1) {
            [self.sceneArray removeAllObjects];
        }

        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            RecommendSceneModel *sceneModel = [RecommendSceneModel modelWithDictionary:dic];
            [self.sceneArray addObject:sceneModel];
        }
        
        [self.collectionView reloadData];
        
        if (self.collectionView.mj_footer == nil && self.sceneArray.count == REQUEST_FOOTER_SIZE) {
            weakSelf(self);
            [self.collectionView addRefreshFooterWithCompletion:^{
                [weakSelf recommendSceneRequestWith:PinIndicatorStyle_NoIndicator isDragup:YES];
            }];
        }
        [self.collectionView endRefreshing];
        [self.collectionView addFooter:XONE_Dic_Is_Valid(result) ? YES : NO];

    } failure:^(NSDictionary *result, NSString *message) {
        [self.collectionView endRefreshing];
    }];
}

#pragma mark -
#pragma mark UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FashionRecommendCell *fashionRecommendCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fashionRecommendCellId" forIndexPath:indexPath];
    [fashionRecommendCell resetFashionRecommendCell:indexPath withRecommendSceneModel:[self.sceneArray objectAtIndex:indexPath.item]];
    return fashionRecommendCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WITH, FITHEIGHT(213));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    RecommendSceneModel *sceneModel = [self.sceneArray objectAtIndex:indexPath.item];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInteger:sceneModel.tag_t2] forKey:@"tag_t2"];
    [paramDic setObject:sceneModel.tag_name forKey:@"tag_name"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_TOPGOODSLIST_VC navigationController:self.navigationController params:paramDic animated:NO];
    [NSObject event:@"SCENE001" label:@"场景类别"];
}

@end
