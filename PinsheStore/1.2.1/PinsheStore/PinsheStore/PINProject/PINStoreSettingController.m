//
//  PINStoreSettingController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/10/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreSettingController.h"
#import "PlainCellBgView.h"
#import "PINStoreSettingCell.h"
#import "PINStoreModel.h"

@interface PINStoreSettingController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *titleArray;

@property (strong, nonatomic) NSString *storeSlogan;

@property (strong, nonatomic) NSString *storeDate;

@property (strong, nonatomic) NSString *storePhone;

@property (strong, nonatomic) PINStoreModel *pinStoreModel;

@end

@implementation PINStoreSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置店铺";
    [self initParams];
    [self requestDetail];
}

- (void)initParams {
    self.titleArray = [NSArray arrayWithObjects:@"一句话描述:", @"营业时间:", @"联系电话:", nil];
}

- (void)requestDetail {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.httpService storeInfoRequestWithSid:[PINUserDefaultManagement instance].sid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        self.pinStoreModel = [PINStoreModel modelWithDictionary:result];
        self.storeSlogan = self.pinStoreModel.slogan;
        self.storeDate = self.pinStoreModel.date;
        self.storePhone = self.pinStoreModel.phone;
        
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self chatShowHint:@"请求失败"];
    }];
}

#pragma mark ---
#pragma mark Button Action
- (void)previewAction {
    
    if (![self verifyStore]) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.pinStoreModel.name forKey:@"title"];
    
//    http://www.pinshe.org/html/v1/coffee/store_previewdetail.html?id=88
    
    NSString *loadUrl = [NSString stringWithFormat:@"%@coffee/store_previewdetail.html?id=%zd&slogan=%@&date=%@&phone=%@", REQUEST_HTML_URL, self.pinStoreModel.guid, self.storeSlogan, self.storeDate, self.storePhone];
    [paramDic setObject:loadUrl forKey:@"loadUrl"];
    
    [[ForwardContainer shareInstance] pushContainer:FORWARD_WEBVIEW_VC navigationController:self.navigationController params:paramDic animated:YES];

}

- (void)saveAction {
    if (![self verifyStore]) {
        return;
    }
    
    
}

- (BOOL)verifyStore {
    PLog(@"%@, %@, %@", self.storeSlogan, self.storeDate, self.storePhone);

    if (self.storeSlogan.length == 0) {
        [self chatShowHint:@"请用一句话描述你的店铺"];
        return NO;
    }
    
    if (self.storeDate.length == 0) {
        [self chatShowHint:@"请填写营业时间"];
        return NO;
    }
    
    if (self.storePhone.length == 0) {
        [self chatShowHint:@"请填写联系方式"];
        return NO;
    }
    
    if (self.storeSlogan.length > 100) {
        [self chatShowHint:@"描述信息字数不得超过100字"];
        return NO;
    }
    
    if (self.storeDate.length == 0) {
        [self chatShowHint:@"营业时间字数不得超过100字"];
        return NO;
    }
    
    if (self.storePhone.length == 0) {
        [self chatShowHint:@"联系方式字数不得超过100字"];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.storeSlogan.length == 0) {
        return 0;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return FITHEIGHT(80);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *settingCellId = @"settingCellId";
        PINStoreSettingCell *pinStoreSettingCell = [tableView dequeueReusableCellWithIdentifier:settingCellId];
        if (pinStoreSettingCell == nil) {
            pinStoreSettingCell = [[PINStoreSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellId];
        }
        pinStoreSettingCell.descTextField.tag = 1000 + indexPath.row;
        pinStoreSettingCell.descTextField.kbMoving.kbMovingView = self.tableview;
        pinStoreSettingCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
        [self setCellFieldWithSettingCell:pinStoreSettingCell withTableView:tableView withIndexPath:indexPath];
        return pinStoreSettingCell;
    } else {
        static NSString *buttonCellId = @"cellId";
        UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonCellId];
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellId];
            buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *loginButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(previewAction), [UIColor clearColor]);
            [loginButton setTitle:@"预览" forState:UIControlStateNormal];
            loginButton.titleLabel.font = Font(fFont16);
            [loginButton setTitleColor:HEXCOLOR(pinColorDarkBlack) forState:UIControlStateNormal];
            loginButton.layer.cornerRadius = 5;
            loginButton.layer.masksToBounds = YES;
            loginButton.layer.borderColor = HEXCOLOR(pinColorDarkBlack).CGColor;
            loginButton.layer.borderWidth = 1;
            [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.top.equalTo(buttonCell.contentView).offset(15);
                make.width.equalTo(@((SCREEN_WITH - 60) / 2.0));
                make.height.equalTo(@(FITHEIGHT(50)));
            }];
            
            UIButton *registerButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(saveAction), [UIColor clearColor]);
            [registerButton setTitle:@"保存" forState:UIControlStateNormal];
            registerButton.titleLabel.font = Font(fFont16);
            [registerButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [registerButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
            registerButton.layer.cornerRadius = 5;
            registerButton.layer.masksToBounds = YES;
            [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(loginButton.mas_right).offset(20);
                make.top.equalTo(buttonCell.contentView).offset(15);
                make.width.equalTo(@((SCREEN_WITH - 60) / 2.0));
                make.height.equalTo(@(FITHEIGHT(50)));
            }];
        }
        return buttonCell;
    }
}

- (void)setCellFieldWithSettingCell:(PINStoreSettingCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.descTextField.delegate = self;
    cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.descTextField.placeholder = @"字数不超过100字";
        cell.descTextField.returnKeyType = UIReturnKeyNext;
        cell.descTextField.text = self.storeSlogan;
    } else if (indexPath.row == 1) {
        cell.descTextField.placeholder = @"字数不超过100字";
        cell.descTextField.returnKeyType = UIReturnKeyNext;
        cell.descTextField.text = self.storeDate;
    } else {
        cell.descTextField.placeholder = @"字数不超过100字";
        cell.descTextField.returnKeyType = UIReturnKeyDone;
        cell.descTextField.text = self.storePhone;
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
        self.storeSlogan = textValue;
    } else if (textField.tag == 1001) {
        self.storeDate = textValue;
    } else if (textField.tag == 1002) {
        self.storePhone = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1000) {
        PINStoreSettingCell *cell = (PINStoreSettingCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.descTextField becomeFirstResponder];
    }if (textField.tag == 1001) {
        PINStoreSettingCell *cell = (PINStoreSettingCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.descTextField becomeFirstResponder];
    } else if (textField.tag == 1002) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.storeSlogan = textField.text;
    } else if (textField.tag == 1001) {
        self.storeDate = textField.text;
    } else if (textField.tag == 1002) {
        self.storePhone = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.storeSlogan = @"";
    } else if (textField.tag == 1001) {
        self.storeDate = @"";
    } else if (textField.tag == 1002) {
        self.storePhone = @"";
    }
    return YES;
}

@end
