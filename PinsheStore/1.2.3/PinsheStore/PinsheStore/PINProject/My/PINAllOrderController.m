//
//  PINAllOrderController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/10/19.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINAllOrderController.h"
#import "PlainCellBgView.h"
#import "PINCashModel.h"
#import "PINStoreTitleCell.h"
#import "PINCashCell.h"
#import "MJRefresh.h"

@interface PINAllOrderController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *cashArray;

@property (assign, nonatomic) BOOL isFinished;

@property (assign, nonatomic) int page;

@end

@implementation PINAllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部账单";
    [self initParams];
    [self initUI];
}

- (void)initParams {
    self.cashArray = [NSMutableArray array];
    self.page = 1;
    self.isFinished = NO;
}

- (void)initUI {
    __unsafe_unretained UITableView *tableView = self.tableview;
    weakSelf(self);
    [tableView addRefreshHeaderWithCompletion:^{
        [weakSelf drawUp];
    }];
    
    [self requestCashListWithDragup:NO];
}

- (void)requestCashListWithDragup:(BOOL)isDragup {
    
    self.page = isDragup ? (self.page + 1) : 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.httpService cashRequestWithSid:[PINUserDefaultManagement instance].sid page:self.page date:@"" finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.isFinished = YES;
        if (self.page == 1) {
            [self.cashArray removeAllObjects];
        }
        
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
    [self requestCashListWithDragup:NO];
}

- (void)drawDown {
    [self requestCashListWithDragup:YES];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (self.isFinished) {
            return self.cashArray.count > 0 ? self.cashArray.count : 1;
        }
        return 0;
    } else {
        if (self.isFinished) {
            return self.cashArray.count > 0 ? 1 : 0;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else {
        if (self.cashArray.count > 0) {
            PINCashModel *cashModel = [self.cashArray objectAtIndex:indexPath.row];
            if (cashModel.type == -1) {
                return FITHEIGHT(72);
            } else {
                return FITHEIGHT(105);
            }
        } else {
            return SCREEN_HEIGHT - 64;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 10)];
    if (section != 1) {
        view.height = 0;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cashTitleCellId = @"cashTitleCellId";
        UITableViewCell *cashTitleCell = [tableView dequeueReusableCellWithIdentifier:cashTitleCellId];
        if (cashTitleCell == nil) {
            cashTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashTitleCellId];
            cashTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cashTitleCell.textLabel.text = @"账单明细";
        cashTitleCell.textLabel.font = FontBold(fFont18);
        cashTitleCell.backgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:NO];
        return cashTitleCell;
        
    } else {
        if (self.cashArray.count == 0) {
            return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"没有账单信息"];
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
}

@end
