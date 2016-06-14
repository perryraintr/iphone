//
//  FashionRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/16.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "FashionRecommendController.h"
#import "FashionRecommendCell.h"
#import "SectionTitleCell.h"
#import "RecommendPostCell.h"
#import "RecommendSceneModel.h"
#import "PostModel.h"

@interface FashionRecommendController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) RecommendSceneModel *recommendSceneModel;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray *postArray;

@end

@implementation FashionRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self initUI];
    [PINBaseRefreshSingleton instance].refreshRecommend = 0;
    [self recommendSceneRequestWith:PinIndicatorStyle_DefaultIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PINBaseRefreshSingleton instance].refreshRecommend == 1) {
        [PINBaseRefreshSingleton instance].refreshRecommend = 0;
        [self recommendSceneRequestWith:PinIndicatorStyle_NoIndicator];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initParams {
    self.postArray = [NSMutableArray array];
    self.currentPage = 1;
}

- (void)initUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, SCREEN_HEIGHT - 64 - FITHEIGHT(56) + FITHEIGHT(7)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    
    [self.collectionView registerClass:[FashionRecommendCell class] forCellWithReuseIdentifier:@"fashionRecommendCellId"];
    [self.collectionView registerClass:[SectionTitleCell class] forCellWithReuseIdentifier:@"sectionTitleCellId"];
    [self.collectionView registerClass:[RecommendPostCell class] forCellWithReuseIdentifier:@"recommendPostCellId"];
    
    [self.view addSubview:_collectionView];
    
    weakSelf(self);
    [self.collectionView addRefreshHeaderWithCompletion:^{
        [weakSelf recommendSceneRequestWith:PinIndicatorStyle_NoIndicator];
    }];
}

- (void)recommendSceneRequestWith:(PinIndicatorStyle)indicatorStyle {
    [super pinRequestByGet:@"t1=1" withMethodName:@"tag.a" withMethodBack:@"tag" withUserInfo:nil withIndicatorStyle:indicatorStyle];
}

- (void)postRequestWithDragup:(BOOL)isDragup withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&t1=1&page=%zd", [UserDefaultManagement instance].userId, isDragup ? (self.currentPage + 1) : 1];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:isDragup ? (self.currentPage + 1) : 1] forKey:@"currentPage"];
    
    [super pinRequestByGet:paramStr withMethodName:@"post.a" withMethodBack:@"post" withUserInfo:userInfo withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

// 点赞请求接口
- (void)postSupportWith:(PostModel *)postModel {
    if (postModel.favorite_guid == 0) { // 添加赞
        postModel.favorite_guid = 1;
        postModel.post_favorite += 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", postModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"addfavorite.a" withMethodBack:@"addfavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
        
    } else { // 移除赞
        postModel.favorite_guid = 0;
        postModel.post_favorite -= 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", postModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"removefavorite.a" withMethodBack:@"removefavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
    
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        [self.collectionView endRefreshing];
        return;
    }
    
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:request.responseString];
    [super requestFinished:request];
    if ([request.methodBack isEqualToString:@"tag"]) {
        self.recommendSceneModel = [RecommendSceneModel modelWithDictionary:pinBaseModel.body];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView reloadData];
        
        [self postRequestWithDragup:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
        
    } else if ([request.methodBack isEqualToString:@"post"]) {
        self.currentPage = [[request.userInfo objectForKey:@"currentPage"] intValue];
        if (self.currentPage == 1) {
            [self.postArray removeAllObjects];
        }
        
        for (NSDictionary *dic in [pinBaseModel.body objectForKey:@"array"]) {
            PostModel *postModel = [PostModel modelWithDictionary:dic];
            [self.postArray addObject:postModel];
        }
        
        [self.collectionView reloadData];
        
        if (self.collectionView.mj_footer == nil && self.postArray.count == REQUEST_FOOTER_SIZE) {
            weakSelf(self);
            [self.collectionView addRefreshFooterWithCompletion:^{
                [weakSelf postRequestWithDragup:YES withIndicatorStyle:PinIndicatorStyle_NoIndicator];
            }];
        }
        [self.collectionView endRefreshing];
        [self.collectionView addFooter:XONE_Dic_Is_Valid(pinBaseModel.body) ? YES : NO];
    } else if ([request.methodBack isEqualToString:@"addfavorite"]) {
        [self.collectionView reloadData];
    } else if ([request.methodBack isEqualToString:@"removefavorite"]) {
        [self.collectionView reloadData];
    }
}

- (void)requestFailed:(PinResponseResult *)request {
    [super requestFailed:request];
    [self.collectionView endRefreshing];
}

#pragma mark -
#pragma mark UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    } else {
        return self.postArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FashionRecommendCell *fashionRecommendCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fashionRecommendCellId" forIndexPath:indexPath];
        [fashionRecommendCell resetFashionRecommendCell:indexPath withRecommendSceneModel:self.recommendSceneModel];
        return fashionRecommendCell;
    } else if (indexPath.section == 1) {
        SectionTitleCell *sectionTitleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sectionTitleCellId" forIndexPath:indexPath];
        [sectionTitleCell resetSectionTitleCell:@"大家都在看"];
        return sectionTitleCell;
    } else {
        RecommendPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendPostCellId" forIndexPath:indexPath];
        [cell resetRecommendPostCell:[self.postArray objectAtIndex:indexPath.row]];
        [cell postSupportSelBlock:^(PostModel *postModel) {
            [self postSupportWith:postModel];
        }];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return CGSizeMake(SCREEN_WITH, FITHEIGHT(213));
        } else {
            return CGSizeMake(SCREEN_WITH, FITHEIGHT(216));
        }
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WITH, FITHEIGHT(60));
    } else {
        return CGSizeMake((SCREEN_WITH - 30) / 2.0, FITHEIGHT(375));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0 || section == 1) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:[NSNumber numberWithInteger:indexPath.row + 1] forKey:@"pinTopSceneType"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_TOPGOODSLIST_VC navigationController:self.navigationController params:paramDic animated:NO];
        
        [NSObject event:[NSString stringWithFormat:@"TJ00%zd", indexPath.row + 1] label:getTopSenceTitle(indexPath.row + 1)];
    } else if (indexPath.section == 2) {
        PostModel *postModel = [self.postArray objectAtIndex:indexPath.row];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:postModel.post_guid] forKey:@"id"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_PRODUCTDETAIL_VC navigationController:self.navigationController params:userInfo animated:NO];
    }
}

@end
