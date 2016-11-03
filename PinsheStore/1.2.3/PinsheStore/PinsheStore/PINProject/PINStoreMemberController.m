//
//  PINStoreMemberController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreMemberController.h"
#import "PlainCellBgView.h"
#import "PINStoreMemberCell.h"
#import "PINStoreMemberModel.h"

@interface PINStoreMemberController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *memberArray;

@end

@implementation PINStoreMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的店员";
    [self initParams];
    [self initUI];
    [self requestStoreMember:YES];
}

- (void)initParams {
    self.memberArray = [NSMutableArray array];
}

- (void)initUI {
    [super rightBarButton:@"添加" isRoot:NO color:HEXCOLOR(pinColorWhite) selector:@selector(addMember) delegate:self];
}

- (void)requestStoreMember:(BOOL)isShow {
    
    if (isShow) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

    [self.httpService storeMemberListRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.memberArray removeAllObjects];
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINStoreMemberModel *pinStoreMemberModel = [PINStoreMemberModel modelWithDictionary:dic];
            [self.memberArray addObject:pinStoreMemberModel];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

- (void)requestAddMember:(NSString *)telphone {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    weakSelf(self);
    [self.httpService addMemberWithTelphone:telphone finished:^(NSDictionary *result, NSString *message) {
        
        // 添加一个用户，获取id
        [weakSelf requestAddStoreMember:[[result objectForKey:@"guid"] intValue]];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    }];
}

- (void)requestRemoveMember:(int)guid indexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    weakSelf(self);
    [self.httpService removeStoreMemberWithGuid:guid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        //删除数据模型
        [self.memberArray removeObjectAtIndex:indexPath.row];
        //刷新界面
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    }];
}

- (void)requestAddStoreMember:(int)mid {
    weakSelf(self);
    [self.httpService addStoreMemberWithMid:mid sid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        
        [weakSelf requestStoreMember:NO];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf chatShowHint:@"添加店员失败"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberArray.count > 0 ? self.memberArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.memberArray.count > 0) {
        return FITHEIGHT(55);
//        PINStoreMemberModel *pinStoreMemberModel = [self.memberArray objectAtIndex:indexPath.row];
//        if (pinStoreMemberModel.member_avatar.length == 0) {
//            return FITHEIGHT(55);
//        } else {
//            return FITHEIGHT(70);
//        }
    } else {
        return SCREEN_HEIGHT - 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.memberArray.count > 0) {
        static NSString *storeMemberCellId = @"storeCellId";
        PINStoreMemberCell *storeMemberCell = [tableView dequeueReusableCellWithIdentifier:storeMemberCellId];
        if (storeMemberCell == nil) {
            storeMemberCell = [[PINStoreMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeMemberCellId];
        }
        PINStoreMemberModel *pinStoreMemberModel = [self.memberArray objectAtIndex:indexPath.row];
        [storeMemberCell resetStoreMemberCell:pinStoreMemberModel];
        storeMemberCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        return storeMemberCell;
        
    } else {
       return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"暂无店员"];
    }
}

#pragma mark 删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titles = [NSArray arrayWithObjects:@"确定", nil];
    weakSelf(self);
    [UIAlertView alertViewWithTitle:@"删除店员" message:@"你确定删除该店员？" cancel:@"取消" otherButtonTitles:titles clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle, UIAlertView *alertview) {
        
        PINStoreMemberModel *pinStoreMemberModel = [self.memberArray objectAtIndex:indexPath.row];
        
        [weakSelf requestRemoveMember:pinStoreMemberModel.guid indexPath:indexPath];
        
    } cancelBlock:^{
        
    }];
}

- (void)addMember {
    NSArray *titles = [NSArray arrayWithObjects:@"确定", nil];

    weakSelf(self);
    [UIAlertView alertViewWithTitle:@"添加店员" message:@"" cancel:@"取消" otherButtonTitles:titles placeholder:@"输入中国11位手机号" clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle, UIAlertView *alertview) {
        
        [[super findFirstResponder] resignFirstResponder];
        UITextField *nameField = [alertview textFieldAtIndex:0];
        
        if (!validateMobile(nameField.text)) {
            [weakSelf chatShowHint:@"请输入正确的手机号码"];
            return;
        }
        
        PLog(@"nameField = %@", nameField.text);
        [weakSelf requestAddMember:nameField.text];
        
    } cancelBlock:^{
        [[super findFirstResponder] resignFirstResponder];

    }];
}

@end
