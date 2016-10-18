//
//  PINLoginController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/9.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINLoginController.h"
#import "PINLoginCell.h"
#import "PINUser.h"

@interface PINLoginController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *nameArray;

@property (strong, nonatomic) NSString *telphone;

@property (strong, nonatomic) NSString *password;

@end

@implementation PINLoginController

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

- (void)initParams {
    self.telphone = [PINUserDefaultManagement instance].phone ? : @"";
    self.nameArray = [NSMutableArray arrayWithObjects:@"手机号", @"密码", nil];
}

- (void)initUI {
}

#pragma mark -
#pragma mark - Button Action
- (void)loginAction {
    PLog(@"%@, %@", self.telphone, self.password);
    [[super findFirstResponder] resignFirstResponder];

    if (!validateMobile(self.telphone)) {
        [self chatShowHint:@"请输入正确的手机号码"];
        return;
    }
    
    if (self.password.length == 0 || self.password.length < 6) {
        [self chatShowHint:@"密码至少6位以上"];
        return;
    }
    
    [self.httpService loginRequestWithTelphone:self.telphone password:self.password finished:^(NSDictionary *result, NSString *message) {
        
        [PINUserDefaultManagement instance].pinUser = [PINUser modelWithDictionary:result];
        [PINUserDefaultManagement instance].phone = [PINUserDefaultManagement instance].pinUser.phone;
        
        [PINAppDelegate() rootVC];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [self chatShowHint:@"密码或者验证码错误"];
    }];
}

- (void)registerAction {
    [[super findFirstResponder] resignFirstResponder];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_REGISTER_VC navigationController:self.navigationController params:nil animated:YES];
}

- (void)forgetAction {
    [[super findFirstResponder] resignFirstResponder];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_FORGET_VC navigationController:self.navigationController params:nil animated:YES];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.nameArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_HEIGHT / 2.0 - FITHEIGHT(200);
    } else if (indexPath.section == 1) {
        return FITHEIGHT(56);
    } else {
        return FITHEIGHT(100) + 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        static NSString *loginCellId = @"loginCellId";
        PINLoginCell *loginCell = [tableView dequeueReusableCellWithIdentifier:loginCellId];
        if (loginCell == nil) {
            loginCell = [[PINLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loginCellId];
        }
        loginCell.clipsToBounds = YES;
        loginCell.nameTextField.tag = 1000 + indexPath.row;
        loginCell.nameTextField.kbMoving.kbMovingView = self.tableview;
        [self setCellFieldWithLogin:loginCell withTableView:tableView withIndexPath:indexPath];
        return loginCell;
    } else if (indexPath.section == 2) {
        static NSString *buttonCellId = @"cellId";
        UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonCellId];
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellId];
            buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *loginButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(loginAction), [UIColor clearColor]);
            [loginButton setTitle:@"登录" forState:UIControlStateNormal];
            loginButton.titleLabel.font = Font(fFont16);
            [loginButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [loginButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
            loginButton.layer.cornerRadius = 5;
            loginButton.layer.masksToBounds = YES;
            [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.top.equalTo(buttonCell.contentView).offset(FITHEIGHT(50));
                make.width.equalTo(@((SCREEN_WITH - 60) / 2.0));
                make.height.equalTo(@(FITHEIGHT(50)));
            }];
            
            UIButton *registerButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(registerAction), [UIColor clearColor]);
            [registerButton setTitle:@"注册" forState:UIControlStateNormal];
            registerButton.titleLabel.font = Font(fFont16);
            [registerButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [registerButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
            registerButton.layer.cornerRadius = 5;
            registerButton.layer.masksToBounds = YES;
            [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(loginButton.mas_right).offset(20);
                make.top.equalTo(buttonCell.contentView).offset(FITHEIGHT(50));
                make.width.equalTo(@((SCREEN_WITH - 60) / 2.0));
                make.height.equalTo(@(FITHEIGHT(50)));
            }];
            
            UIButton *forgetButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(forgetAction), [UIColor clearColor]);
            [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
            forgetButton.titleLabel.font = Font(fFont16);
            [forgetButton setTitleColor:HEXCOLOR(pinColorTextLightGray) forState:UIControlStateNormal];
            [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(buttonCell.contentView).offset(-20);
                make.top.equalTo(registerButton.mas_bottom).offset(5);
                make.height.equalTo(@(30));
            }];
        }
        return buttonCell;
    } else {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)setCellFieldWithLogin:(PINLoginCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.nameTextField.delegate = self;
    cell.nameLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.nameTextField.placeholder = @"请输入11位中国手机号";
        cell.nameTextField.returnKeyType = UIReturnKeyNext;
        cell.nameTextField.text = self.telphone;
    } else {
        cell.nameTextField.placeholder = @"请输入6位及以上密码";
        cell.nameTextField.returnKeyType = UIReturnKeyDone;
        cell.nameTextField.secureTextEntry = YES;
        cell.nameTextField.text = self.password;
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
        self.telphone = textValue;
    } else if (textField.tag == 1001) {
        self.password = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1000) {
        PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1001) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.telphone = textField.text;
    } else if (textField.tag == 1001) {
        self.password = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.telphone = @"";
    } else if (textField.tag == 1001) {
        self.password = @"";
    }
    return YES;
}

@end