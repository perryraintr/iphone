//
//  PINPaymentListController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINPaymentListController.h"
#import "PlainCellBgView.h"
#import "PINPaymentModel.h"
#import "PINPaymentListCell.h"

@interface PINPaymentListController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *paymentArray;

@end

@implementation PINPaymentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现账户";
    [self initParams];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestPayment];
}

- (void)initParams {
    self.paymentArray = [NSMutableArray array];
}

- (void)initUI {
    
}

- (void)requestPayment {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.httpService paymentListRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.paymentArray removeAllObjects];
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINPaymentModel *model = [PINPaymentModel modelWithDictionary:dic];
            [self.paymentArray addObject:model];
        }
        
        [self.tableview reloadData];
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.paymentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 65;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 10));
    return view;
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
        view.height = 10;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *paymentAddCellId = @"paymentAddCellId";
        UITableViewCell *paymentAddCell = [tableView dequeueReusableCellWithIdentifier:paymentAddCellId];
        if (paymentAddCell == nil) {
            paymentAddCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paymentAddCellId];
        }
        paymentAddCell.textLabel.text = @"创建账户";
        paymentAddCell.textLabel.font = Font(fFont16);
        paymentAddCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        return paymentAddCell;
    } else {
        static NSString *paymentListCellId = @"paymentListCellId";
        PINPaymentListCell *paymentListCell = [tableView dequeueReusableCellWithIdentifier:paymentListCellId];
        if (!paymentListCell) {
            paymentListCell = [[[NSBundle mainBundle] loadNibNamed:@"PINPaymentListCell" owner:self options:nil] objectAtIndex:0];
        }
        PINPaymentModel *model = [self.paymentArray objectAtIndex:indexPath.row];
        paymentListCell.holderLabel.text = model.holder;
        paymentListCell.companyLabel.text = model.company;
        paymentListCell.accountLabel.text = model.account;
        paymentListCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        paymentListCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return paymentListCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        
        [[ForwardContainer shareInstance] pushContainer:FORWARD_PAYMENT_VC navigationController:self.navigationController params:nil animated:YES];
    } else {
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        PINPaymentModel *model = [self.paymentArray objectAtIndex:indexPath.row];
        [paramDic setObject:model forKey:@"pymentModel"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_PAYMENT_VC navigationController:self.navigationController params:paramDic animated:YES];
    }
}

@end
