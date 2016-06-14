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
#import "IndexVote.h"
#import "DetailCompareCell.h"
#import "DetailReplyCell.h"
#import "CommentModel.h"
#import "SectionTitleTableCell.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface DetailCompareController () <UITableViewDelegate, UITableViewDataSource, DetailFooterViewDelegate>

@property (nonatomic, assign) int voteId;
@property (nonatomic, strong) DetailHeaderView *detailHeaderview;
@property (nonatomic, strong) DetailFooterView *detailFooterview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IndexVote *detailVote;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
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
}

#pragma mark -
#pragma mark REQUEST
- (void)detailVoteRequest {
    [super pinRequestByGet:[NSString stringWithFormat:@"vid=%zd", self.voteId] withMethodName:@"vote.a" withMethodBack:@"vote" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)detailReplyRequestDragUp:(BOOL)isDragup {
    NSString *paramString = [NSString stringWithFormat:@"vid=%zd&page=%zd", self.voteId, isDragup ? (self.currentPage + 1) : 1];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:isDragup ? (self.currentPage + 1) : 1] forKey:@"currentPage"];
    [super pinRequestByGet:paramString withMethodName:@"comment.a" withMethodBack:@"comment" withUserInfo:userInfo withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)replyRequest:(NSString *)replyStr {
    NSString *uid = [NSString stringWithFormat:@"&uid=%zd&uaid=%zd&ubid=%zd", self.detailVote.vote_user_id, [UserDefaultManagement instance].userId, self.ubid];
    NSString *paramString = [NSString stringWithFormat:@"vid=%zd%@&m=%@", self.voteId, uid, replyStr];
    [super pinRequestByGet:paramString withMethodName:@"addcomment.a" withMethodBack:@"addcomment" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
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

    if ([request.methodBack isEqualToString:@"vote"]) {
        self.detailVote = [IndexVote modelWithDictionary:pinBaseModel.body];

        [self.detailHeaderview resetDetailHeaderView:@[@"品选"] withUserName:self.detailVote.usera_name withUserImageUrl:self.detailVote.usera_avatar isShit:NO];
        [self.detailFooterview resetDetailCompareWithReply:self.detailVote.vote_comment];
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
        
        self.detailFooterview.replyNumLabel.text = [NSString stringWithFormat:@"%zd", self.detailVote.vote_comment + 1];
        
        CommentModel *commentModel = [CommentModel modelWithDictionary:pinBaseModel.body];
        [self.replyArray addObject:commentModel];
        [self.tableview reloadData];
    }
}

- (void)requestFailed:(PinResponseResult *)request {
    [super requestFailed:request];
    [self.tableview endRefreshing];
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
        CGFloat contentTextHeight = [NSString getTextHeight:(SCREEN_WITH - FITWITH(26) * 2) text:self.detailVote.vote_name withLineHiehtMultipe:1.0 withLineSpacing:5 fontSize:fFont14 isSuo:NO];
        return SCREEN_WITH / 2.0 + contentTextHeight + FITWITH(26) * 2 + FITHEIGHT(15);
    } else if (indexPath.section == 1) {
        return FITHEIGHT(48);
    } else {
        CommentModel *commentModel = [self.replyArray objectAtIndex:indexPath.row];
        NSString *markString = [NSString stringWithFormat:@"%@：%@%@", commentModel.user_name, commentModel.reply_name.length > 0 ? [NSString stringWithFormat:@"回复%@ ", commentModel.reply_name] : @"", commentModel.message];
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
        [replyCell resetDetailReplyCell:commentModel];
        
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
#pragma mark DetailFooterViewDelegate
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
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];

    UMSocialUrlResource *image = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.detailVote.posta_image];
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@share_vote.a?vid=%zd", getRequestUrl(), self.detailVote.vote_guid];
    //分享点击链接
    [UMSocialWechatHandler setWXAppId:WeChatAppleID appSecret:WeChatSecret url:shareUrl];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:self.detailVote.vote_name image:IMG_Name(@"detailIcon")                                                       location:nil
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
