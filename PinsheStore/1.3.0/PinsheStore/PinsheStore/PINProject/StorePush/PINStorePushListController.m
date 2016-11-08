//
//  PINStorePushListController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStorePushListController.h"
#import "PlainCellBgView.h"
#import "PINStorePushModel.h"
#import "PINStorePushListCell.h"

@interface PINStorePushListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *storePushArray;

@end

@implementation PINStorePushListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置推送内容";
    [self initParams];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestStorePush];
}

- (void)initParams {
    self.storePushArray = [NSMutableArray array];
}

- (void)requestStorePush {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.httpService storePushListRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.storePushArray removeAllObjects];
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINStorePushModel *model = [PINStorePushModel modelWithDictionary:dic];
            [self.storePushArray addObject:model];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)requestRemoveMember:(int)guid indexRow:(NSUInteger)indexRow {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    weakSelf(self);
    [self.httpService storePushRemoveRequestWithGuid:guid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        //删除数据模型
        [self.storePushArray removeObjectAtIndex:indexRow];
        //刷新界面
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
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
    return self.storePushArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 60;
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
        paymentAddCell.textLabel.text = @"创建推送内容";
        paymentAddCell.textLabel.font = Font(fFont16);
        paymentAddCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        return paymentAddCell;
    }
    else {
        static NSString *storePushListCellId = @"storePushListCellId";
        PINStorePushListCell *storePushListCell = [tableView dequeueReusableCellWithIdentifier:storePushListCellId];
        if (!storePushListCell) {
            storePushListCell = [[[NSBundle mainBundle] loadNibNamed:@"PINStorePushListCell" owner:self options:nil] objectAtIndex:0];
        }
        PINStorePushModel *model = [self.storePushArray objectAtIndex:indexPath.row];
        storePushListCell.nameLabel.text = model.name;
        [storePushListCell.pushImageview sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
        storePushListCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        return storePushListCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (self.storePushArray.count >= 2) {
            [self chatShowHint:@"推送内容只允许设置2个"];
            return;
        }
        [[ForwardContainer shareInstance] pushContainer:FORWARD_STOREPUSH_VC navigationController:self.navigationController params:nil animated:YES];
    } else {
        PINStorePushModel *model = [self.storePushArray objectAtIndex:indexPath.row];
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:model.name forKey:@"title"];
        [paramDic setObject:model.url forKey:@"loadUrl"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_WEBVIEW_VC navigationController:self.navigationController params:paramDic animated:YES];
    }
}

#pragma mark 删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    [self removeMember:indexPath.row];
}

- (void)removeMember:(NSUInteger)indexRow {
    NSArray *titles = [NSArray arrayWithObjects:@"确定", nil];
    weakSelf(self);
    [UIAlertView alertViewWithTitle:@"删除推送内容" message:@"你确定删除该推送内容？" cancel:@"取消" otherButtonTitles:titles clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle, UIAlertView *alertview) {
        
        PINStorePushModel *storePushModel = [self.storePushArray objectAtIndex:indexRow];
        
        [weakSelf requestRemoveMember:storePushModel.guid indexRow:indexRow];
        
    } cancelBlock:^{
        
    }];
}

@end
