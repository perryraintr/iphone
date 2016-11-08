//
//  PINStoreWiFiController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreWiFiController.h"
#import "PlainCellBgView.h"
#import "PINStoreModel.h"
#import "PINTextFiledCell.h"

@interface PINStoreWiFiController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSString *wifiStr;

@property (strong, nonatomic) NSString *wifi_password;

@end

@implementation PINStoreWiFiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置WiFi";
    [self requestDetail];
}

- (void)requestDetail {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.httpService storeInfoRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        PINStoreModel *pinStoreModel = [PINStoreModel modelWithDictionary:result];
        self.wifiStr = pinStoreModel.wifi;
        self.wifi_password = pinStoreModel.wifi_password;
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self chatShowHint:@"请求失败"];
    }];
}

- (void)buttonAction {
    [[self findFirstResponder] resignFirstResponder];

    if (self.wifiStr.length == 0) {
        [self chatShowHint:@"请输入WiFi账户"];
        return;
    }
    
    if (self.wifi_password.length == 0) {
        [self chatShowHint:@"请输入WiFi密码"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.httpService storeWifiModifyRequestWithSid:[PINUserDefaultManagement instance].sid wifi:self.wifiStr wifi_password:self.wifi_password finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"保存成功"];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"保存失败"];
    }];
    
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else {
        return FITHEIGHT(50);
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
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 10));
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *textFiledCellId = @"textFiledCellId";
        PINTextFiledCell *textFiledCell = [tableView dequeueReusableCellWithIdentifier:textFiledCellId];
        if (textFiledCell == nil) {
            textFiledCell = [[PINTextFiledCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textFiledCellId];
        }
        textFiledCell.nameTextField.tag = 1000 + indexPath.row;
        textFiledCell.nameTextField.kbMoving.kbMovingView = self.tableview;
        textFiledCell.nameTextField.delegate = self;
        [self setCellFieldWithCell:textFiledCell withTableView:tableView withIndexPath:indexPath];
        textFiledCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        return textFiledCell;
        
    } else {
        static NSString *buttonCellId = @"cellId";
        UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonCellId];
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellId];
            buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            buttonCell.backgroundColor = HEXCOLOR(pinColorMainBackground);
            
            UIButton *button = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(buttonAction), [UIColor clearColor]);
            [button setTitle:@"保存" forState:UIControlStateNormal];
            button.titleLabel.font = FontNotSou(fFont16);
            [button setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [button setBackgroundColor:HEXCOLOR(pinColorGreen)];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.right.equalTo(buttonCell.contentView).offset(-20);
                make.top.bottom.equalTo(buttonCell.contentView);
            }];
        }
        return buttonCell;
    }
}

- (void)setCellFieldWithCell:(PINTextFiledCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"WiFi账号";
        cell.nameTextField.placeholder = @"请填写WiFi账号";
        cell.nameTextField.returnKeyType = UIReturnKeyNext;
        cell.nameTextField.text = self.wifiStr;
    } else if (indexPath.row == 1) {
        cell.nameLabel.text = @"WiFi密码";
        cell.nameTextField.placeholder = @"请填写WiFi密码";
        cell.nameTextField.returnKeyType = UIReturnKeyDone;
        cell.nameTextField.text = self.wifi_password;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *inputText = [NSMutableString stringWithFormat:@"%@",textField.text];
    
    NSString *textValue = getTrimString(inputText);
    if (textField.tag == 1000) {
        self.wifiStr = textValue;
    } else if (textField.tag == 1001) {
        self.wifi_password = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1000) {
        PINTextFiledCell *cell = (PINTextFiledCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1001) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.wifiStr = textField.text;
    } else if (textField.tag == 1001) {
        self.wifi_password = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.wifiStr = @"";
    } else if (textField.tag == 1001) {
        self.wifi_password = @"";
    }
    return YES;
}

@end
