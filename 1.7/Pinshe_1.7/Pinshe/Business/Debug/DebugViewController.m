//
//  DebugViewController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DebugViewController.h"

@interface DebugViewController ()
@property (weak, nonatomic) IBOutlet UITextField *debugIpTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation DebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([UserDefaultManagement instance].debugRequestUrl.length > 0) {
        self.debugIpTextField.text = [UserDefaultManagement instance].debugRequestUrl;
    } else {
        self.debugIpTextField.text = REQUEST_URL;
    }
    
    [super rightBarButton:@"保存" color:HEXCOLOR(pinColorWhite) selector:@selector(modifyAction) delegate:self];
    
    if (![UserDefaultManagement instance].isLogined) {
        UIButton *debugButton = Building_UIButtonWithFrameAndSuperView(self.view, CGRectMake(10, 200, 100, 20), self, @selector(debugLogin), nil);
        [debugButton setTitle:@"debug登录" forState:UIControlStateNormal];
        [debugButton setTitleColor:HEXCOLOR(pinColorBlack) forState:UIControlStateNormal];
    }
}

- (void)debugLogin {
    
    [self.httpService loginRequestWithWechat:@"" wcid:@"oYpSmv56sVCxBuTAWCNhuB_h8BSU" avatar:@"" finished:^(NSDictionary *result, NSString *message) {
    } failure:^(NSDictionary *result, NSString *message) {
    }];
    
}

- (void)modifyAction {
    [UserDefaultManagement instance].debugRequestUrl = self.debugIpTextField.text;
    [UserDefaultManagement instance].pinUser = nil;
    [UserDefaultManagement instance].userId = 0;
    [UserDefaultManagement instance].haveUserId = NO;
    exit(0);//改地址后结束进程
}

- (IBAction)requestChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0: // 线上 release
            self.debugIpTextField.text = REQUEST_URL;
            break;
        case 1: // 线下 debug
            self.debugIpTextField.text = @"http://192.168.2.33:8080/pinshe/";
            break;
        default:
            break;
    }
    
}

@end
