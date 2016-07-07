//
//  SystemSettingController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/18.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "SystemSettingController.h"
#import "SystemSettingCell.h"
#import "PinTabBarController.h"
#import <MessageUI/MessageUI.h>

@interface SystemSettingController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *nameArray;

@end

@implementation SystemSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.title = @"系统设置";
    [self initParams];
    [self initUI];
}

- (void)initParams {
    self.nameArray = @[@"版本号", @"App评分", @"我要吐槽"];
}

- (void)initUI {
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

#pragma mark - Request
- (void)addUserRequest {
    weakSelf(self);
    [self.httpService addUserRequestWithIndicatorStyle:PinIndicatorStyle_DefaultIndicator finished:^(NSDictionary *result, NSString *message) {
        [PINBaseRefreshSingleton instance].refreshCompare = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshShit = 1;
        
        [UserDefaultManagement instance].pinUser = nil;
        [UserDefaultManagement instance].userId = [[result objectForKey:@"guid"] intValue];
        [UserDefaultManagement instance].haveUserId = YES;
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        pinTabBarController().selectedIndex = 0;

    } failure:^(NSDictionary *result, NSString *message) {
    }];
}

#pragma mark -
#pragma mark AFNetworking
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.nameArray.count) {
        return FITHEIGHT(60);
    } else {
        return FITHEIGHT(44);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.nameArray.count) {
        static NSString *loginOutCellId = @"loginOutCellId";
        UITableViewCell *loginOutCell = [tableView dequeueReusableCellWithIdentifier:loginOutCellId];
        if (!loginOutCell) {
            loginOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loginOutCellId];
            loginOutCell.selectionStyle = UITableViewCellSelectionStyleNone;
            loginOutCell.backgroundColor = [UIColor clearColor];
            UIButton *button = Building_UIButtonWithFrameAndSuperView(loginOutCell.contentView, CGRectMake((SCREEN_WITH - FITWITH(390)) / 2.0, FITHEIGHT(20), FITWITH(390), FITHEIGHT(40)), self, @selector(loginOut), HEXCOLOR(0xc73030));
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            button.titleLabel.font = Font(fFont14);
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
        }
        return loginOutCell;
    } else {
        static NSString *systemSettingCellId = @"systemSettingCellId";
        SystemSettingCell *systemSettingCell = [tableView dequeueReusableCellWithIdentifier:systemSettingCellId];
        if (!systemSettingCell) {
            systemSettingCell = [[[NSBundle mainBundle] loadNibNamed:@"SystemSettingCell" owner:self options:nil] objectAtIndex:0];
        }
        systemSettingCell.nameLabel.text = [self.nameArray objectAtIndex:indexPath.row];
        systemSettingCell.arrowImageview.hidden = NO;
        systemSettingCell.versionLabel.hidden = YES;
        if (indexPath.row == 0) {
            systemSettingCell.arrowImageview.hidden = YES;
            systemSettingCell.versionLabel.hidden = NO;
            systemSettingCell.versionLabel.text = SystemVersion;
        }
        systemSettingCell.backgroundView = [[GroupedCellBgView alloc] initWithFrame:systemSettingCell.frame withDataSourceCount:self.nameArray.count withIndex:indexPath.row isSelected:NO];
        systemSettingCell.selectedBackgroundView = [[GroupedCellBgView alloc] initWithFrame:systemSettingCell.frame withDataSourceCount:self.nameArray.count withIndex:indexPath.row isSelected:indexPath.row != 0];
        return systemSettingCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        [NSObject event:@"ST001" label:@"App评分"];

        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppID"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    } else if (indexPath.row == 2) {
        [NSObject event:@"ST002" label:@"我要吐槽"];
        [self sendEmail];
    }
}

- (void)sendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObject: @"feedback@raintr.com"];
        [mailPicker setToRecipients: toRecipients];
        //设置主题
        [mailPicker setSubject: @"我要吐槽"];
        [self presentViewController:mailPicker animated:YES completion:nil];
    } else {
        NSString *recipients = @"mailto:feedback@raintr.com";
        NSString *body = @"我要吐槽";
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            [NSObject event:@"ST003" label:@"吐槽失败"];
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    PLog(@" asdajsd ==== %@", msg);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginOut {
    [NSObject event:@"ST004" label:@"退出登录"];
    [self addUserRequest];
}

@end
