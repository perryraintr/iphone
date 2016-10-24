//
//  PINDateOrderController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/10/19.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINDateOrderController.h"
#import "PlainCellBgView.h"
#import "PINCashModel.h"
#import "PINStoreTitleCell.h"
#import "PINCashCell.h"
#import "MJRefresh.h"
#import "PINTodayCell.h"

@interface PINDateOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UITextField *dateTextFiled;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSMutableArray *cashArray;

@property (assign, nonatomic) BOOL isFinished;

@property (assign, nonatomic) int page;

@property (assign, nonatomic) float storeAmount;

@property (assign, nonatomic) int storeCount;

@end

@implementation PINDateOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日期账单";
    [self initParams];
    [self initUI];
}

- (void)initParams {
    self.cashArray = [NSMutableArray array];
    self.page = 1;
    self.isFinished = NO;
    self.storeCount = 0;
    self.storeAmount = 0;
}

- (void)initUI {
    __unsafe_unretained UITableView *tableView = self.tableview;
    weakSelf(self);
    [tableView addRefreshHeaderWithCompletion:^{
        [weakSelf drawUp];
    }];
    
    self.searchButton.layer.cornerRadius = 5;
    self.searchButton.layer.masksToBounds = YES;
}

- (void)requestCashListWithDragup:(BOOL)isDragup {
    
    self.page = isDragup ? (self.page + 1) : 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.httpService cashRequestWithSid:[PINUserDefaultManagement instance].sid page:self.page date:self.dateTextFiled.text finished:^(NSDictionary *result, NSString *message) {
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
    [self requestCashListWithDragup:NO];
}

- (void)drawDown {
    [self requestCashListWithDragup:YES];
}

- (IBAction)searchButtonAction:(id)sender {
    [[super findFirstResponder] resignFirstResponder];
    
    if (self.dateTextFiled.text.length == 0) {
        [self chatShowHint:@"请输入查询日期"];
        return;
    }
    
    if (self.dateTextFiled.text.length != 8 || !validateNumber(self.dateTextFiled.text)) {
        [self chatShowHint:@"输入正确格式的日期"];
        return;
    }
    
    [self requestCashListWithDragup:NO];

}


#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
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
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 40;
    } else if (indexPath.section == 1) {
        return 105;
    } else {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 10)];
    if (section != 3) {
        view.height = 0;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
        
    } else if (indexPath.section == 1) {
        static NSString *pinTodayCellId = @"pinTodayCellId";
        PINTodayCell *pinTodayCell = [tableView dequeueReusableCellWithIdentifier:pinTodayCellId];
        if (pinTodayCell == nil) {
            pinTodayCell = [[PINTodayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pinTodayCellId];
        }

        pinTodayCell.dateLabel.hidden = YES;
        pinTodayCell.dateLabel.text = @"";
        pinTodayCell.amountLabel.attributedText = getAttributedString(@"品社订单收入: ", pinColorDarkBlack, [NSString stringWithFormat:@"%.2f元", self.storeAmount], pinColorDarkBlack, fFont16, fFont18, YES);
        
        pinTodayCell.countLabel.attributedText = getAttributedString(@"品社订单笔数: ", pinColorDarkBlack, [NSString stringWithFormat:@"%zd笔", self.storeCount], pinColorDarkBlack, fFont16, fFont18, YES);
        
        pinTodayCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
        
        return pinTodayCell;
        
    } else if (indexPath.section == 2) {
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
        
    } else {
        if (self.cashArray.count == 0) {
            return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"没有账单"];
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
