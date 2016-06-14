//
//  PINProductDetailController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINProductDetailController.h"
#import "UINavigationBar+SetColor.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "DetailHeaderView.h"
#import "DetailFooterView.h"
#import "SectionTitleCell.h"
#import "RecommendPostCell.h"
#import "PostModel.h"
#import "PINProductDetailModel.h"
#import "PINProductContentCell.h"
#import "PINProductImageCell.h"

@interface PINProductDetailController () <DetailFooterViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (nonatomic, assign) int pid;

@property (nonatomic, strong) DetailHeaderView *detailHeaderview;

@property (nonatomic, strong) DetailFooterView *detailFooterview;

@property (nonatomic, strong) NSMutableArray *postArray;

@property (nonatomic, strong) PINProductDetailModel *pinProductDetailModel;

@property (nonatomic, assign) PinTopSceneType pinTopSceneType;

@property (nonatomic, strong) UIImage *paramImage;

@end

@implementation PINProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.title = @"商品详情";
    [self initParams];
    [self initUI];
    [self requestProductDetail];
    [self requestPostWithProduct];
}

- (void)initBaseParams {
    self.pid = [[self.postParams objectForKey:@"id"] intValue];
    self.pinTopSceneType = [[self.postParams objectForKey:@"pinTopSceneType"] integerValue];
}

- (void)initParams {
    self.postArray = [NSMutableArray array];
}

- (void)initUI {
    self.bottomLayoutConstraint.constant = FITHEIGHT(56);
    
    if ([WXApi isWXAppInstalled]) {
        [super indexRightBarButtonWithImage:@"shareItem" selector:@selector(shareDetail) delegate:self isIndex:NO];
    }

    self.detailHeaderview = [[DetailHeaderView alloc] init];
    [self.view addSubview:_detailHeaderview];
    [self.detailHeaderview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.equalTo(@(FITHEIGHT(50)));
    }];
    
    self.detailFooterview = [[DetailFooterView alloc] init];
    self.detailFooterview.delegate = self;
    [self.view addSubview:_detailFooterview];
    [self.detailFooterview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(FITHEIGHT(56)));
    }];
    
    [self.collectionView registerClass:[PINProductImageCell class] forCellWithReuseIdentifier:@"pinProductImageCellId"];
    [self.collectionView registerClass:[PINProductContentCell class] forCellWithReuseIdentifier:@"pinProductContentCellId"];
    [self.collectionView registerClass:[SectionTitleCell class] forCellWithReuseIdentifier:@"sectionTitleCellId"];
    [self.collectionView registerClass:[RecommendPostCell class] forCellWithReuseIdentifier:@"recommendPostCellId"];

}
//product.a?pid=1
- (void)requestProductDetail {
    NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", self.pid, [UserDefaultManagement instance].userId];
    [super pinRequestByGet:paramString withMethodName:@"product.a" withMethodBack:@"product" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)requestPostWithProduct {
    NSString *paramString = [NSString stringWithFormat:@"productid=%zd&uid=%zd", self.pid, [UserDefaultManagement instance].userId];
    [super pinRequestByGet:paramString withMethodName:@"post.a" withMethodBack:@"post" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

// 点赞请求接口
- (void)postSupportWith:(PostModel *)postModel {
    if (postModel.favorite_guid == 0) { // 添加赞
        self.pinProductDetailModel.product_favorite += 1; // 商品点赞数加1
        
        postModel.favorite_guid = 1;
        postModel.post_favorite = postModel.post_favorite + 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", postModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"addfavorite.a" withMethodBack:@"addfavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
        
    } else { // 移除赞
        self.pinProductDetailModel.product_favorite -= 1; // 商品点赞数减1
        
        postModel.favorite_guid = 0;
        postModel.post_favorite = postModel.post_favorite - 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", postModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"removefavorite.a" withMethodBack:@"removefavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
    
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    
    [super requestFinished:request];
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:request.responseString];
    
    if ([request.methodBack isEqualToString:@"product"]) {
        
        self.pinProductDetailModel = [PINProductDetailModel modelWithDictionary:pinBaseModel.body];
        
        [self.detailHeaderview resetDetailHeaderView:self.pinProductDetailModel.tag_t2 withUserName:@"" withUserImageUrl:@"" isShit:NO];
        [self.detailFooterview resetProductDetailWith:self.pinProductDetailModel];
        
        [self.collectionView reloadData];
        
    } else if ([request.methodBack isEqualToString:@"post"]) {
        
        for (NSDictionary *dic in [pinBaseModel.body objectForKey:@"array"]) {
            PostModel *postModel = [PostModel modelWithDictionary:dic];
            [self.postArray addObject:postModel];
        }
        [self.collectionView reloadData];
        
    } else if ([request.methodBack isEqualToString:@"addfavorite"] || [request.methodBack isEqualToString:@"removefavorite"]) {
        [self.detailFooterview resetProductDetailWith:self.pinProductDetailModel];
        [self.collectionView reloadData];
    }
    
}

- (void)requestFailed:(PinResponseResult *)request {
    [super requestFailed:request];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return self.pinProductDetailModel ? 1 : 0;
    } else if (section == 2) {
        return self.postArray.count > 0 ? 1 : 0;
    } else if (section == 3) {
        return self.postArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 图片
        PINProductImageCell *pinProductImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pinProductImageCellId" forIndexPath:indexPath];
        [pinProductImageCell resetPINProductImageCell:self.pinProductDetailModel.product_image];
        return pinProductImageCell;
    } else if (indexPath.section == 1) { // 内容
        PINProductContentCell *productContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pinProductContentCellId" forIndexPath:indexPath];
        [productContentCell resetPINProductContentCell:self.pinProductDetailModel];
        return productContentCell;
    } else if (indexPath.section == 2) { // sectionHeader
        SectionTitleCell *sectionTitleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sectionTitleCellId" forIndexPath:indexPath];
        [sectionTitleCell resetSectionTitleCell:[NSString stringWithFormat:@"品友推荐（%zd个）", self.postArray.count]];
        sectionTitleCell.titleLabel.textColor = HEXCOLOR(pinColorDarkOrange);
        return sectionTitleCell;
    } else if (indexPath.section == 3) {
        RecommendPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendPostCellId" forIndexPath:indexPath];
        [cell resetRecommendPostCell:[self.postArray objectAtIndex:indexPath.item]];
        [cell postSupportSelBlock:^(PostModel *postModel) {
            [self postSupportWith:postModel];
        }];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WITH, SCREEN_WITH);
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WITH, [self totalProductContentCellHeight]);
    } else if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WITH, FITHEIGHT(44));
    } else {
        return CGSizeMake((SCREEN_WITH - 30) / 2.0, FITHEIGHT(375));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return 10;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        if (self.pinProductDetailModel.product_address.length > 0) {
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setObject:self.pinProductDetailModel.product_name forKey:@"title"];
            [paramDic setObject:self.pinProductDetailModel.product_address forKey:@"loadUrl"];
            [[ForwardContainer shareInstance] pushContainer:FORWARD_WEBVIEW_VC navigationController:self.navigationController params:paramDic animated:NO];
            [NSObject event:@"PRODUCT001" label:@"立即购买"];
        }
    } else if (indexPath.section == 3) {
        PostModel *postModel = [self.postArray objectAtIndex:indexPath.item];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:postModel.post_guid] forKey:@"id"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_PRODUCTDETAIL_VC navigationController:self.navigationController params:userInfo animated:NO];
        [NSObject event:@"PRODUCT003" label:@"跳转推荐帖子详情页"];
    }
}

- (CGFloat)totalProductContentCellHeight {
    CGFloat allHeight = 0;
    CGFloat brandHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(16) - 5) text:self.pinProductDetailModel.product_name withLineHiehtMultipe:1.0 withLineSpacing:0 fontSize:fFont14 isSuo:NO];
    if (brandHeight < FITHEIGHT(24)) {
        brandHeight = FITHEIGHT(24);
    }
    
    allHeight += brandHeight;
    allHeight += FITHEIGHT(19); // top fit12, 与描述间隔fit7
    
    CGFloat descriptionHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(26) * 2) text:self.pinProductDetailModel.product_description withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];
    allHeight += descriptionHeight;
    allHeight += FITHEIGHT(20); // 间距
    if (self.pinProductDetailModel.product_address.length == 0 && self.pinProductDetailModel.product_price == 0) {
        return allHeight;
    } else {
        allHeight += FITHEIGHT(40);
        return allHeight;
    }
}

#pragma mark -
#pragma mark DetailFooterViewDelegate
- (void)detailAddCollectAction { // 分享体验
    [NSObject event:@"PRODUCT002" label:@"分享体验"];
    // 跳转推荐发布页面
    BOOL isLogin = [UserDefaultManagement instance].isLogined;
    if (isLogin) {
        [self chooseRecoomedImageAction];
        return;
    }
    // 未登录，先登录
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[NSNumber numberWithInteger: PinLoginType_PublishRecommed] forKey:@"pinLoginType"];
    [paramsDic setObject:self forKey:@"delegate"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)chooseRecoomedImageAction {
    UIActionSheet *sheet = [super createSheet:self];
    [sheet showInView:self.view.window];
}

- (void)presentPulishVC {
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.paramImage forKey:@"paramImage"];
    [paramsDic setObject:[NSNumber numberWithInteger:self.pinTopSceneType] forKey:@"pinTopSceneType"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_PUBLISHRECOMMEND_VC navigationController:navigationController params:paramsDic animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
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

#pragma mark -
#pragma mark ShareDetail
- (void)shareDetail {
    [NSObject event:@"FX004" label:@"商品详情分享"];

    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    UMSocialUrlResource *image = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.pinProductDetailModel.product_image];
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@product_detail_share.html?pid=%zd", REQUEST_HTML_URL, self.pinProductDetailModel.product_guid];
    
    //分享点击链接
    [UMSocialWechatHandler setWXAppId:WeChatAppleID appSecret:WeChatSecret url:shareUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:self.pinProductDetailModel.product_name
                                                          image:nil
                                                       location:nil
                                                    urlResource:image
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *response)
     {
         if (response.responseCode == UMSResponseCodeSuccess) {
             
             [self chatShowHint:@"分享成功"];
             
         } else {
             
             [self chatShowHint:@"分享失败"];
             
         }
     }];
}


@end
