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
    self.titleArray = [NSMutableArray array];
    self.otherArray = [NSMutableArray arrayWithObjects:@"联系客服", @"App评论", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PINUserDefaultManagement instance].hasStore) {
        self.titleArray = [NSMutableArray arrayWithObjects:@"提现", @"切换店铺", @"我的店员", nil];
    } else {
        [self.titleArray removeAllObjects];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count > 0 ? self.titleArray.count : 0;
    } else if (section == 1) {
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
        titleCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        titleCell.selectedBackgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:indexPath.row == 0];

        return titleCell;

    } else if (indexPath.section == 1) {
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
        }
    } else if (indexPath.section == 1) {
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
    [PINUserDefaultManagement instance].sid = 0;
    [PINUserDefaultManagement instance].storeName = @"";
    [PINUserDefaultManagement instance].storeCurrent = 0;
    [PINUserDefaultManagement instance].pinUser = nil;
    [PINAppDelegate() needLoginVC];
}

@end
