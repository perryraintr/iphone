//
//  TopGoodsListController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "TopGoodsListController.h"
#import "UINavigationBar+SetColor.h"
#import "SectionTitleCell.h"
#import "RecommendPostCell.h"
#import "PostModel.h"
#import "TopGoodsListCell.h"
#import "TopProductModel.h"
#import "LoopAdModel.h"
#import "XRCarouselView.h"
#import "MoreProductCell.h"

@interface TopGoodsListController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XRCarouselViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray *productArray;

@property (nonatomic, strong) NSMutableArray *postArray;

@property (nonatomic, strong) UIImage *paramImage;

@property (nonatomic, assign) PinTopSceneType pinTopSceneType;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *loopAdArray;

@property (nonatomic, assign) BOOL expanded;

@property (nonatomic, assign) CGFloat lastOffset;

@end

@implementation TopGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initParams];
    [self initUI];
    self.title = getTopSenceTitle(self.pinTopSceneType);
    [self loopScrollAdRequestWith:PinIndicatorStyle_DefaultIndicator];
    [self topProductRequestWith:PinIndicatorStyle_NoIndicator];
    [self topListRequestWithDragup:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PINBaseRefreshSingleton instance].refreshTopGoodsList == 1) {
        [PINBaseRefreshSingleton instance].refreshTopGoodsList = 0;
        [self topListRequestWithDragup:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
}

- (void)initBaseParams {
    self.pinTopSceneType = [[self.postParams objectForKey:@"pinTopSceneType"] integerValue];
}

- (void)initParams {
    self.imageArray = [NSMutableArray array];
    self.loopAdArray = [NSMutableArray array];
    self.productArray = [NSMutableArray array];
    self.postArray = [NSMutableArray array];
    self.currentPage = 1;
    self.expanded = NO;
    self.lastOffset = 0;
}

- (void)initUI {
    [super indexRightBarButtonWithImage:@"camera" selector:@selector(rightButtonAction:) delegate:self isIndex:NO];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WITH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"loopScrollCellId"];
    [self.collectionView registerClass:[SectionTitleCell class] forCellWithReuseIdentifier:@"sectionTitleTop10CellId"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MoreProductCell" bundle:nil] forCellWithReuseIdentifier:@"moreProductCellId"];
    [self.collectionView registerClass:[TopGoodsListCell class] forCellWithReuseIdentifier:@"top10ListCellId"];
    [self.collectionView registerClass:[SectionTitleCell class] forCellWithReuseIdentifier:@"sectionTitleCellId"];
    [self.collectionView registerClass:[RecommendPostCell class] forCellWithReuseIdentifier:@"recommendPostCellId"];

    [self.view addSubview:_collectionView];
    
    weakSelf(self);
    [self.collectionView addRefreshHeaderWithCompletion:^{
        [weakSelf topProductRequestWith:PinIndicatorStyle_NoIndicator];
        [weakSelf topListRequestWithDragup:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }];
}

- (void)loopScrollAdRequestWith:(PinIndicatorStyle)indicatorStyle {
    NSString *paramString = [NSString stringWithFormat:@"t1=1&t2=%zd", self.pinTopSceneType];
    [super pinRequestByGet:paramString withMethodName:@"ad.a" withMethodBack:@"advertisement" withUserInfo:nil withIndicatorStyle:indicatorStyle];
}

- (void)topProductRequestWith:(PinIndicatorStyle)indicatorStyle {
    NSString *paramString = [NSString stringWithFormat:@"t1=1&t2=%zd", self.pinTopSceneType];
    [super pinRequestByGet:paramString withMethodName:@"product.a" withMethodBack:@"topProduct" withUserInfo:nil withIndicatorStyle:indicatorStyle];
}

- (void)topListRequestWithDragup:(BOOL)isDragup withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    NSString *paramString = [NSString stringWithFormat:@"uid=%zd&t1=1&t2=%zd&page=%zd", [UserDefaultManagement instance].userId, self.pinTopSceneType, isDragup ? (self.currentPage + 1) : 1];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:isDragup ? (self.currentPage + 1) : 1] forKey:@"currentPage"];

    [super pinRequestByGet:paramString withMethodName:@"post.a" withMethodBack:@"topListPost" withUserInfo:userInfo withIndicatorStyle:indicatorStyle];
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
    [super requestFinished:request];
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:request.responseString];
    if ([request.methodBack isEqualToString:@"advertisement"]) {
        self.collectionView.backgroundColor = HEXCOLOR(pinColorMainBackground);
        [self.imageArray removeAllObjects];
        [self.loopAdArray removeAllObjects];
        
        for (NSDictionary *dic in [pinBaseModel.body objectForKey:@"array"]) {
            LoopAdModel *loopAdModel = [LoopAdModel modelWithDictionary:dic];
            [self.loopAdArray addObject:loopAdModel];
            [self.imageArray addObject:loopAdModel.image];
        }
        
        [self.collectionView reloadData];
        [self.collectionView endRefreshing];
        
    } else if ([request.methodBack isEqualToString:@"topProduct"]) {
        
        [self.productArray removeAllObjects];
        
        for (NSDictionary *dic in [pinBaseModel.body objectForKey:@"array"]) {
            TopProductModel *topProductModel = [TopProductModel modelWithDictionary:dic];
            [self.productArray addObject:topProductModel];
        }
        
        [self.collectionView reloadData];
        [self.collectionView endRefreshing];
        
    } else if ([request.methodBack isEqualToString:@"topListPost"]) {
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
                [weakSelf topListRequestWithDragup:YES withIndicatorStyle:PinIndicatorStyle_NoIndicator];
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
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.imageArray.count > 0 ? 1 : 0;
    } else if (section == 1) {
        return self.productArray.count > 0 ? 1 : 0;
    } else if (section == 2) {
        if (self.productArray.count > 3) {
            if (self.expanded) {
                return self.productArray.count + 1;
            } else {
                return 4;
            }
        } else {
            return self.productArray.count;
        }
    } else if (section == 3) {
        return self.postArray.count > 0 ? 1 : 0;
    } else {
        return self.postArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 滚动图
        UICollectionViewCell *loopScrollCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loopScrollCellId" forIndexPath:indexPath];
        for (UIView *view in loopScrollCell.contentView.subviews) {
                [view removeFromSuperview];
        }
        XRCarouselView *xRCarouseView = [XRCarouselView carouselViewWithImageArray:self.imageArray describeArray:nil];
        xRCarouseView.delegate = self;
        xRCarouseView.time = 2;
        [xRCarouseView setPageColor:HEXCOLOR(pinColorLightGray) andCurrentPageColor:HEXCOLOR(pinColorOrange)];
        xRCarouseView.pagePosition = PositionBottomRight;
        [loopScrollCell.contentView addSubview:xRCarouseView];
        [xRCarouseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(loopScrollCell.contentView);
        }];
        return loopScrollCell;
        
    } else if (indexPath.section == 1) {
        SectionTitleCell *sectionTitleTop10Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sectionTitleTop10CellId" forIndexPath:indexPath];
        NSString *titleName = [NSString stringWithFormat:@"%@ TOP10 商品", getTopSenceTitle(self.pinTopSceneType)];
        [sectionTitleTop10Cell resetSectionTitleCell:titleName];
        return sectionTitleTop10Cell;
        
    } else if (indexPath.section == 2) { // Top10 列表
        
        if (self.productArray.count > 3) {
            if (self.expanded) {
                if (indexPath.row == self.productArray.count) {
                    MoreProductCell *moreProductCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreProductCellId" forIndexPath:indexPath];
                    moreProductCell.moreLabel.text = @"收起";
                    return moreProductCell;
                } else {
                    TopGoodsListCell *top10ListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"top10ListCellId" forIndexPath:indexPath];
                    [top10ListCell resetTopGoodsListCell:[self.productArray objectAtIndex:indexPath.row]];
                    top10ListCell.topNumImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"topGoods%zd.png", indexPath.row + 1]];
                    return top10ListCell;
                }
            } else {
                if (indexPath.row == 3) {
                    MoreProductCell *moreProductCell3 = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreProductCellId" forIndexPath:indexPath];
                    moreProductCell3.moreLabel.text = @"查看更多";
                    return moreProductCell3;
                } else {
                    TopGoodsListCell *top10ListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"top10ListCellId" forIndexPath:indexPath];
                    [top10ListCell resetTopGoodsListCell:[self.productArray objectAtIndex:indexPath.row]];
                    top10ListCell.topNumImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"topGoods%zd.png", indexPath.row + 1]];
                    return top10ListCell;
                }
            }
            
        } else {
            TopGoodsListCell *top10ListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"top10ListCellId" forIndexPath:indexPath];
            [top10ListCell resetTopGoodsListCell:[self.productArray objectAtIndex:indexPath.row]];
            top10ListCell.topNumImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"topGoods%zd.png", indexPath.row + 1]];
            return top10ListCell;
        }
    
    } else if (indexPath.section == 3) {
        SectionTitleCell *sectionTitleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sectionTitleCellId" forIndexPath:indexPath];
        [sectionTitleCell resetSectionTitleCell:@"大家都在看"];
        return sectionTitleCell;

    }
    
    RecommendPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendPostCellId" forIndexPath:indexPath];
    [cell resetRecommendPostCell:[self.postArray objectAtIndex:indexPath.row]];
    [cell postSupportSelBlock:^(PostModel *postModel) {
        [self postSupportWith:postModel];
    }];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        float scale = 3/1.0;
        float width = SCREEN_WITH - 7 * 2;
        return CGSizeMake(width, width/scale);
    } else if (indexPath.section == 1 || indexPath.section == 3) {
        return CGSizeMake(SCREEN_WITH, FITHEIGHT(60));
    } else if (indexPath.section == 2) {
        if (self.productArray.count > 3) {
            if (self.expanded) { // 展开
                if (indexPath.row == self.productArray.count) {
                    return CGSizeMake(SCREEN_WITH, FITHEIGHT(44));
                }
                return CGSizeMake(SCREEN_WITH, FITHEIGHT(130));
            } else {
                if (indexPath.row == 3) {
                    return CGSizeMake(SCREEN_WITH, FITHEIGHT(44));
                }
                return CGSizeMake(SCREEN_WITH, FITHEIGHT(130));
            }
        } else {
            return CGSizeMake(SCREEN_WITH, FITHEIGHT(130));
        }
    } else if (indexPath.section == 4) {
        return CGSizeMake((SCREEN_WITH - 30) / 2.0, FITHEIGHT(375));
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        if (self.imageArray.count > 0) {
            return UIEdgeInsetsMake(7, 7, 7, 7);
        } else {
            return UIEdgeInsetsZero;
        }
    } else if (section == 4) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return 2;
    } else if (section == 4) {
        return 10;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        if (self.productArray.count > 3) {
            if (self.expanded) {
                if (indexPath.row == self.productArray.count) {
                    self.expanded = NO;
                    [self.collectionView setContentOffset:CGPointMake(0, _lastOffset) animated:NO];
                } else {
                    [self pushProductDetail:indexPath.item];
                }
            } else {
                if (indexPath.row == 3) {
                    self.expanded = YES;
                    self.lastOffset = self.collectionView.contentOffset.y;
                } else {
                    [self pushProductDetail:indexPath.item];
                }
            }
            [self.collectionView reloadData];
        }
        
    } else if (indexPath.section == 4) {
        PostModel *postModel = [self.postArray objectAtIndex:indexPath.row];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:postModel.post_guid] forKey:@"id"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_PRODUCTDETAIL_VC navigationController:self.navigationController params:userInfo animated:NO];
    }
}

#pragma mark -
#pragma mark PushProductDetail
- (void)pushProductDetail:(NSInteger)indexRow {
    TopProductModel *topProductModel = [self.productArray objectAtIndex:indexRow];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:topProductModel.product_guid] forKey:@"id"];
    [paramDic setObject:[NSNumber numberWithInteger:self.pinTopSceneType] forKey:@"pinTopSceneType"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_PINPRODUCTDETAIL_VC navigationController:self.navigationController params:paramDic animated:NO];
    
    [NSObject event:@"TOP002" label:@"点击TOP10商品"];
}

#pragma mark -
#pragma mark Priveta Method
- (void)rightButtonAction:(UIButton *)button {
    [NSObject event:[NSString stringWithFormat:@"TOP00%zd", 2 + self.pinTopSceneType] label:[NSString stringWithFormat:@"%@发布", getTopSenceTitle(self.pinTopSceneType)]];
    
    BOOL isLogin = [UserDefaultManagement instance].isLogined;
    if (isLogin) {
        [self chooseRecoomedImageAction];
        return;
    }
    [self presentLoginVC];
}

- (void)chooseRecoomedImageAction {
    UIActionSheet *sheet = [super createSheet:self];
    [sheet showInView:self.view.window];
}

- (void)presentLoginVC {
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[NSNumber numberWithInteger: PinLoginType_PublishRecommed] forKey:@"pinLoginType"];
    [paramsDic setObject:self forKey:@"delegate"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)presentPulishVC {
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.paramImage forKey:@"paramImage"];
    [paramsDic setObject:[NSNumber numberWithInteger:self.pinTopSceneType] forKey:@"pinTopSceneType"];
    [[ForwardContainer shareInstance] pushContainer: FORWARD_PUBLISHRECOMMEND_VC navigationController:navigationController params:paramsDic animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index {
    PLog(@"点击了第%zd张图片", index);
    [NSObject event:@"TOP001" label:@"轮播图"];
    LoopAdModel *loopAdModel = [self.loopAdArray objectAtIndex:index];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:loopAdModel.name?:@"" forKey:@"title"];
    [paramDic setObject:loopAdModel.url forKey:@"loadUrl"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_WEBVIEW_VC navigationController:self.navigationController params:paramDic animated:NO];
}

#pragma mark -
#pragma mark - actionSheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = [super imagePickerController:buttonIndex];
        if (sourceType == -1) {
            return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            imagePickerController.allowsEditing = NO;
        } else {
            imagePickerController.allowsEditing = YES;
        }
        imagePickerController.sourceType = sourceType;
        imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    if (buttonIndex == 2) {
        [NSObject event:[NSString stringWithFormat:@"TOP00%zd", 6 + self.pinTopSceneType] label:[NSString stringWithFormat:@"取消%@发布推荐", getTopSenceTitle(self.pinTopSceneType)]];
    }
}

#pragma mark -
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [UIImage imageNamed:@""];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    } else {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    self.paramImage = image;
    [self presentPulishVC];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//实现navigationController的代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationController.navigationBar.barTintColor = HEXCOLOR(pinColorNativeBarColor);
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    viewController.navigationController.navigationBar.translucent = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController.navigationBar become_backgroundColor:HEXCOLOR(pinColorNativeBarColor)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
