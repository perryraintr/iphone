//
//  InfoListController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "InfoListController.h"
#import "InfoListCell.h"
#import "MessageModel.h"

@interface InfoListController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *infoDataSoure;

@property (assign, nonatomic) int currentPage;

@end

@implementation InfoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.title = @"消息列表";
    
    if (pinSheAppDelegate().networkType == PinNetworkType_None) {
        [self chatShowHint:@"网络不给力"];
        return;
    }
    
    [self initParams];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self messageRequestWithDragup:NO withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)initParams {
    self.infoDataSoure = [NSMutableArray array];
    self.currentPage = 1;
}

- (void)initUI {
    [self.tableview addRefreshHeaderWithCompletion:^{
        [self messageRequestWithDragup:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }];
}

- (void)messageRequestWithDragup:(BOOL)isDragup withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    self.currentPage = isDragup ? (self.currentPage + 1) : 1;
    
    [self.httpService messageRequestWithIndicatorStyle:indicatorStyle currentPage:self.currentPage finished:^(NSDictionary *result, NSString *message) {
        
        if (self.currentPage == 1) {
            self.tableview.delegate = self;
            self.tableview.dataSource = self;
            [self.infoDataSoure removeAllObjects];
        }
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            MessageModel *messageModel = [MessageModel modelWithDictionary:dic];
            [self.infoDataSoure addObject:messageModel];
        }
        
        [self.tableview reloadData];
        [self.tableview endRefreshing];
        [self.tableview addFooter:XONE_Dic_Is_Valid(result) ? YES : NO];
        
        if (self.tableview.mj_footer == nil && self.infoDataSoure.count == REQUEST_FOOTER_SIZE) {
            [self.tableview addRefreshFooterWithCompletion:^{
                [self messageRequestWithDragup:YES withIndicatorStyle:PinIndicatorStyle_NoIndicator];
            }];
        }
        
        [UserDefaultManagement instance].messageClickTime = ((MessageModel *)[self.infoDataSoure firstObject]).modify_time1;
        
    } failure:^(NSDictionary *result, NSString *message) {
        [self.tableview endRefreshing];
    }];
    
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoDataSoure.count > 0 ? self.infoDataSoure.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.infoDataSoure.count > 0) {
        MessageModel *messageModel = [self.infoDataSoure objectAtIndex:indexPath.row];
        CGFloat AllHeight = [NSString getTextHeight:SCREEN_WITH - FITWITH(155) text:messageModel.message fontSize:fFont12 isSuo:YES] + FITHEIGHT(61);
        return AllHeight;
    } else {
        return SCREEN_HEIGHT - 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.infoDataSoure.count > 0) {
        static NSString *infoListCellId = @"infoListCellId";
        InfoListCell *infoListCell = [tableView dequeueReusableCellWithIdentifier:infoListCellId];
        if (!infoListCell) {
            infoListCell = [[InfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoListCellId];
        }
        [infoListCell resetInfoListCell:[self.infoDataSoure objectAtIndex:indexPath.row]];
        infoListCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
        return infoListCell;
    } else {
        return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"暂无消息"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MessageModel *messageModel = [self.infoDataSoure objectAtIndex:indexPath.row];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (messageModel.type == 3) {
        [userInfo setObject:[NSNumber numberWithInteger:messageModel.vote_guid] forKey:@"id"];
    } else {
        [userInfo setObject:[NSNumber numberWithInteger:messageModel.post_guid] forKey:@"id"];
    }
    [[ForwardContainer shareInstance] pushContainer:[self getPushDetail:messageModel.type] navigationController:self.navigationController params:userInfo animated:NO];
    
}

- (NSString *)getPushDetail:(int)type {
    switch (type) {
        case 1:
            return FORWARD_DETAILRECOMMEND_VC; // 推荐详情
            break;
        case 2:
            return FORWARD_DETAILSHIT_VC; // 吐槽详情
            break;
        case 3:
            return FORWARD_DEATILCOMPARE_VC; // 比较详情
            break;
        default:
            break;
    }
    return @"";
}

@end
