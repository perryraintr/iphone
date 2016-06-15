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
    self.currentPage = 1;
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
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&t1=2&page=%zd", [UserDefaultManagement instance].userId, isDragup ? (self.currentPage + 1) : 1];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:isDragup ? (self.currentPage + 1) : 1] forKey:@"currentPage"];
    
    [super pinRequestByGet:paramStr withMethodName:@"post.a" withMethodBack:@"shitPost" withUserInfo:userInfo withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

// 点赞请求接口
- (void)postSupportWith:(PostModel *)postModel {
    if (postModel.favorite_guid == 0) { // 添加赞
        postModel.favorite_guid = 1;
        postModel.post_favorite = postModel.post_favorite + 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", postModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"addfavorite.a" withMethodBack:@"addfavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
        
    } else { // 移除赞
        postModel.favorite_guid = 0;
        postModel.post_favorite = postModel.post_favorite - 1;
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

    if ([request.methodBack isEqualToString:@"shitPost"]) {
        self.currentPage = [[request.userInfo objectForKey:@"currentPage"] intValue];
        if (self.currentPage == 1) {
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
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
                [weakSelf shitPostRequestWithDragup:YES];
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
