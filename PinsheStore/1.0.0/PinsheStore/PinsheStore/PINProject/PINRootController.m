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
#import "PINNetActivityIndicator.h"
#import "MJRefresh.h"
#import "PINStoreModel.h"
#import "PINStoreCell.h"
#import "PINStoreTitleCell.h"

@interface PINRootController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *cashArray;

@property (strong, nonatomic) NSMutableArray *storeArray;

@property (assign, nonatomic) int page;

@property (strong, nonatomic) UIView *checkView;

@property (assign, nonatomic) BOOL isFinished;

@property (assign, nonatomic) float storeAmount;

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
    [self checkStore:NO];
}

- (void)initParams {
    self.cashArray = [NSMutableArray array];
    self.storeArray = [NSMutableArray array];
    self.page = 1;
    self.isFinished = false;
}

- (void)initUI {
    __unsafe_unretained UITableView *tableView = self.tableview;
    weakSelf(self);
    [tableView addRefreshHeaderWithCompletion:^{
        [weakSelf drawUp];
    }];
}

- (UIView *)addCheckView {
    if (!_checkView) {
        _checkView = Building_UIViewWithSuperView(self.view);
        _checkView.backgroundColor = HEXCOLOR(pinColorWhite);
        [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
        [_checkView bringSubviewToFront:self.view];
        
        UILabel *label = Building_UILabelWithSuperView(_checkView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentCenter, 0);
        label.text = @"你还未加入品社咖啡馆！如果你是咖啡馆长，请联系品社客服；如果你是店员，请联系你的馆长。";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WITH - 20));
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-40);
        }];
        
        UIButton *checkButton = Building_UIButtonWithSuperView(_checkView, self, @selector(drawUp), [UIColor clearColor]);
        [checkButton setTitle:@"点击查看进度" forState:UIControlStateNormal];
        [checkButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
        [checkButton setBackgroundColor:HEXCOLOR(pinColorDarkBlack)];
        checkButton.titleLabel.font = Font(fFont14);
        checkButton.layer.masksToBounds = YES;
        checkButton.layer.cornerRadius = 5;
        
        [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(40);
            make.width.equalTo(@(100));
            make.height.equalTo(@(30));
        }];
    }
    return _checkView;
}

- (void)removeCheckView {
    self.checkView.hidden = YES;
    self.checkView = nil;
    [self.checkView removeFromSuperview];
}

#pragma mark -
#pragma mark - request
- (void)memberRequest {
    [self.httpService memberRequestWithTelphone:[PINUserDefaultManagement instance].pinUser.phone finished:^(NSDictionary *result, NSString *message) {
        [PINUserDefaultManagement instance].pinUser = [PINUser modelWithDictionary:result];
        
    } failure:^(NSDictionary *result, NSString *message) {
        
    }];
}

- (void)requestStoreAmount {
    [self.httpService storeAmountRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        
        self.storeAmount = [[result objectForKey:@"amount"] floatValue];
        [self.tableview reloadData];
    } failure:^(NSDictionary *result, NSString *message) {
        
    }];
}

- (void)checkStore:(BOOL)isDragUp {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 先请求用户id是否改变
    [self.httpService memberRequestWithTelphone:[PINUserDefaultManagement instance].pinUser.phone finished:^(NSDictionary *result, NSString *message) {
        [PINUserDefaultManagement instance].pinUser = [PINUser modelWithDictionary:result];
        
        // 是否是店长
        [self.httpService storeRequestWithMid:[PINUserDefaultManagement instance].pinUser.guid finished:^(NSDictionary *result, NSString *message) {
            [PINUserDefaultManagement instance].hasStore = YES;
            [PINUserDefaultManagement instance].isSotreMember = NO;

            [self removeCheckView];
            [self.storeArray removeAllObjects];
            
            for (NSDictionary *dic in [result objectForKey:@"array"]) {
                PINStoreModel *storeModel = [PINStoreModel modelWithDictionary:dic];
                [self.storeArray addObject:storeModel];
            }

            // 没有选择咖啡馆退出了，再打开时默认第一家咖啡馆
            if ([PINUserDefaultManagement instance].sid == 0) {
                if (self.storeArray.count > 0) {
                    [PINUserDefaultManagement instance].sid = ((PINStoreModel *)self.storeArray[0]).guid;
                    [PINUserDefaultManagement instance].storeName = ((PINStoreModel *)self.storeArray[0]).name
                    ;
                }
            }
            [self requestStoreAmount];
            [self requestCashListWithDragup:isDragUp];
            
        } failure:^(NSDictionary *result, NSString *message) {
            [self checkStoreMember:isDragUp];

        }];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"用户请求失败"];
    }];
    
}

// 是否是店员
- (void)checkStoreMember:(BOOL)isDragUp {
    [self.httpService storeMemberRequestWithMid:[PINUserDefaultManagement instance].pinUser.guid finished:^(NSDictionary *result, NSString *message) {
        // 是店员
        [PINUserDefaultManagement instance].isSotreMember = YES;
        [PINUserDefaultManagement instance].hasStore = NO;
        [self removeCheckView];
    
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            [PINUserDefaultManagement instance].sid = [[dic objectForKey:@"store_guid"] intValue];
            [PINUserDefaultManagement instance].storeName = [dic objectForKey:@"store_name"];
            break;
        }
        
        [self requestStoreAmount];
        [self requestCashListWithDragup:isDragUp];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [PINUserDefaultManagement instance].hasStore = NO;
        [PINUserDefaultManagement instance].isSotreMember = NO;

        [self addCheckView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"等待审核"];
    }];
}

- (void)requestCashListWithDragup:(BOOL)isDragup {
    
    self.page = isDragup ? (self.page + 1) : 1;
    
    [self.httpService cashRequestWithSid:[PINUserDefaultManagement instance].sid page:self.page finished:^(NSDictionary *result, NSString *message) {
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
        [self.tableview endRefreshing];
        [self.tableview reloadData];
        if (self.page > 1) {
            self.page -= 1;
            [self chatShowHint:@"没有更多记录"];
        }
    }];
}

#pragma mark -
#pragma mark - Button Action
- (void)drawUp {
    [self checkStore:NO];
}

- (void)drawDown {
    [self checkStore:YES];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (self.isFinished) {
            return self.cashArray.count > 0 ? self.cashArray.count : 1;
        }
        return 0;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 35;
    } else if (indexPath.section == 2) {
        if (self.cashArray.count > 0) {
            PINCashModel *cashModel = [self.cashArray objectAtIndex:indexPath.row];
            if (cashModel.type == -1) {
                return FITHEIGHT(75);
            } else {
                return FITHEIGHT(110);
            }
        } else {
            return 118;
        }
    } else {
        return FITHEIGHT(80);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 10)];
    if (section != 2) {
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
       pinStoreTitleCell.nameLabel.text = [PINUserDefaultManagement instance].storeName;
       pinStoreTitleCell.amountLabel.text = [NSString stringWithFormat:@"余额：%.2f元", self.storeAmount];
       pinStoreTitleCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];

       return pinStoreTitleCell;

    } else if (indexPath.section == 1) {
        static NSString *cashTitleCellId = @"cashTitleCellId";
        UITableViewCell *cashTitleCell = [tableView dequeueReusableCellWithIdentifier:cashTitleCellId];
        if (cashTitleCell == nil) {
            cashTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashTitleCellId];
            cashTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cashTitleCell.textLabel.text = @"账单明细";
        cashTitleCell.textLabel.font = Font(fFont16);
        cashTitleCell.backgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:NO];
        return cashTitleCell;
        
    } else if (indexPath.section == 2) {
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
