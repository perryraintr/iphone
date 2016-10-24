//
//  PINGetcashController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINGetcashController.h"
#import "PINForgetCell.h"
#import "PINStoreTitleCell.h"
#import "PlainCellBgView.h"

@interface PINGetcashController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation PINGetcashController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (PINAppDelegate().networkType == PINNetworkType_None) {
        [self chatShowHint:@"网络不给力"];
        return;
    }
}

- (void)requestCashAdd:(NSString *)price {
    [[super findFirstResponder] resignFirstResponder];
    if ([price floatValue] == 0) {
        [self chatShowHint:@"提现不能为0元"];
        return;
    }
    
    if ([PINUserDefaultManagement instance].storeCurrent < [price floatValue]) {
        [self chatShowHint:@"余额不足"];
        return;
    }
    
    [self.httpService cashAddRequestWithSid:[PINUserDefaultManagement instance].sid mid:[PINUserDefaultManagement instance].pinUser.guid amount:price  finished:^(NSDictionary *result, NSString *message) {
        
        [self chatShowHint:@"提现审核中"];
        [self.httpService wechatSendWithMessage:[NSString stringWithFormat:@"有商家进行提现了，<a href='http://www.pinshe.org/admin/v1/store_cash_detail.html?id=%zd'>提现详情</a>", [[result objectForKey:@"guid"] intValue]]];

        [super backAction];
    } failure:^(NSDictionary *result, NSString *message) {
        
        [self chatShowHint:@"提现失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return FITHEIGHT(80);
    } else {
        return SCREEN_HEIGHT - 64 - FITHEIGHT(80);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *pinStoreTitleCellId = @"pinStoreTitleCellId";
        PINStoreTitleCell *pinStoreTitleCell = [tableView dequeueReusableCellWithIdentifier:pinStoreTitleCellId];
        if (pinStoreTitleCell == nil) {
            pinStoreTitleCell = [[PINStoreTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pinStoreTitleCellId];
        }
        pinStoreTitleCell.nameLabel.text = [PINUserDefaultManagement instance].storeName;
        pinStoreTitleCell.amountLabel.text = [NSString stringWithFormat:@"当前余额：%.2f元", [PINUserDefaultManagement instance].storeCurrent];
        pinStoreTitleCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        
        return pinStoreTitleCell;
    } else {
        static NSString *cellId = @"cellId";
        PINForgetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[PINForgetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.priceTextFiled.delegate = self;
        cell.priceTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [cell cashAddBlockAction:^(NSString *priceString) {
            PLog(@"%@", priceString);
            [self requestCashAdd:priceString];
            
        }];
        return cell;
    }
}

#pragma mark -
#pragma mark UITextField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSScanner      *scanner    = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers;
    NSRange         pointRange = [textField.text rangeOfString:@"."];
    
    if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) ) {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    } else {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] ) {
        return NO;
    }
    
    short remain = 2; //默认保留2位小数
    
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
        if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            return NO;
        }
    }
    
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
            textField.text = string;
            return NO;
        }else{
            if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    
    NSString *buffer;
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
