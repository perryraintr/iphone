//
//  DetailCompareController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/23.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailCompareController.h"
#import "DetailHeaderView.h"
#import "DetailFooterView.h"
#import "DetailVoteModel.h"
#import "DetailCompareCell.h"
#import "DetailReplyCell.h"
#import "CommentModel.h"
#import "SectionTitleTableCell.h"
#import "PINShareView.h"

@interface DetailCompareController () <UITableViewDelegate, UITableViewDataSource, DetailFooterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (nonatomic, strong) DetailHeaderView *detailHeaderview;

@property (nonatomic, strong) DetailFooterView *detailFooterview;

@property (nonatomic, strong) DetailVoteModel *detailVote;

@property (nonatomic, strong) PINShareView *pinShareView;

@property (nonatomic, assign) int voteId;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray *replyArray;

@property (nonatomic, assign) int ubid;

@end

@implementation DetailCompareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.title = @"详情";
    [self initParams];
    [self initUI];
    [self detailVoteRequest];
}

- (void)initBaseParams {
    self.voteId = [[self.postParams objectForKey:@"id"] intValue];
    self.ubid = 0;
}

- (void)initParams {
    self.currentPage = 1;
    self.ubid = 0;
    self.replyArray = [NSMutableArray array];
}

- (void)initUI {
    
    self.topLayoutConstraint.constant = 64 + FITHEIGHT(50);
    self.bottomLayoutConstraint.constant = FITHEIGHT(56);
    if (isWXAppInstalled()) {
        [super indexRightBarButtonWithImage:@"shareItem" selector:@selector(shareDetail) delegate:self isIndex:NO];
        self.pinShareView = [[PINShareView alloc] init];
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
- (void)detailVoteRequest {
    // 需要加载动画
    [self.httpService detailRequestWithMethodName:@"vote.a" currentId:[NSString stringWithFormat:@"vid=%zd", self.voteId] finished:^(NSDictionary *result, NSString *message) {
        
        self.detailVote = [DetailVoteModel modelWithDictionary:result];
        
        [self.detailHeaderview resetDetailHeaderView:@[@"品选"] withUserName:self.detailVote.vote_user_name withUserImageUrl:self.detailVote.vote_user_avatar isShit:NO];
        [self.detailFooterview resetCompareDetailWith:self.detailVote];
        [self detailReplyRequestDragUp:NO];
        
    } failure:^(NSDictionary *result, NSString *message) {
    }];
}

- (void)detailReplyRequestDragUp:(BOOL)isDragup {
    self.currentPage = isDragup ? (self.currentPage + 1) : 1;
    NSString *paramString = [NSString stringWithFormat:@"vid=%zd", self.voteId];

    [self.httpService commentRequestWithCurrentPage:self.currentPage currentId:paramString finished:^(NSDictionary *result, NSString *message) {
        
        if (self.currentPage == 1) {
            [self.replyArray removeAllObjects];
        }
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
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
        [self.tableview addFooter:XONE_Dic_Is_Valid(result) ? YES : NO];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [self.tableview endRefreshing];
    }];
}

- (void)replyRequest:(NSString *)replyStr {
    NSString *currentId = [NSString stringWithFormat:@"vid=%zd", self.voteId];
    
    [self.httpService replyRequestUid:self.detailVote.vote_user_id ubid:self.ubid currentId:currentId replyStr:replyStr finished:^(NSDictionary *result, NSString *message) {
        
        self.detailVote.vote_comment += 1;
        [self.detailFooterview resetCompareDetailWith:self.detailVote];
        
        CommentModel *commentModel = [CommentModel modelWithDictionary:result];
        [self.replyArray addObject:commentModel];
        [self.tableview reloadData];

    } failure:^(NSDictionary *result, NSString *message) {
    }];
}

- (void)wishRequest {
    NSString *paramString = [NSString stringWithFormat:@"vid=%zd", self.voteId];
    if (self.detailVote.wish_guid == 0) {
        self.detailVote.wish_guid = 1;
        // 不需要加载动画
        [self.httpService zanRequestWithMethodName:@"addwish.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
            [self.detailFooterview resetCompareDetailWith:self.detailVote];
            [self chatShowHint:@"已加入收藏"];
            [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
            
        } failure:^(NSDictionary *result, NSString *message) {
            self.detailVote.wish_guid = 0;
        }];
        
    } else {
        self.detailVote.wish_guid = 0;
        // 不需要加载动画
        [self.httpService zanRequestWithMethodName:@"removewish.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
            [self.detailFooterview resetCompareDetailWith:self.detailVote];
            [self chatShowHint:@"已取消收藏"];
            [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
            
        } failure:^(NSDictionary *result, NSString *message) {
            self.detailVote.wish_guid = 1;
        }];        
    }
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    if (section == 0) {
        return (self.detailVote ? 1 : 0);
    } else if (section == 1) {
        return self.replyArray.count > 0 ? 1 : 0;
    } else {
        return self.replyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_WITH / 2.0 + FITHEIGHT(232);
    } else if (indexPath.section == 1) {
        return FITHEIGHT(48);
    } else {
        CommentModel *commentModel = [self.replyArray objectAtIndex:indexPath.row];
        NSString *markString = [NSString stringWithFormat:@"%@：%@%@", commentModel.user_name, [commentModel.reply_name isEqualToString:self.detailVote.vote_user_name] ? @"" :  [NSString stringWithFormat:@"回复%@ ", commentModel.reply_name], commentModel.message];
        float replyHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(26) * 2) text:markString fontSize:fFont14 isSuo:NO];
        return replyHeight + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"cellId";
        DetailCompareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[DetailCompareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell resetRecommendCell:self.detailVote];
        [cell pushProductDetail:^(int productId) {
            [self pushProductDetail:productId];
        }];
        
        return cell;
    } else if (indexPath.section == 1) {
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
        [replyCell resetDetailReplyCell:commentModel withReplyName:self.detailVote.vote_user_name];
        
        return replyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 || indexPath.section == 1) {
        return;
    } else {
        CommentModel *commentModel = [self.replyArray objectAtIndex:indexPath.row];
        self.ubid = commentModel.user_guid;
        [self pushTextVC];
        [NSObject event:@"HF001" label:@"回复其他人的留言"];
    }
}

#pragma mark -
#pragma mark TextViewDelgate 留言
- (void)sureTextView:(NSString *)string {
    [self replyRequest:string];
}

#pragma mark -
#pragma mark PushProductDetail
- (void)pushProductDetail:(int)productId {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:productId] forKey:@"id"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_PINPRODUCTDETAIL_VC navigationController:self.navigationController params:paramDic animated:NO];
    [NSObject event:@"VOTE001" label:@"跳转商品详情页"];
}

#pragma mark -
#pragma mark DetailFooterViewDelegate
- (void)detailSupportAction {
    NSString *paramString = [NSString stringWithFormat:@"vid=%zd", self.detailVote.vote_guid];
    if (self.detailVote.favorite_guid == 0) { // 添加赞
        self.detailVote.favorite_guid = 1;
        self.detailVote.vote_favorite += 1;
        
        // 不需要加载动画
        [self.httpService zanRequestWithMethodName:@"addfavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
            
            [self.detailFooterview resetCompareDetailWith:self.detailVote];
            [PINBaseRefreshSingleton instance].refreshRecommend = 1;
            [PINBaseRefreshSingleton instance].refreshTopGoodsList = 1;
            [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;

        } failure:^(NSDictionary *result, NSString *message) {
            self.detailVote.favorite_guid = 0;
            self.detailVote.vote_favorite -= 1;
        }];
        
    } else { // 移除赞
        self.detailVote.favorite_guid = 0;
        self.detailVote.vote_favorite -= 1;
        // 不需要加载动画
        [self.httpService zanRequestWithMethodName:@"addfavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
            
            [self.detailFooterview resetCompareDetailWith:self.detailVote];
            [PINBaseRefreshSingleton instance].refreshRecommend = 1;
            [PINBaseRefreshSingleton instance].refreshTopGoodsList = 1;
            [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
            
        } failure:^(NSDictionary *result, NSString *message) {
            self.detailVote.favorite_guid = 1;
            self.detailVote.vote_favorite += 1;
        }];
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
    self.ubid = self.detailVote.vote_user_id;
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
    [NSObject event:@"FX001" label:@"比较详情分享"];
    self.pinShareView.shareImageUrl = self.detailVote.product_a_guid > 0 ? self.detailVote.product_a_image : self.detailVote.posta_image;
    self.pinShareView.shareUrl = [NSString stringWithFormat:@"%@vote_detail_share.html?vid=%zd", REQUEST_HTML_URL, self.detailVote.vote_guid];
    self.pinShareView.shareContent = self.detailVote.vote_name;
    self.pinShareView.sharePresentController = self;
    self.pinShareView.showShareView = !self.pinShareView.showShareView;
}

@end
