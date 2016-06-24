//
//  ShitRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/16.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "ShitRecommendController.h"
#import "ShitPostCell.h"
#import "PostModel.h"

@interface ShitRecommendController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray *postArray;

@end

@implementation ShitRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self initUI];
    [PINBaseRefreshSingleton instance].refreshShit = 0;
    [self shitPostRequestWithDragup:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PINBaseRefreshSingleton instance].refreshShit == 1) {
        [PINBaseRefreshSingleton instance].refreshShit = 0;
        [self shitPostRequestWithDragup:NO];
    }
}

- (void)initParams {
    self.postArray = [NSMutableArray array];
}

- (void)initUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WITH - 30) / 2.0, FITHEIGHT(375));
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, SCREEN_HEIGHT  - 64 - FITHEIGHT(56) + FITHEIGHT(7)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[ShitPostCell class] forCellWithReuseIdentifier:@"shitPostCellId"];
    
    [self.view addSubview:_collectionView];
    
    weakSelf(self);
    [self.collectionView addRefreshHeaderWithCompletion:^{
        [weakSelf shitPostRequestWithDragup:NO];
    }];
    
}

- (void)shitPostRequestWithDragup:(BOOL)isDragup {
    self.currentPage = (isDragup ? self.currentPage + 1 : 1);
// 不需要加载动画
    
    [self.httpService listRequestWithCurrentPage:self.currentPage isPost:NO finished:^(NSDictionary *result, NSString *message) {
        
        if (self.currentPage == 1) {
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            [self.postArray removeAllObjects];
        }
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PostModel *postModel = [PostModel modelWithDictionary:dic];
            [self.postArray addObject:postModel];
        }
        
        [self.collectionView reloadData];
        
        if (self.collectionView.mj_footer == nil && self.postArray.count == REQUEST_FOOTER_SIZE) {
            weakSelf(self);
            [self.collectionView addRefreshFooterWithCompletion:^{
                [weakSelf shitPostRequestWithDragup:YES];
            }];
        }
        
        [self.collectionView endRefreshing];
        [self.collectionView addFooter:XONE_Dic_Is_Valid(result) ? YES : NO];

    } failure:^(NSDictionary *result, NSString *message) {
        [self.collectionView endRefreshing];
    }];
}

// 点赞请求接口
- (void)postSupportWith:(PostModel *)postModel {
    if (postModel.favorite_guid == 0) { // 添加赞
        postModel.favorite_guid = 1;
        postModel.post_favorite += 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd", postModel.post_guid];
        
        [self.httpService zanRequestWithMethodName:@"addfavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
            [self.collectionView reloadData];
        } failure:^(NSDictionary *result, NSString *message) {
            postModel.favorite_guid = 0;
            postModel.post_favorite -= 1;
        }];
        
    } else { // 移除赞
        postModel.favorite_guid = 0;
        postModel.post_favorite -= 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd", postModel.post_guid];
        
        [self.httpService zanRequestWithMethodName:@"removefavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
            [self.collectionView reloadData];
        } failure:^(NSDictionary *result, NSString *message) {
            postModel.favorite_guid = 1;
            postModel.post_favorite += 1;
        }];
    }
    
}

#pragma mark -
#pragma mark UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShitPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shitPostCellId" forIndexPath:indexPath];
    [cell resetShitPostCell:[self.postArray objectAtIndex:indexPath.row]];
    [cell postSupportSelBlock:^(PostModel *postModel) {
        [self postSupportWith:postModel];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    PostModel *postModel = [self.postArray objectAtIndex:indexPath.row];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:postModel.post_guid] forKey:@"id"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_DETAILSHIT_VC navigationController:self.navigationController params:userInfo animated:NO];
}

@end
