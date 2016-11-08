//
//  PINPaymentController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINPaymentController.h"
#import "PlainCellBgView.h"
#import "PINPaymentCell.h"
#import "SinglePickerView.h"
#import "PINPaymentModel.h"

@interface PINPaymentController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray *alipayArray;

@property (strong, nonatomic) NSArray *cardArray;

@property (strong, nonatomic) PINPaymentModel *paymentModel;

@property (assign, nonatomic) BOOL isAdd;

@end

@implementation PINPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
}

- (void)initParams {
    self.cardArray = [NSArray arrayWithObjects:@"账户类型", @"真实姓名", @"银行卡号", @"开户银行", nil];
    self.alipayArray = [NSArray arrayWithObjects:@"账户类型", @"真实姓名", @"提现账号", nil];
    self.paymentModel = [[PINPaymentModel alloc] init];
    if ([self.postParams objectForKey:@"pymentModel"]) {
        self.paymentModel = [self.postParams objectForKey:@"pymentModel"];
        self.isAdd = NO;
        self.title = @"修改账户";
    } else {
        self.paymentModel.type = 1;
        self.isAdd = YES;
        self.title = @"创建账户";
    }
}

- (void)buttonAction {
    [[super findFirstResponder] resignFirstResponder];
    
    if (self.paymentModel.holder.length == 0) {
        [self chatShowHint:@"请填写提现账户名称"];
        return;
    }
    
    if (self.paymentModel.account.length == 0) {
        if (self.paymentModel.type == 1) {
            [self chatShowHint:@"请填写储蓄卡号"];
        } else {
            [self chatShowHint:@"请填写支付宝账户"];
        }
        return;
    }
    
    if (self.paymentModel.company.length == 0) {
        [self chatShowHint:@"请填写开户银行"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isAdd) {
        [self.httpService paymentAddRequestWithSid:[PINUserDefaultManagement instance].sid type:self.paymentModel.type holder:self.paymentModel.holder account:self.paymentModel.account company:self.paymentModel.company finished:^(NSDictionary *result, NSString *message) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self chatShowHint:@"保存成功"];
            [super backAction];
            
        } failure:^(NSDictionary *result, NSString *message) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self chatShowHint:@"保存失败"];
            
        }];
    } else {
        [self.httpService paymentModifyRequestWithSid:[PINUserDefaultManagement instance].sid paymentid:self.paymentModel.guid type:self.paymentModel.type holder:self.paymentModel.holder account:self.paymentModel.account company:self.paymentModel.company finished:^(NSDictionary *result, NSString *message) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self chatShowHint:@"修改成功"];
            [super backAction];
            
        } failure:^(NSDictionary *result, NSString *message) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self chatShowHint:@"修改失败"];
            
        }];
    }
    
    
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.paymentModel.type == 1) {
            return self.cardArray.count;
        } else {
            return self.alipayArray.count;
        }
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
        static NSString *paymentCellId = @"paymentCellId";
        PINPaymentCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:paymentCellId];
        if (paymentCell == nil) {
            paymentCell = [[PINPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paymentCellId];
        }
        paymentCell.nameTextField.tag = 1000 + indexPath.row;
        paymentCell.nameTextField.kbMoving.kbMovingView = self.tableview;
        paymentCell.nameTextField.delegate = self;
        [self setCellFieldWithCell:paymentCell withTableView:tableView withIndexPath:indexPath];
        paymentCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        return paymentCell;

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

- (void)setCellFieldWithCell:(PINPaymentCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (self.paymentModel.type == 1) {
        cell.nameLabel.text = [self.cardArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.nameTextField.userInteractionEnabled = NO;
            cell.nameTextField.text = self.paymentModel.type == 1 ? @"银行卡" : @"支付宝";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.nameTextField.placeholder = @"提现账户姓名";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.paymentModel.holder;
        } else if (indexPath.row == 2) {
            cell.nameTextField.placeholder = @"提现储蓄卡号";
            cell.nameTextField.returnKeyType = UIReturnKeyDone;
            cell.nameTextField.text = self.paymentModel.account;
        } else if (indexPath.row == 3) {
            cell.nameTextField.placeholder = @"填写开户银行";
            cell.nameTextField.returnKeyType = UIReturnKeyDone;
            cell.nameTextField.text = self.paymentModel.company;
        }
    } else {
        cell.nameLabel.text = [self.alipayArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.nameTextField.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.nameTextField.text = self.paymentModel.type == 1 ? @"银行卡" : @"支付宝";
        } else if (indexPath.row == 1) {
            cell.nameTextField.placeholder = @"提现账户姓名";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.paymentModel.holder;
        } else if (indexPath.row == 2) {
            cell.nameTextField.placeholder = @"提现支付宝账号";
            cell.nameTextField.returnKeyType = UIReturnKeyDone;
            cell.nameTextField.text = self.paymentModel.account;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self showTypePickerView];
    }
}

#pragma mark -
#pragma mark ---- showTypePickerView ----

- (void)showTypePickerView{
    SinglePickerView *singlePickerView = [[SinglePickerView alloc] initWithTitle:@"请选择账户类型"];
    singlePickerView.delegate = self;
    singlePickerView.dataArray = [NSMutableArray arrayWithObjects:@"银行卡", @"支付宝", nil];
    singlePickerView.defaultValue = self.paymentModel.type == 1 ? @"银行卡" : @"支付宝";
    singlePickerView.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [singlePickerView showInView:self.view];
}

- (void)selectPickerBack:(NSString *)value withIndexPath:(NSIndexPath *)indexPath {
    PLog(@"value -- %@", value);
    if ([value isEqualToString:@"银行卡"]) {
        if (self.paymentModel.type == 0) {
            self.paymentModel.company = @"";
            self.paymentModel.account = @"";
        }
        self.paymentModel.type = 1;
        
    } else {
        if (self.paymentModel.type == 1) {
            self.paymentModel.company = @"支付宝";
            self.paymentModel.account = @"";
        }
        self.paymentModel.type = 0;
    }
    [self.tableview reloadData];
}

#pragma mark -
#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *inputText = [NSMutableString stringWithFormat:@"%@",textField.text];
    
    NSString *textValue = getTrimString(inputText);
    if (textField.tag == 1001) {
        self.paymentModel.holder = textValue;
    } else if (textField.tag == 1002) {
        self.paymentModel.account = textValue;
    } else if (textField.tag == 1003) {
        self.paymentModel.company = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1001) {
        PINPaymentCell *cell = (PINPaymentCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1002) {
        if (self.paymentModel.type == 1) {
            PINPaymentCell *cell = (PINPaymentCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell.nameTextField becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    } else if (textField.tag == 1003) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.paymentModel.holder = textField.text;
    } else if (textField.tag == 1002) {
        self.paymentModel.account = textField.text;
    } else if (textField.tag == 1003) {
        self.paymentModel.company = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.paymentModel.holder = @"";
    } else if (textField.tag == 1002) {
        self.paymentModel.account = @"";
    } else if (textField.tag == 1003) {
        self.paymentModel.company = @"";
    }
    return YES;
}

@end
