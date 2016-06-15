//
//  LoginController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/17.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "LoginController.h"
#import "UMSocial.h"
#import "UINavigationBar+SetColor.h"
#import "PinTabBarController.h"
#import "PinUser.h"
#import "WXApi.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (nonatomic, assign) PinLoginType pinLoginType;
@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) NSString *wechatImageUrl;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *wecahtId;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar become_backgroundColor:HEXCOLOR(pinColorWhite)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar become_backgroundColor:HEXCOLOR(pinColorNativeBarColor)];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)initBaseParams {
    self.pinLoginType = [[self.postParams objectForKey:@"pinLoginType"] integerValue];
    self.delegate = [self.postParams objectForKey:@"delegate"];
}

- (void)initUI {
    [super indexLeftBarButtonWithImage:@"closeBlack" selector:@selector(leftBarButtonAction) delegate:self isIndex:NO];
    self.widthLayoutConstraint.constant = FITWITH(205);
    self.heightLayoutConstraint.constant = FITHEIGHT(45);
    self.loginWidthLayoutConstraint.constant = FITWITH(133);
    self.loginHeightLayoutConstraint.constant = FITHEIGHT(36);
    self.bottomLayoutConstraint.constant = FITHEIGHT(140);
}

- (void)leftBarButtonAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)adduserRequest {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.wechatImageUrl forKey:@"avatar"];
    [paramDic setObject:self.wecahtId forKey:@"wcid"];
    [paramDic setObject:self.wechat forKey:@"wechat"];
    [paramDic setObject:self.wechat forKey:@"name"];
    [super pinPostImageData:paramDic withMethodName:@"adduser.a" withMethodBack:@"adduser" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    NSString *responseString = request.responseString;
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseString];
    [super requestFinished:request];
    if ([request.methodBack isEqualToString:@"adduser"]) {
        [PINBaseRefreshSingleton instance].refreshCompare = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshShit = 1;
        
        [UserDefaultManagement instance].userId = [[pinBaseModel.body objectForKey:@"guid"] intValue];
        [UserDefaultManagement instance].pinUser = [PinUser modelWithDictionary:pinBaseModel.body];
        
        [self dismissLoginController:NO];
        [self willPresentViewController];
    }
}

- (IBAction)weixinLogin:(id)sender {
///   测试数据
//#warning by shi login Test
//    self.wechatImageUrl = @"";
//    self.wecahtId = @"oYpSmv56sVCxBuTAWCNhuB_h8BSU"; // 我的chatId
//    self.wecahtId =@"pinsher"; // 品社君
//    self.wechat = @"";
//    [self adduserRequest];
    
    [self wxlg];
    [NSObject event:@"LOGIN001" label:@"微信登录"];
}

- (void)dismissLoginController:(BOOL)isAnimated {
    [self.navigationController dismissViewControllerAnimated:isAnimated completion:nil];
}

// 登录之后要展示的页面
- (void)willPresentViewController {
    if (self.pushNavigationContrller) {
        [self.pushNavigationContrller pushViewController:self.willPushViewController animated:NO];
    } else if (self.pinLoginType > 0) {
        if (self.pinLoginType == PinLoginType_PublishMy) { // 未登陆到tab3页面
            pinTabBarController().selectedIndex = 2;
            return;
        } else if (self.pinLoginType == PinLoginType_PublishRecommed || self.pinLoginType == PinLoginType_PublishShit) {
            // tab2 推荐和吐槽弹出图片选择页面
            if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"chooseRecoomedImageAction")]) {
                SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"chooseRecoomedImageAction")])
            }
        } else if (self.pinLoginType == PinLoginType_Favor) {
            if ([self.delegate respondsToSelector:NSSelectorFromString(@"favorAction")]) {
                SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"favorAction")])
            }
        } else { // 比较发布页面 和 品选详情页跳转回复留言
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.delegate) {
                [dic setObject:self.delegate forKey:@"delegate"];
            }
            [dic setObject:[NSNumber numberWithInteger:self.pinLoginType] forKey:@"pinLoginType"];
            PinNavigationController *navigationController = [[PinNavigationController alloc] init];
            [[ForwardContainer shareInstance] pushContainer:getPushName(self.pinLoginType) navigationController:navigationController params:dic animated:NO];
            [pinSheAppDelegate().pinNavigationController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

#pragma mark -
#pragma mark Button Action
- (IBAction)protocolAction:(id)sender { // 用户协议
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"用户协议" forKey:@"title"];
    NSString *protocolUrl = [NSString stringWithFormat:@"%@protocol.html", getRequestUrl()];
    [paramDic setObject:protocolUrl forKey:@"loadUrl"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_WEBVIEW_VC navigationController:self.navigationController params:paramDic animated:NO];
}

- (void)wxlg
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            
            self.wechat = snsAccount.userName ? : @"";
            self.wecahtId = snsAccount.usid;
            self.wechatImageUrl = snsAccount.iconURL ? : @"";
            PLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            // 请求登陆接口
            [self adduserRequest];
        }
        else if(response.responseCode == UMSResponseCodeCancel)
        {
            [self chatShowHint:@"微信用户取消登录授权"];
            [NSObject event:@"LOGIN002" label:@"用户取消登录"];
        }
        else if (response.responseCode == UMSResponseCodeNotLogin)
        {
            [self chatShowHint:@"微信用户未登录"];
        }
        else if (response.responseCode == UMSResponseCodeAccessTokenExpired)
        {
            [self chatShowHint:@"微信用户登录已过期"];
        }
        else
        {
            [self chatShowHint:@"微信登录失败"];
        }
        
    });
}

@end
