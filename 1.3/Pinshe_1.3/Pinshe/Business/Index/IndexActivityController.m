//
//  IndexActivityController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "IndexActivityController.h"
#import "IndexActivityCell.h"
#import "PinTabBarController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "NullCell.h"
#import "IndexVote.h"

#define RESULT_SIZE 10

@interface IndexActivityController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, PINRefreshNoMoreDataDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *voteArray;

@property (assign, nonatomic) int cellIdIndex;

@property (assign, nonatomic) BOOL isLoadFinished;

@property (assign, nonatomic) int currentPage;

@end

@implementation IndexActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PinTabBarController *pinTabBar = pinTabBarController();
    [pinTabBar messageCountRequest];
    
    [super setTitleImage];
    [super indexRightBarButtonWithImage:@"camera" selector:@selector(rightBarButtonAction) delegate:self isIndex:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationIndexDetail:) name:NotificationIndexDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationIndexShareResult:) name:NotificationIndexShareResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationScrollToNext:) name:NotificationScrollToNext object:nil];
    [MobClick beginLogPageView:@"品选首页"];
    if ([PINBaseRefreshSingleton instance].refreshCompare == 1) {
        [PINBaseRefreshSingleton instance].refreshCompare = 0;
        [self.voteArray removeAllObjects];
        [self voteRequestWithIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationIndexDetail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationScrollToNext object:nil];
    [MobClick endLogPageView:@"品选首页"];
}

- (void)initParams {
    self.voteArray = [NSMutableArray array];
    self.cellIdIndex = 0;
    self.isLoadFinished = NO;
    self.currentPage = 0;
}

- (void)initUI {
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.PINDelegate = self;
    
    [PINBaseRefreshSingleton instance].refreshCompare = 0;
    // 已经登录或者请求过一次adduser
    if ([UserDefaultManagement instance].isLogined || [UserDefaultManagement instance].haveUserId) {
        [self.voteArray removeAllObjects];
        [self voteRequestWithIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
    } else {
        [self addUserRequest];
    }

    [self.collectionView registerNib:[UINib nibWithNibName:@"NullCell" bundle:nil] forCellWithReuseIdentifier:@"nullCellId"];
}

- (void)rightBarButtonAction {
    // 需要先登录再展示
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    if ([UserDefaultManagement instance].isLogined) {
        [[ForwardContainer shareInstance] pushContainer:FORWARD_PUBLISHCOMPARE_VC navigationController:navigationController params:nil animated:NO];
    } else {
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        [paramsDic setObject:[NSNumber numberWithInteger:PinLoginType_PulishComapre] forKey:@"pinLoginType"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
    }
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Request
- (void)addUserRequest {
    [super pinRequestByGet:@"" withMethodName:@"adduser.a" withMethodBack:@"addUser" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)voteRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    if (self.voteArray.count > 0) {
        NSString *paramString = @"";
        for (IndexVote *indexVote in self.voteArray) {
            paramString = [NSString stringWithFormat:@"%@,%zd", paramString, indexVote.vote_guid];
        }
        paramString = [paramString substringFromIndex:1];
        [paramDic setObject:paramString forKey:@"vids"];
        PLog(@"vids ===== %@", paramString);
    }
    [super pinRequestByPost:paramDic withMethodName:@"vote.a" withMethodBack:@"vote" withUserInfo:nil withIndicatorStyle:indicatorStyle];
}

// 点击选中请求接口
- (void)compareRequest:(IndexVote *)indextVote isLeft:(BOOL)isLeft {
       NSString *paramStr = [NSString stringWithFormat:@"vid=%zd", indextVote.vote_guid];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:indextVote forKey:@"indexVote"];
    [userInfo setObject:[NSNumber numberWithBool:isLeft] forKey:@"isLeft"];
    
    [super pinRequestByGet:paramStr withMethodName:@"vote.a" withMethodBack:@"updateVote" withUserInfo:userInfo withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    
    [self requestModifyvote:indextVote isLeft:isLeft];
}

- (void)requestModifyvote:(IndexVote *)indextVote isLeft:(BOOL)isLeft {
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&id=%zd&%@", [UserDefaultManagement instance].userId, indextVote.vote_guid, isLeft ? @"a=1" : @"b=1"];
    [super pinRequestByGet:paramStr withMethodName:@"modifyvote.a" withMethodBack:@"modifyvote" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

#pragma mark -
#pragma mark AFNetworking
- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        [self.collectionView endRefreshing];
        return;
    }
    
    [super requestFinished:request];
    NSString *responseString = request.responseString;
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseString];
    // 未登陆是先添加用户
    if ([request.methodBack isEqualToString:@"addUser"]) {
        [UserDefaultManagement instance].userId = [[pinBaseModel.body objectForKey:@"guid"] intValue];
        [UserDefaultManagement instance].haveUserId = YES;
        [self voteRequestWithIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
        
    } else if ([request.methodBack isEqualToString:@"vote"]) {
        self.isLoadFinished = YES;
        
        for (NSDictionary *dic in [pinBaseModel.body objectForKey:@"array"]) {
            IndexVote *indexvote = [IndexVote modelWithDictionary:dic];
            [self.voteArray addObject:indexvote];
            
            NSString *stringID = [NSString stringWithFormat:@"indexActivityCellId-%zd",self.cellIdIndex];
            
            [self.collectionView registerClass:[IndexActivityCell class] forCellWithReuseIdentifier:stringID];
            self.cellIdIndex++;
        }

        [self.collectionView reloadData];

        if (self.collectionView.mj_footer == nil) {
            [self.collectionView addRefreshFooterWithCompletion:^{
                [self voteRequestWithIndicatorStyle:PinIndicatorStyle_NoIndicator];
            }];
        }
 
        [self.collectionView endRefreshing];
        [self.collectionView addFooter:XONE_Dic_Is_Valid(pinBaseModel.body) ? YES : NO];
        [self.collectionView.mj_footer resetHidden:NO];
    } else if ([request.methodBack isEqualToString:@"updateVote"]) {
        NSMutableDictionary *userInfo = request.userInfo;
        IndexVote *requestInexVote = [IndexVote modelWithDictionary:pinBaseModel.body];
        IndexVote *indexVote = [userInfo objectForKey:@"indexVote"];
        indexVote.isLeft = [[userInfo objectForKey:@"isLeft"] boolValue];
        indexVote.vote_count_a = requestInexVote.vote_count_a;
        indexVote.vote_count_b = requestInexVote.vote_count_b;
        indexVote.isOpen = YES;
        indexVote.isAnimation = YES;
        if (indexVote.isLeft) {
            indexVote.vote_rate_a = [indexVote vote_rate_a:indexVote.isLeft];
            indexVote.vote_rate_b = [indexVote vote_rate_b:indexVote.isLeft];
        } else {
            indexVote.vote_rate_b = [indexVote vote_rate_b:indexVote.isLeft];
            indexVote.vote_rate_a = [indexVote vote_rate_a:indexVote.isLeft];
        }
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.voteArray.count > 0 ? self.voteArray.count : (self.isLoadFinished ? 1 : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.voteArray.count > 0) {
        IndexActivityCell *cell = (IndexActivityCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"indexActivityCellId-%zd", indexPath.row] forIndexPath:indexPath];
        cell.currentPageLabel.text = [NSString stringWithFormat:@"%zd/%zd", indexPath.item + 1, self.voteArray.count];
        [cell resetIndexActivityCell:[self.voteArray objectAtIndex:indexPath.item] withIndexPath:indexPath];
        weakSelf(self)
        [cell shareDetail:^(IndexVote *indexVote) {
            [weakSelf shareDetail:indexVote];
        }];
        [cell compareviewBolck:^(IndexVote *indextVote, BOOL isLeft) {
            [weakSelf compareRequest:indextVote isLeft:isLeft];
        }];
        return cell;
    } else {
        NullCell *nullCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nullCellId" forIndexPath:indexPath];
        return nullCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.voteArray.count <= 1) {
        return CGSizeMake(SCREEN_WITH, SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT + FITHEIGHT(7) * 2);
    } else if (self.voteArray.count > 1) {
        return CGSizeMake(SCREEN_WITH, SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT + FITHEIGHT(7));
    }
    return CGSizeZero;
}

- (void)scrollViewHasNoMoreData {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (itemCount == 0) {
        return;
    }
    CGFloat everyPageHeight = SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT + FITHEIGHT(7);
    CGFloat lastPageOffset = (itemCount - 1) * everyPageHeight;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.collectionView setContentOffset:CGPointMake(0, lastPageOffset) animated:YES];
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _collectionView) { return; }
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (itemCount == 0) {
        return;
    }
    CGFloat everyPageHeight = SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT + FITHEIGHT(7);
    if (_collectionView.contentOffset.y > _collectionView.contentSize.height - everyPageHeight) {
        self.collectionView.mj_footer = nil;
        [self.collectionView addRefreshFooterWithCompletion:^{
            [self voteRequestWithIndicatorStyle:PinIndicatorStyle_NoIndicator];
        }];
        [self.collectionView addFooter:YES];
    }
}

- (void)toShareResultController {
    // 跳转分享结果页
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_INDEXSHARERESULT_VC navigationController:navigationController params:nil animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -
#pragma mark NotificationCenter
- (void)notificationIndexShareResult:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    IndexVote *indexVote = [dic objectForKey:@"indexVote"];
    [self shareDetail:indexVote];
}

- (void)notificationIndexDetail:(NSNotification *)notification {
    PLog(@"notificationIndexDetail %@", notification.object);
    NSDictionary *dic = notification.userInfo;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[NSNumber numberWithInt:[[dic objectForKey:@"id"] intValue]] forKey:@"id"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_DEATILCOMPARE_VC navigationController:self.navigationController params:paramsDic animated:NO];
    
}

- (void)notificationScrollToNext:(NSNotification *)notification {
    NSInteger currentPage = [notification.object integerValue];
    PLog(@" %zd", currentPage);
    if (currentPage == self.voteArray.count - 1) {
        return;
    }
    CGFloat everyPageHeight = SCREEN_HEIGHT - NAVIBAR_HEIGHT - TABBAR_HEIGHT + FITHEIGHT(7);
    CGFloat nextPageOffset = (currentPage + 1) * everyPageHeight;
    [self.collectionView setContentOffset:CGPointMake(0, nextPageOffset) animated:YES];
}

- (void)shareDetail:(IndexVote *)indexVote {
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    
    UMSocialUrlResource *image = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:indexVote.product_a_guid > 0 ? indexVote.product_a_image : indexVote.posta_image];
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@vote_share.html?vid=%zd", REQUEST_HTML_URL, indexVote.vote_guid];
    //分享点击链接
    [UMSocialWechatHandler setWXAppId:WeChatAppleID appSecret:WeChatSecret url:shareUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:indexVote.vote_name image:IMG_Name(@"tabIconSel0")
                                                       location:nil
                                                    urlResource:image
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *response)
     {
         if (response.responseCode == UMSResponseCodeSuccess) {
             [self chatShowHint:@"分享成功"];
         } else {
             [self chatShowHint:@"分享失败"];
             [NSObject event:@"PX003" label:@"品选取消分享"];
         }
     }];
}

@end
