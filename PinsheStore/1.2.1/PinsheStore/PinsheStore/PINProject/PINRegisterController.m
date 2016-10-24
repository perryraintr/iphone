//
//  PINRegisterController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINRegisterController.h"
#import "PINLoginCell.h"
#import "PINCaptchaView.h"

#define TIME_INTERVAL 60

@interface PINRegisterController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *nameArray;

@property (strong, nonatomic) NSString *telphone;

@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *telMsgCode;

@property (strong, nonatomic) NSString *picMsgCode;

@property (strong, nonatomic) NSString *validateStr;

@property (assign, nonatomic) int time;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation PINRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家注册";
    [self initParams];
    [self initUI];
    if (PINAppDelegate().networkType == PINNetworkType_None) {
        [self chatShowHint:@"网络不给力"];
        return;
    }
}

- (void)initParams {
    self.nameArray = [NSMutableArray arrayWithObjects:@"手机号", @"图形验证码", @"短信验证码", @"密码", nil];
    self.validateStr = @"发送验证码";
}

#pragma mark -
#pragma mark - Button Action
- (void)registerAction {
    PLog(@"%@, %@, %@", self.telphone, self.telMsgCode, self.password);
    [[super findFirstResponder] resignFirstResponder];
    
    if (!validateMobile(self.telphone)) {
        [self chatShowHint:@"请输入正确的手机号码"];
        return;
    }
    
    
    PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    PLog(@"图形验证码: %@", [cell.pinCaptChaview.changeString lowercaseString]);
    
    if (self.picMsgCode.length == 0 || ![[self.picMsgCode lowercaseString] isEqualToString:[cell.pinCaptChaview.changeString lowercaseString]]) {
        [self chatShowHint:@"请输入正确的图形验证码"];
        return;
    }
    
    if (self.telMsgCode.length == 0 || self.telMsgCode.length < 6) {
        [self chatShowHint:@"请填写正确的短信验证码"];
        return;
    }
    
    if (self.password.length == 0 || self.password.length < 6) {
        [self chatShowHint:@"密码至少6位以上"];
        return;
    }
    
    [self.httpService registerRequestWithTelphone:self.telphone code:self.telMsgCode password:self.password finished:^(NSDictionary *result, NSString *message) {
        
        [PINUserDefaultManagement instance].phone = self.telphone;
        [self.httpService wechatSendWithMessage:[NSString stringWithFormat:@"有商家注册了，请审核该商品对应的咖啡馆，进行关联，手机号为：%@，\n 用户id为：%zd", self.telphone, [[result objectForKey:@"guid"] intValue]]];
        [super backAction];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [self chatShowHint:@"注册失败"];
    }];
}

- (void)requestSendMsg {
    if (!validateMobile(self.telphone)) {
        [self chatShowHint:@"请输入正确的手机号码"];
        return;
    }
    
    PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    PLog(@"图形验证码: %@", [cell.pinCaptChaview.changeString lowercaseString]);
    
    if (self.picMsgCode.length == 0 || ![[self.picMsgCode lowercaseString] isEqualToString:[cell.pinCaptChaview.changeString lowercaseString]]) {
        [self chatShowHint:@"请输入正确的图形验证码"];
        return;
    }
    
    [self.httpService sendMsgRequestWithPhone:self.telphone finished:^(NSDictionary *result, NSString *message) {
        
        [self beginCountingDown];
    } failure:^(NSDictionary *result, NSString *message) {
        [self chatShowHint:@"发送验证码失败，请稍后再试"];
    }];
}

- (void)resendMsgCode {
    [[self findFirstResponder] resignFirstResponder];
    [self requestSendMsg];
}

- (void)beginCountingDown {
    PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    self.time = TIME_INTERVAL;
    cell.codeButton.enabled = NO;
    SAFERELEASE_TIMER(self.timer);
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(reciprocal) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.validateStr = [NSString stringWithFormat:@"%d秒后重发", self.time];
    [cell.codeButton setTitle:self.validateStr forState:UIControlStateNormal];
    [cell.codeButton setTitle:self.validateStr forState:UIControlStateDisabled];
}

- (void)reciprocal {
    PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    cell.codeButton.enabled = NO;
    self.time--;
    if (self.time <= 0) {
        SAFERELEASE_TIMER(self.timer);
        cell.codeButton.enabled = YES;
        self.validateStr = @"重新发送";
    } else {
        self.validateStr = [NSString stringWithFormat:@"%d秒后重发", self.time];
    }
    [cell.codeButton setTitle:self.validateStr forState:UIControlStateNormal];
    [cell.codeButton setTitle:self.validateStr forState:UIControlStateDisabled];
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
        return FITHEIGHT(110);
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
            
            UIButton *registerButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(registerAction), [UIColor clearColor]);
            [registerButton setTitle:@"注册" forState:UIControlStateNormal];
            registerButton.titleLabel.font = Font(fFont16);
            [registerButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [registerButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
            registerButton.layer.cornerRadius = 5;
            registerButton.layer.masksToBounds = YES;
            [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.top.equalTo(buttonCell.contentView).offset(FITHEIGHT(50));
                make.width.equalTo(@(SCREEN_WITH - 40));
                make.height.equalTo(@(FITHEIGHT(50)));
            }];
        }
        return buttonCell;
    } else {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            UIImageView *iconImageview = Building_UIImageViewWithSuperView(cell.contentView, IMG_Name(@"icon"));
            [iconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.width.equalTo(@(60));
                make.height.equalTo(@(60));
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)setCellFieldWithLogin:(PINLoginCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.nameTextField.delegate = self;
    cell.nameLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    cell.codeButton.hidden = YES;
    cell.pinCaptChaview.hidden = YES;
    if (indexPath.row == 0) {
        cell.nameTextField.placeholder = @"请输入11位中国手机号";
        cell.nameTextField.returnKeyType = UIReturnKeyNext;
        cell.nameTextField.text = self.telphone;
    } else if (indexPath.row == 1) {
        cell.nameTextField.placeholder = @"请输入图形验证码";
        cell.nameTextField.returnKeyType = UIReturnKeyNext;
        cell.nameTextField.text = self.picMsgCode;
        cell.pinCaptChaview.hidden = NO;
        [cell.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.nameLabel.mas_right).offset(10);
            make.top.equalTo(cell.contentView).offset(5);
            make.right.equalTo(cell.codeButton.mas_left).offset(-10);
            make.bottom.equalTo(cell.contentView).offset(-5);
        }];
        
    } else if (indexPath.row == 2) {
        cell.nameTextField.placeholder = @"请输入短信验证码";
        cell.nameTextField.returnKeyType = UIReturnKeyNext;
        cell.nameTextField.text = self.telMsgCode;
        [cell.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.nameLabel.mas_right).offset(10);
            make.top.equalTo(cell.contentView).offset(5);
            make.right.equalTo(cell.codeButton.mas_left).offset(-10);
            make.bottom.equalTo(cell.contentView).offset(-5);
        }];
        cell.codeButton.hidden = NO;
        [cell.codeButton addTarget:self action:@selector(resendMsgCode) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.codeButton setTitle:self.validateStr forState:UIControlStateNormal];
        [cell.codeButton setTitle:self.validateStr forState:UIControlStateDisabled];
        
    } else if (indexPath.row == 3) {
        cell.nameTextField.placeholder = @"请设置6位及以上密码";
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
        self.picMsgCode = textValue;
    } else if (textField.tag == 1002) {
        self.telMsgCode = textValue;
    } else if (textField.tag == 1003) {
        self.password = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1000) {
        PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1001) {
        PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1002) {
        PINLoginCell *cell = (PINLoginCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1003) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.telphone = textField.text;
    } else if (textField.tag == 1001) {
        self.picMsgCode = textField.text;
    } else if (textField.tag == 1002) {
        self.telMsgCode = textField.text;
    } else if (textField.tag == 1003) {
        self.password = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.telphone = @"";
    } else if (textField.tag == 1001) {
        self.picMsgCode = @"";
    } else if (textField.tag == 1002) {
        self.telMsgCode = @"";
    } else if (textField.tag == 1003) {
        self.password = @"";
    }
    return YES;
}

@end
