//
//  IndexRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/16.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "IndexRecommendController.h"
#import "FashionRecommendController.h"
#import "ShitRecommendController.h"
#import "UINavigationBar+SetColor.h"
#import "PinTabBarController.h"

@interface IndexRecommendController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) BaseViewController *currentVC;
@property (nonatomic, strong) FashionRecommendController *first;
@property (nonatomic, strong) ShitRecommendController *second;

@property (nonatomic, strong) UIImage *paramImage;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation IndexRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.first = [[FashionRecommendController alloc] init];
    self.second = [[ShitRecommendController alloc] init];
    [self addChildViewController:self.first];
    [self addChildViewController:self.second];
    [self.view addSubview:self.first.view];
    
    self.first.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    self.second.view.frame = CGRectMake(0, 64, SCREEN_WITH, SCREEN_HEIGHT - 64 - FITHEIGHT(56) + FITHEIGHT(7));
    [UserDefaultManagement instance].buttonTag = 100;
    self.currentVC = self.first;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PinTabBarController *pinTabBar = pinTabBarController();
    [pinTabBar messageCountRequest];
    
    [self creatTitleView:[UserDefaultManagement instance].buttonTag];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)creatTitleView:(NSInteger)tag {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 36)];
    [super indexLeftBarButtonWithLeftView:leftView sel:@selector(infoListAction) delegate:self isIndex:YES];
    self.messageLabel = [leftView viewWithTag:2222];
    
    [super indexRightBarButtonWithImage:@"camera" selector:@selector(rightButtonAction:) delegate:self isIndex:YES];
    
    UIView *titleView = Building_UIViewWithFrame(CGRectMake(0, 0, 74 + FITWITH(72), 44));
    [super resetNavigationItemTiltView:titleView withTitleArray:@[@"推荐", @"吐槽"] sel:@selector(titleViewAction:) delegate:self tag:tag isParentItem:YES isIndex:YES];
}

- (void)createLeftBar {
    self.messageLabel.text = [NSString stringWithFormat:@"%zd", [UserDefaultManagement instance].messageCount];
    self.messageLabel.hidden = ([UserDefaultManagement instance].messageCount > 0) ? NO : YES;
}

- (void)titleViewAction:(UIButton *)sender {
    [UserDefaultManagement instance].buttonTag = sender.tag;
    BaseViewController *oldVC = self.currentVC;
    if ((self.currentVC == self.first && sender.tag == 100)||(self.currentVC == self.second && sender.tag == 101)) {
        return;
    }
    [self trainsitionFromViewController:oldVC toViewController:sender.tag == 100 ? self.first : self.second];
}

- (void)trainsitionFromViewController:(BaseViewController *)oldVC toViewController:(BaseViewController *)toVC {
    if (toVC == self.first) {
        [self creatTitleView:100];
    } else if (toVC == self.second) {
        [self creatTitleView:101];
    }
    [self transitionFromViewController:oldVC toViewController:toVC duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentVC = toVC;
    }];
}

#pragma mark -
#pragma mark Priveta Method
- (void)infoListAction {
    [[ForwardContainer shareInstance] pushContainerNeedLogin:FORWARD_INFOLIST_VC navigationController:self.navigationController params:nil animated:NO];
    [NSObject event:@"INFO001" label:@"消息列表"];
}

- (void)rightButtonAction:(UIButton *)button {
    BOOL isLogin = [UserDefaultManagement instance].isLogined;
    if (isLogin) {
        [self chooseRecoomedImageAction];
        return;
    }
    [self presentLoginVC:[UserDefaultManagement instance].buttonTag];
    
    if ([UserDefaultManagement instance].buttonTag == 100) {
        [NSObject event:@"TJ005" label:@"点击推荐发布"];
    } else {
        [NSObject event:@"TC001" label:@"点击吐槽发布"];
    }
}

- (void)chooseRecoomedImageAction {
    UIActionSheet *sheet = [super createSheet:self];
    [sheet showInView:self.view.window];
}

- (void)presentLoginVC:(NSInteger)tag {
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[NSNumber numberWithInteger:tag == 100 ? PinLoginType_PublishRecommed : PinLoginType_PublishShit] forKey:@"pinLoginType"];
    [paramsDic setObject:self forKey:@"delegate"];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_LOGIN_VC navigationController:navigationController params:paramsDic animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)presentPulishVC:(NSInteger)tag {
    PLog(@"presentPulishVC %zd, %@", tag, self.paramImage);
    
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:self.paramImage forKey:@"paramImage"];
    [[ForwardContainer shareInstance] pushContainer:tag == 100 ? FORWARD_PUBLISHRECOMMEND_VC : FORWARD_PUBLISHSHIT_VC navigationController:navigationController params:paramsDic animated:NO];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - actionSheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = [super imagePickerController:buttonIndex];
        if (sourceType == -1) {
            return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            imagePickerController.allowsEditing = NO;
        } else {
            imagePickerController.allowsEditing = YES;
        }
        imagePickerController.sourceType = sourceType;
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    if (buttonIndex == 2) { // 取消
        if ([UserDefaultManagement instance].buttonTag == 100) {
            [NSObject event:@"TJ006" label:@"推荐选择相册取消"];
        } else {
            [NSObject event:@"TC002" label:@"吐槽选择相册取消"];
        }
    }
}

#pragma mark -
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [UIImage imageNamed:@""];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    } else {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    self.paramImage = image;
    [self presentPulishVC:[UserDefaultManagement instance].buttonTag];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//实现navigationController的代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationController.navigationBar.barTintColor = HEXCOLOR(pinColorNativeBarColor);
    viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    viewController.navigationController.navigationBar.translucent = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController.navigationBar become_backgroundColor:HEXCOLOR(pinColorNativeBarColor)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
