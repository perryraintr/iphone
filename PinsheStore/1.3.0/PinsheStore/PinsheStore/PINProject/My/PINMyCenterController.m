//
//  PINMyCenterController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINMyCenterController.h"
#import "PlainCellBgView.h"

@interface PINMyCenterController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *orderArray;

@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) NSMutableArray *otherArray;

@end

@implementation PINMyCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self initParams];
}

- (void)initParams {
    self.orderArray = [NSArray arrayWithObjects:@"查看其它日期", @"查看全部账单", nil];
    self.titleArray = [NSMutableArray array];
    self.otherArray = [NSMutableArray arrayWithObjects:@"联系客服", @"App评论", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PINUserDefaultManagement instance].hasStore) {
        self.titleArray = [NSMutableArray arrayWithObjects:@"提现", @"切换店铺", @"我的店员", @"设置店铺", @"提现账户", @"设置店铺WiFi", @"设置公众号推送内容", nil];
    } else {
        [self.titleArray removeAllObjects];
    }
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count > 0 ? self.titleArray.count : 0;
    } else if (section == 1) {
        return self.orderArray.count;
    } else if (section == 2) {
        return self.otherArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count > 0 ? 10 : 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 10)];
    if (section == 0) {
        view.height = self.titleArray.count > 0 ? 10 : 0;
    }
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
        static NSString *titleCellId = @"titleCellId";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (titleCell == nil) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId];
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSString *titleStr = [self.titleArray objectAtIndex:indexPath.row];
        titleCell.textLabel.text = titleStr;
        titleCell.textLabel.font = Font(fFont16);
        if (indexPath.row == 0) {
            titleCell.textLabel.textColor = HEXCOLOR(pinColorRed);
        } else {
            titleCell.textLabel.textColor = [UIColor blackColor];
        }
        titleCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        titleCell.selectedBackgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:indexPath.row == 0];
        
        return titleCell;
        
    } else if (indexPath.section == 1) {
        static NSString *orderCellId = @"orderCellId";
        UITableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:orderCellId];
        if (orderCell == nil) {
            orderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellId];
            orderCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSString *titleStr = [self.orderArray objectAtIndex:indexPath.row];
        orderCell.textLabel.text = titleStr;
        orderCell.textLabel.font = Font(fFont16);
        orderCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        orderCell.selectedBackgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:indexPath.row == 0];
        
        return orderCell;
        
    } else if (indexPath.section == 2) {
        static NSString *otherCellId = @"otherCellId";
        UITableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherCellId];
        if (otherCell == nil) {
            otherCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellId];
        }
        NSString *titleStr = [self.otherArray objectAtIndex:indexPath.row];
        otherCell.textLabel.text = titleStr;
        otherCell.textLabel.font = Font(fFont16);
        otherCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        otherCell.selectedBackgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:indexPath.row == 0];

        return otherCell;
        
    } else {
        static NSString *logoutCellId = @"logoutCellId";
        UITableViewCell *logoutCell = [tableView dequeueReusableCellWithIdentifier:logoutCellId];
        if (logoutCell == nil) {
            logoutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutCellId];
        }
        logoutCell.textLabel.textAlignment = NSTextAlignmentCenter;
        logoutCell.textLabel.text = @"退出登录";
        logoutCell.textLabel.font = Font(fFont16);
        logoutCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        logoutCell.selectedBackgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:indexPath.row == 0];

        return logoutCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_GETCASH_VC navigationController:self.navigationController params:nil animated:YES];
            
        } else if (indexPath.row == 1) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_STORELIST_VC navigationController:self.navigationController params:nil animated:YES];
            
        } else if (indexPath.row == 2) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_STOREMEMBER_VC navigationController:self.navigationController params:nil animated:YES];
        } else if (indexPath.row == 3) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_STORESETTING_VC navigationController:self.navigationController params:nil animated:YES];
        } else if (indexPath.row == 4) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_PAYMENTLIST_VC navigationController:self.navigationController params:nil animated:YES];
        } else if (indexPath.row == 5) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_STOREWIFI_VC navigationController:self.navigationController params:nil animated:YES];
        } else if (indexPath.row == 6) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_STOREPUSHLIST_VC navigationController:self.navigationController params:nil animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_DATEORDER_VC navigationController:self.navigationController params:nil animated:YES];
            
        } else if (indexPath.row == 1) {
            [[ForwardContainer shareInstance] pushContainer:FORWARD_ALLORDER_VC navigationController:self.navigationController params:nil animated:YES];
        }
        
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                // 联系我们
                [UIAlertView alertViewWithTitle:@"" message:@"请在微信－品社咖啡服务号中联系客服" cancel:@"确定" clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle, UIAlertView *alertview) {
                } cancelBlock:^{
                }];
            }
                break;
            case 1:
            {
                // 去评论
                PLog(@"appid = %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppID"]);
                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppID"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
                break;
            default:
                break;
        }
    } else {
        NSArray *titles = [NSArray arrayWithObjects:@"确定", nil];
        [UIAlertView alertViewWithTitle:@"" message:@"确定退出登录?" cancel:@"取消" otherButtonTitles:titles clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle, UIAlertView *alertview) {
            [self loginOut];
        } cancelBlock:^{
        }];
    }
}

#pragma mark -
#pragma mark - Button Action
// 退出
- (void)loginOut {
    [PINConstant cleanUserDefault];
    [PINAppDelegate() needLoginVC];
}

@end
