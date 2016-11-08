//
//  PINRootController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINRootController.h"
#import "PlainCellBgView.h"
#import "PINCashModel.h"
#import "PINCashCell.h"
#import "MJRefresh.h"
#import "PINStoreModel.h"
#import "PINStoreTitleCell.h"
#import "PINTodayCell.h"

@interface PINRootController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *cashArray;

@property (strong, nonatomic) NSMutableArray *storeArray;

@property (assign, nonatomic) int page;

@property (strong, nonatomic) UIView *checkView;

@property (assign, nonatomic) BOOL isFinished;

@property (assign, nonatomic) float storeAmount;

@property (assign, nonatomic) int storeCount;

@property (strong, nonatomic) PINStoreModel *pinStoreModel;

@end

@implementation PINRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家系统";
    [self initParams];
    [self initUI];
    if (PINAppDelegate().networkType == PINNetworkType_None) {
        [self chatShowHint:@"网络不给力"];
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#warning by shi 放置这里
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self checkStore:NO];
}

- (void)initParams {
    self.cashArray = [NSMutableArray array];
    self.storeArray = [NSMutableArray array];
    self.page = 1;
    self.isFinished = false;
    self.storeCount = 0;
    self.storeAmount = 0;
}

- (void)initUI {
    __unsafe_unretained UITableView *tableView = self.tableview;
    weakSelf(self);
    [tableView addRefreshHeaderWithCompletion:^{
        [weakSelf drawUp];
    }];
}

#pragma mark -
#pragma mark - request
- (void)checkStore:(BOOL)isDragUp {
    
    [self.httpService storeInfoRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        self.pinStoreModel = [PINStoreModel modelWithDictionary:result];
        [self requestCashListWithDragup:isDragUp];

    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"请求错误"];
    }];
    
}

- (void)requestCashListWithDragup:(BOOL)isDragup {
    
    self.page = isDragup ? (self.page + 1) : 1;
    
    [self.httpService cashRequestWithSid:[PINUserDefaultManagement instance].sid page:self.page date:[NSString stringFromDateyyyy_MM_dd:[NSDate date]] finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.isFinished = YES;
        if (self.page == 1) {
            [self.cashArray removeAllObjects];
        }
        
        self.storeAmount = [[result objectForKey:@"amount"] floatValue];
        
        self.storeCount = [[result objectForKey:@"count"] intValue];
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINCashModel *pinCashModel = [PINCashModel modelWithDictionary:dic];
            [self.cashArray addObject:pinCashModel];
        }
        
        [self.tableview endRefreshing];
        [self.tableview reloadData];
        
        if (self.tableview.mj_footer == nil && self.cashArray.count >= 10) {
            weakSelf(self);
            [self.tableview addRefreshFooterWithCompletion:^{
                [weakSelf drawDown];
            }];
        }

    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.isFinished = YES;
        if (self.page > 1) {
            self.page -= 1;
            [self chatShowHint:@"没有更多记录"];
        } else {
            self.storeAmount = 0;
            self.storeCount = 0;
            [self.cashArray removeAllObjects];
            self.tableview.mj_footer = nil;
        }
        [self.tableview endRefreshing];
        [self.tableview reloadData];

    }];
}

#pragma mark -
#pragma mark - Button Action
- (void)drawUp {
    [self checkStore:NO];
}

- (void)drawDown {
    [self requestCashListWithDragup:YES];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        if (self.isFinished) {
            return self.cashArray.count > 0 ? self.cashArray.count : 1;
        }
        return 0;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         return FITHEIGHT(80);
    } else if (indexPath.section == 2) {
        return 118;
    } else if (indexPath.section == 1 || indexPath.section == 3) {
        return 40;
    } else if (indexPath.section == 4) {
        if (self.cashArray.count > 0) {
            PINCashModel *cashModel = [self.cashArray objectAtIndex:indexPath.row];
            if (cashModel.type == -1) {
                return FITHEIGHT(72);
            } else {
                return FITHEIGHT(105);
            }
        } else {
            return 118;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 10)];
    if (section != 4) {
        view.height = 0;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 0) {
       static NSString *pinStoreTitleCellId = @"pinStoreTitleCellId";
       PINStoreTitleCell *pinStoreTitleCell = [tableView dequeueReusableCellWithIdentifier:pinStoreTitleCellId];
       if (pinStoreTitleCell == nil) {
           pinStoreTitleCell = [[PINStoreTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pinStoreTitleCellId];
       }
       pinStoreTitleCell.nameLabel.text = self.pinStoreModel.name;
       pinStoreTitleCell.amountLabel.text = [NSString stringWithFormat:@"当前余额：%.2f元", self.pinStoreModel.current];
       pinStoreTitleCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];

       return pinStoreTitleCell;

   } else if (indexPath.section == 1) {
       static NSString *cashTitleCell1Id = @"cashTitleCellId";
       UITableViewCell *cashTitleCell1 = [tableView dequeueReusableCellWithIdentifier:cashTitleCell1Id];
       if (cashTitleCell1 == nil) {
           cashTitleCell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashTitleCell1Id];
           cashTitleCell1.selectionStyle = UITableViewCellSelectionStyleNone;
       }
       cashTitleCell1.textLabel.text = @"当日累计";
       cashTitleCell1.textLabel.font = FontBold(fFont18);
       cashTitleCell1.backgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:NO];
       return cashTitleCell1;
       
   } else if (indexPath.section == 2) {
       static NSString *pinTodayCellId = @"pinTodayCellId";
       PINTodayCell *pinTodayCell = [tableView dequeueReusableCellWithIdentifier:pinTodayCellId];
       if (pinTodayCell == nil) {
           pinTodayCell = [[PINTodayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pinTodayCellId];
       }

       pinTodayCell.amountLabel.attributedText = getAttributedString(@"品社订单收入: ", pinColorDarkBlack, [NSString stringWithFormat:@"%.2f元", self.storeAmount], pinColorDarkBlack, fFont16, fFont18, YES);
       
       pinTodayCell.countLabel.attributedText = getAttributedString(@"品社订单笔数: ", pinColorDarkBlack, [NSString stringWithFormat:@"%zd笔", self.storeCount], pinColorDarkBlack, fFont16, fFont18, YES);

       pinTodayCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
       
       return pinTodayCell;
       
   } else if (indexPath.section == 3) {
        static NSString *cashTitleCellId = @"cashTitleCellId";
        UITableViewCell *cashTitleCell = [tableView dequeueReusableCellWithIdentifier:cashTitleCellId];
        if (cashTitleCell == nil) {
            cashTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashTitleCellId];
            cashTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cashTitleCell.textLabel.text = @"当日明细";
        cashTitleCell.textLabel.font = FontBold(fFont18);
        cashTitleCell.backgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:NO];
        return cashTitleCell;
        
    } else if (indexPath.section == 4) {
        if (self.cashArray.count == 0) {
            return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"啊哦，目前没有账单哦～"];
        } else {
            static NSString *cashCellId = @"cashCellId";
            PINCashCell *cashCell = [tableView dequeueReusableCellWithIdentifier:cashCellId];
            if (cashCell == nil) {
                cashCell = [[PINCashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashCellId];
            }
            [cashCell resetCashCell:[self.cashArray objectAtIndex:indexPath.row]];
            cashCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
            return cashCell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

@end
