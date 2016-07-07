//
//  DebugViewController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DebugViewController.h"
#import "PinTabBarController.h"

@interface DebugViewController ()
@property (weak, nonatomic) IBOutlet UITextField *debugIpTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *debugLoginSegmentedControl;

@property (strong, nonatomic) NSString *currentWcid;

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
    
    self.currentWcid = @"oYpSmv56sVCxBuTAWCNhuB_h8BSU";
    
}

- (IBAction)debugLoginAction:(id)sender {
    if (![UserDefaultManagement instance].isLogined) {
        [self.httpService loginRequestWithWechat:@"" wcid:self.currentWcid avatar:@"" finished:^(NSDictionary *result, NSString *message) {
            
            [super backAction];
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            pinTabBarController().selectedIndex = 2;
            
        } failure:^(NSDictionary *result, NSString *message) {
        }];
    }
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
- (IBAction)debugLoginChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0: // vivian
            self.currentWcid = @"oYpSmv56sVCxBuTAWCNhuB_h8BSU";
            break;
        case 1: // vivian's
            self.currentWcid = @"oYpSmv1DQjrkAdA6id1aGzfcDgZQ";
        case 2: // perry
            self.currentWcid = @"";
            break;
        case 3: // villence
            self.currentWcid = @"oYpSmv-Nw03fNclpPvrrkxIh5TgM";
            break;
        case 4: // park
            self.currentWcid = @"oYpSmv3j9IEGJ1Csb3SNMqHCe0uE";
            break;
        default:
            break;
    }
}

@end
