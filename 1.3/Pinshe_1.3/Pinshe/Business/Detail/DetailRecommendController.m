//
//  DetailRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/31.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailRecommendController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "DetailHeaderView.h"
#import "DetailFooterView.h"
#import "CommentModel.h"
#import "DetailReplyCell.h"
#import "DetailRecommendModel.h"
#import "SectionTitleTableCell.h"
#import "RecommendCell.h"
#import "XRCarouselView.h"

@interface DetailRecommendController () <UITableViewDelegate,UITableViewDataSource, DetailFooterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (nonatomic, strong) DetailHeaderView *detailHeaderview;

@property (nonatomic, strong) DetailFooterView *detailFooterview;

@property (nonatomic, strong) DetailRecommendModel *detailRecommendModel;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray *replyArray;

@property (nonatomic, assign) int productId;

@property (nonatomic, assign) int ubid;

@end

@implementation DetailRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.title = @"详情";
    [self initParams];
    [self initUI];
    [self detailPostRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XRCarouselView clearDiskCache];
}

- (void)initBaseParams {
    self.productId = [[self.postParams objectForKey:@"id"] intValue];
}

- (void)initParams {
    self.ubid = 0;
    self.currentPage = 1;
    self.replyArray = [NSMutableArray array];
}

- (void)initUI {
    self.bottomLayoutConstraint.constant = FITHEIGHT(56);
    if (isWXAppInstalled()) {
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
}

#pragma mark -
#pragma mark REQUEST
- (void)detailPostRequest {
    [super pinRequestByGet:[NSString stringWithFormat:@"uid=%zd&pid=%zd", [UserDefaultManagement instance].userId, self.productId] withMethodName:@"post.a" withMethodBack:@"postDetail" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)detailReplyRequestDragUp:(BOOL)isDragup {
    NSString *paramString = [NSString stringWithFormat:@"pid=%zd&page=%zd", self.productId, isDragup ? (self.currentPage + 1) : 1];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:isDragup ? (self.currentPage + 1) : 1] forKey:@"currentPage"];
    [super pinRequestByGet:paramString withMethodName:@"comment.a" withMethodBack:@"comment" withUserInfo:userInfo withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)replyRequest:(NSString *)replyStr {
    NSString *uid = [NSString stringWithFormat:@"&uid=%zd&uaid=%zd&ubid=%zd", self.detailRecommendModel.user_guid, [UserDefaultManagement instance].userId, self.ubid];
    NSString *paramString = [NSString stringWithFormat:@"pid=%zd%@&m=%@", self.productId, uid, replyStr];
    [super pinRequestByGet:paramString withMethodName:@"addcomment.a" withMethodBack:@"addcomment" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)wishRequest {
    NSString *paramString = [NSString stringWithFormat:@"uid=%zd&pid=%zd", [UserDefaultManagement instance].userId, self.productId];
    if (self.detailRecommendModel.wish_guid == 0) {
        self.detailRecommendModel.wish_guid = 1;
        [super pinRequestByGet:paramString withMethodName:@"addwish.a" withMethodBack:@"addwish" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    } else {
        self.detailRecommendModel.wish_guid = 0;
        [super pinRequestByGet:paramString withMethodName:@"removewish.a" withMethodBack:@"removewish" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        if ([request.methodBack isEqualToString:@"comment"]) {
            [self.tableview endRefreshing];
        }
        return;
    }
    NSString *responseString = request.responseString;
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseString];
    [super requestFinished:request];
    
    if ([request.methodBack isEqualToString:@"postDetail"]) {
        self.detailRecommendModel = [DetailRecommendModel modelWithDictionary:pinBaseModel.body];

        [self.detailHeaderview resetDetailHeaderView:self.detailRecommendModel.tag_t2 withUserName:self.detailRecommendModel.user_name withUserImageUrl:self.detailRecommendModel.user_avatar isShit:(self.detailRecommendModel.tag_t1_id == 1 ? NO : YES)];
        
        [self.detailFooterview resetPostDetailWith:self.detailRecommendModel];
        
        [self detailReplyRequestDragUp:NO];
        
    } else if ([request.methodBack isEqualToString:@"comment"]) {
        self.currentPage = [[request.userInfo objectForKey:@"currentPage"] intValue];
        if (self.currentPage == 1) {
            [self.replyArray removeAllObjects];
        }
        
        for (NSDictionary *dic in [pinBaseModel.body objectForKey:@"array"]) {
            CommentModel *commentModel = [CommentModel modelWithDictionary:dic];
            [self.replyArray addObject:commentModel];
        }
        
        [self.tableview reloadData];
        
        if (self.tableview.mj_footer == nil && self.replyArray.count == REQUEST_FOOTER_SIZE) {
            [self.tableview addRefreshFooterWithCompletion:^{
                [self detailReplyRequestDragUp:YES];
            }];
        }
        [self.tableview endRefreshing];
        [self.tableview addFooter:XONE_Dic_Is_Valid(pinBaseModel.body) ? YES : NO];
        
    } else if ([request.methodBack isEqualToString:@"addcomment"]) {
        self.detailRecommendModel.post_comment += 1;
        [self.detailFooterview resetPostDetailWith:self.detailRecommendModel];
        
        CommentModel *commentModel = [CommentModel modelWithDictionary:pinBaseModel.body];
        [self.replyArray addObject:commentModel];
        [self.tableview reloadData];
        
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshTopGoodsList = 1;
        
    } else if ([request.methodBack isEqualToString:@"addwish"]) {
        [self.detailFooterview resetPostDetailWith:self.detailRecommendModel];
        [self chatShowHint:@"已加入收藏"];
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
        
    } else if ([request.methodBack isEqualToString:@"removewish"]) {
        [self.detailFooterview resetPostDetailWith:self.detailRecommendModel];
        [self chatShowHint:@"已取消收藏"];
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
        
    } else if ([request.methodBack isEqualToString:@"addfavorite"]) {
        [self.detailFooterview resetPostDetailWith:self.detailRecommendModel];
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshTopGoodsList = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;

    } else if ([request.methodBack isEqualToString:@"removefavorite"]) {
        [self.detailFooterview resetPostDetailWith:self.detailRecommendModel];
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshTopGoodsList = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;

    }
}

- (void)requestFailed:(PinResponseResult *)request {
    [super requestFailed:request];
    [self.tableview endRefreshing];
    if ([request.methodBack isEqualToString:@"addfavorite"]) {
        self.detailRecommendModel.favorite_guid = 0;
        self.detailRecommendModel.post_favorite -= 1;
    } else if ([request.methodBack isEqualToString:@"removefavorite"]) {
        self.detailRecommendModel.favorite_guid = 1;
        self.detailRecommendModel.post_favorite += 1;
    }  else if ([request.methodBack isEqualToString:@"addwish"]) {
        self.detailRecommendModel.wish_guid = 0;
    } else if ([request.methodBack isEqualToString:@"removewish"]) {
        self.detailRecommendModel.wish_guid = 1;
    }
}

#pragma mark -
#pragma mark TableViewDelegate && TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == tableView.numberOfSections - 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 0));
    if (section == tableView.numberOfSections - 1) {
        view.frame = CGRectMake(0, 0, SCREEN_WITH, 10);
    }
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ) {
        return self.detailRecommendModel.post_images.count > 0 ? 1 : 0;
    } else if (section == 1) {
        return (self.detailRecommendModel ? 1 : 0);
    } else if (section == 2) {
        return self.replyArray.count > 0 ? 1 : 0;
    } else {
        return self.replyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_WITH;
    } else if (indexPath.section == 1) {
        return  [self totalProductContentCellHeight];
    } else if (indexPath.section == 2) {
        return FITHEIGHT(48);
    } else {
        CommentModel *commentModel = [self.replyArray objectAtIndex:indexPath.row];
        NSString *markString = [NSString stringWithFormat:@"%@：%@%@", commentModel.user_name, [commentModel.reply_name isEqualToString:self.detailRecommendModel.user_name] ? @"" :  [NSString stringWithFormat:@"回复%@ ", commentModel.reply_name], commentModel.message];
        float replyHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(26) * 2) text:markString fontSize:fFont14 isSuo:NO];
        return replyHeight + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *loopScrollCellId = @"loopScrollCellId";
        UITableViewCell *loopScrollCell = [tableView dequeueReusableCellWithIdentifier:loopScrollCellId];
        if (loopScrollCell == nil) {
            loopScrollCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loopScrollCellId];
            XRCarouselView *xRCarouseView = [XRCarouselView carouselViewWithImageArray:self.detailRecommendModel.post_images describeArray:nil];
            xRCarouseView.time = 0;
            [xRCarouseView setPageColor:HEXCOLOR(pinColorLightGray) andCurrentPageColor:HEXCOLOR(pinColorOrange)];
            xRCarouseView.pagePosition = PositionBottomRight;
            [loopScrollCell.contentView addSubview:xRCarouseView];
            [xRCarouseView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(loopScrollCell.contentView);
            }];
        }
        return loopScrollCell;
    } else if (indexPath.section == 1) {
        static NSString *cellId = @"cellId";
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell resetRecommendCell:self.detailRecommendModel];
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *sectionCellId = @"sectionCellId";
        SectionTitleTableCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:sectionCellId];
        if (!sectionCell) {
            sectionCell = [[SectionTitleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionCellId];
        }
        [sectionCell resetSectionTitleTableCell:@"品友留言"];
        return sectionCell;
    } else {
        static NSString *replycellId = @"replyCellId";
        DetailReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:replycellId];
        if (!replyCell) {
            replyCell = [[DetailReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replycellId];
        }
        
        CommentModel *commentModel = [self.replyArray objectAtIndex:indexPath.row];
        [replyCell resetDetailReplyCell:commentModel withReplyName:self.detailRecommendModel.user_name];
        
        return replyCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        return;
    } else {
        CommentModel *commentModel = [self.replyArray objectAtIndex:indexPath.row];
        self.ubid = commentModel.user_guid;
        [self pushTextVC];
        [NSObject event:@"HF001" label:@"回复其他人的留言"];
    }
}

- (CGFloat)totalProductContentCellHeight {
    CGFloat allHeight = 0;
    CGFloat brandHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(16) - 5) text:self.detailRecommendModel.post_name withLineHiehtMultipe:1.0 withLineSpacing:0 fontSize:fFont14 isSuo:NO];
    if (brandHeight < FITHEIGHT(24)) {
        brandHeight = FITHEIGHT(24);
    }
    
    allHeight += brandHeight;
    allHeight += FITHEIGHT(19); // top fit12, 与描述间隔fit7
    
    CGFloat descriptionHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(26) * 2) text:self.detailRecommendModel.post_description withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];
    allHeight += descriptionHeight;
    allHeight += FITHEIGHT(35); // 发布时间
    return allHeight;
}

#pragma mark -
#pragma mark TextViewDelgate 留言
- (void)sureTextView:(NSString *)string {
    [self replyRequest:string];
}

#pragma mark -
#pragma mark DetailFooterViewDelegate
- (void)detailSupportAction {
    if (self.detailRecommendModel.favorite_guid == 0) { // 添加赞
        self.detailRecommendModel.favorite_guid = 1;
        self.detailRecommendModel.post_favorite += 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", self.detailRecommendModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"addfavorite.a" withMethodBack:@"addfavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
        
    } else { // 移除赞
        self.detailRecommendModel.favorite_guid = 0;
        self.detailRecommendModel.post_favorite -= 1;
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd&uid=%zd", self.detailRecommendModel.post_guid, [UserDefaultManagement instance].userId];
        [super pinRequestByGet:paramString withMethodName:@"removefavorite.a" withMethodBack:@"removefavorite" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
    
}

- (void)detailAddCollectAction { // 收藏
    // 需要先登录再展示
    if (![UserDefaultManagement instance].isLogined) {
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        [paramsDic setObject:self forKey:@"delegate"];
        [paramsDic setObject:[NSNumber numberWithInteger:PinLoginType_Favor] forKey:@"pinLoginType"];
        PinNavigationController *navigationController = [[PinNavigationController alloc] init];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    
    // 收藏
    [self wishRequest];
}

- (void)favorAction { // 跳转登录之后请求收藏接口
    [self wishRequest];
}

- (void)detailReplyAction {
    self.ubid = self.detailRecommendModel.user_guid;
    [self pushTextVC];
}

- (void)pushTextVC {
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self forKey:@"delegate"];
    [paramsDic setObject:[NSNumber numberWithInteger:PinLoginType_DetailCompare] forKey:@"pinLoginType"];
    
    // 需要先登录再展示
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    if ([UserDefaultManagement instance].isLogined) {
        [[ForwardContainer shareInstance] pushContainer:FORWARD_TEXTVIEW_VC navigationController:navigationController params:paramsDic animated:NO];
    } else {
        [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
    }
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)shareDetail {
    [NSObject event:@"FX002" label:@"推荐详情分享"];
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    UMSocialUrlResource *image = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.detailRecommendModel.post_image];
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@list_good_detail_share.html?pid=%zd", REQUEST_HTML_URL, self.detailRecommendModel.post_guid];
    
    //分享点击链接
    [UMSocialWechatHandler setWXAppId:WeChatAppleID appSecret:WeChatSecret url:shareUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:self.detailRecommendModel.post_name
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
