//
//  PINRootController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINRootController.h"
#import "PINUser.h"
#import "PINCashModel.h"
#import "PINCashCell.h"
#import "PINNetActivityIndicator.h"
#import "MJRefresh.h"
#import "PINStoreModel.h"
#import "PINStoreCell.h"

@interface PINRootController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *cashArray;

@property (strong, nonatomic) PINStoreModel *storeModel;

@property (assign, nonatomic) int page;

@property (strong, nonatomic) UIView *checkView;

@property (assign, nonatomic) BOOL isFinished;

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
    [self checkStore];
}

- (void)initParams {
    self.cashArray = [NSMutableArray array];
    self.page = 1;
    self.isFinished = false;
}

- (void)initUI {
    [super rightBarButton:@"退出" isRoot:YES color:HEXCOLOR(pinColorWhite) selector:@selector(loginOutAction) delegate:self];
    
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
        label.text = @"请等待品社审核，请稍后联系客服，查询审核进度...";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WITH - 20));
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-40);
        }];
        
        UIButton *checkButton = Building_UIButtonWithSuperView(_checkView, self, @selector(checkStore), [UIColor clearColor]);
        [checkButton setTitle:@"点击查看进度" forState:UIControlStateNormal];
        [checkButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
        [checkButton setBackgroundColor:HEXCOLOR(pinColorBlack)];
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

- (void)checkStore {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.httpService memberRequestWithTelphone:[PINUserDefaultManagement instance].pinUser.phone finished:^(NSDictionary *result, NSString *message) {
        [PINUserDefaultManagement instance].pinUser = [PINUser modelWithDictionary:result];
        
        [self.httpService storeRequestWithMid:[PINUserDefaultManagement instance].pinUser.guid finished:^(NSDictionary *result, NSString *message) {
            
            self.checkView.hidden = YES;
            
            self.storeModel = [PINStoreModel modelWithDictionary:result];
            [self requestCashListWithDragup:NO];
            
        } failure:^(NSDictionary *result, NSString *message) {
            
            [self addCheckView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self chatShowHint:@"等待审核"];
        }];
        
    } failure:^(NSDictionary *result, NSString *message) {
        
    }];
    
}

- (void)requestCashListWithDragup:(BOOL)isDragup {
    
    self.page = isDragup ? (self.page + 1) : 1;
    
    [self.httpService cashRequestWithSid:self.storeModel.guid page:self.page finished:^(NSDictionary *result, NSString *message) {
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
- (void)loginOutAction {
    [PINUserDefaultManagement instance].pinUser = nil;
    [PINAppDelegate() needLoginVC];
}

- (IBAction)cashAddAction:(id)sender {
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[NSNumber numberWithInt:self.storeModel.guid] forKey:@"sid"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_GETCASH_VC navigationController:self.navigationController params:paramsDic animated:true];
}

- (void)drawUp {
    [self checkStore];
}

- (void)drawDown {
    [self memberRequest];
    [self requestCashListWithDragup:YES];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
//        if (self.storeModel) {
//            return 0;
//        }
        return 0;
    } else if (section == 3) {
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
//        if (self.storeModel) {
//            return 60;
//        }
        return 0;
    } else if (indexPath.section == 2) {
        return 35;
    } else if (indexPath.section == 3) {
        if (self.cashArray.count > 0) {
            PINCashModel *cashModel = [self.cashArray objectAtIndex:indexPath.row];
            if (cashModel.type == -1) {
                return FITHEIGHT(84);
            } else {
                return FITHEIGHT(112);
            }
        } else {
            return 118;
        }
        
    } else {
        return FITHEIGHT(60);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *storeCellId = @"storeCellId";
        PINStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:storeCellId];
        if (storeCell == nil) {
            storeCell = [[PINStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellId];
            storeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        storeCell.nameLabel.text = [NSString stringWithFormat:@"店铺名称:%@", self.storeModel.name];
        storeCell.sloganLabel.text = self.storeModel.slogan;
        return storeCell;
        
    } else if (indexPath.section == 1) {
        static NSString *currentCellId = @"currentCellId";
        UITableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:currentCellId];
        if (currentCell == nil) {
            currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentCellId];
            currentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        currentCell.textLabel.text = [NSString stringWithFormat:@"余额：%.2f元", [PINUserDefaultManagement instance].pinUser.current];
        currentCell.textLabel.font = Font(fFont16);
        return currentCell;

    } else if (indexPath.section == 2) {
        static NSString *cashTitleCellId = @"cashTitleCellId";
        UITableViewCell *cashTitleCell = [tableView dequeueReusableCellWithIdentifier:cashTitleCellId];
        if (cashTitleCell == nil) {
            cashTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashTitleCellId];
            cashTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cashTitleCell.backgroundColor = HEXCOLOR(pinColorMainBackground);
        }
        cashTitleCell.textLabel.text = @"账单明细";
        cashTitleCell.textLabel.font = Font(fFont16);
        return cashTitleCell;
        
    } else if (indexPath.section == 3) {
        if (self.cashArray.count == 0) {
            static NSString *cashNullCellId = @"cashNullCellId";
            UITableViewCell *cashNullCell = [tableView dequeueReusableCellWithIdentifier:cashNullCellId];
            if (cashNullCell == nil) {
                cashNullCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashNullCellId];
                cashNullCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cashNullCell.textLabel.textAlignment = NSTextAlignmentCenter;
            cashNullCell.textLabel.text = @"啊哦，目前没有账单哦～";
            cashNullCell.textLabel.font = Font(fFont16);
            return cashNullCell;
            
        } else {
            static NSString *cashCellId = @"cashCellId";
            PINCashCell *cashCell = [tableView dequeueReusableCellWithIdentifier:cashCellId];
            if (cashCell == nil) {
                cashCell = [[PINCashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cashCellId];
            }
            [cashCell resetCashCell:[self.cashArray objectAtIndex:indexPath.row]];
            return cashCell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

@end
