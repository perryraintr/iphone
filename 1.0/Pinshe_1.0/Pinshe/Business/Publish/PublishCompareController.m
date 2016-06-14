//
//  PublishCompareController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PublishCompareController.h"
#import "UINavigationBar+SetColor.h"

static NSString *const message = @"你的问题是什么?";

@interface PublishCompareController () <UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageview;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageview;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishHeightLayoutConstraint;

@property (nonatomic, assign) NSInteger buttonTag;

@end

@implementation PublishCompareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);

    [self initParams];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self findFirstResponder] resignFirstResponder];
    [self removeKeyboardNotification];
}

- (void)initParams {
    self.buttonTag = 0;
}

- (void)initUI {
    [super indexLeftBarButtonWithImage:@"close" selector:@selector(closeCurrentVC) delegate:self isIndex:NO];
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, 141, 44));;
    [super resetNavigationItemTiltView:view withTitleArray:@[@"比较", @"推荐", @"吐槽"] sel:@selector(titleViewAction:) delegate:self tag:100 isParentItem:NO isIndex:NO];
    
    float interVel = (SCREEN_WITH - 6) / 4.0 - FITWITH(32) / 2.0;
    [self.firstButton setImageEdgeInsets:UIEdgeInsetsMake(interVel, interVel, interVel, interVel)];
    [self.secondButton setImageEdgeInsets:UIEdgeInsetsMake(interVel, interVel, interVel, interVel)];

    self.publishHeightLayoutConstraint.constant = FITHEIGHT(56);
    
    self.questionTextView.text = message;
    self.questionTextView.delegate = self;
    
}

- (void)pulishRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *firstFileName = [NSString stringWithFormat:@"%zd%@tag311.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSString *secondFileName = [NSString stringWithFormat:@"%zd%@tag322.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    
    NSArray *imageArray = @[self.firstImageview.image, self.secondImageview.image];
    NSArray *fileNameArry = @[firstFileName, secondFileName];
    [dic setObject:imageArray forKey:@"imageArray"];
    [dic setObject:fileNameArry forKey:@"fileNameArray"];
    [dic setObject:@"file" forKey:@"key"];
    [dic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [dic setObject:self.questionTextView.text forKey:@"name"];
   
    [super pinPostImageData:dic withMethodName:@"addvote.a" withMethodBack:@"addvote" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

#pragma mark -
#pragma mark AFNetworking
- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    [super requestFinished:request];
}

- (void)requestFailed:(PinResponseResult *)request {
    [super requestFailed:request];
}

#pragma mark -
#pragma mark 发布
- (IBAction)publishButtonAction:(id)sender { // 提交发布
    
    if (STR_Is_NullOrEmpty(self.questionTextView.text) || [self.questionTextView.text isEqualToString:message]) {
        [self chatShowHint:@"请填写您的主题问题"];
        return;
    }
    if (!self.firstImageview.image || !self.secondImageview.image) {
        [self chatShowHint:@"请添加您的图片"];
        return;
    }
    
    [self pulishRequest];
    [self dismissVC];
    [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
    [NSObject event:@"PUBLISH001" label:@"发布比较"];
}

#pragma mark 图片选择
- (IBAction)chooseTakePhoto:(UIButton *)sender {
    self.buttonTag = sender.tag;
    [[self findFirstResponder] resignFirstResponder];
    UIActionSheet *sheet = [super createSheet:self];
    [sheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = [super imagePickerController:buttonIndex];
        if (sourceType == -1) {
            return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }

    if (self.buttonTag == 888) {
        self.firstImageview.image = image;
        self.firstLabel.text = @"";
        [self.firstButton setImage:nil forState:UIControlStateNormal];
        
    } else if (self.buttonTag == 999) {
        self.secondImageview.image = image;
        self.secondLabel.text = @"";
        [self.secondButton setImage:nil forState:UIControlStateNormal];
        
    }
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

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.questionTextView.text isEqualToString:message]) {
        self.questionTextView.text = @"";
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Private Method
- (void)closeCurrentVC {
    NSString *questionText = getTrimString(self.questionTextView.text);
    // 有数据
    if (self.firstImageview.image || self.secondImageview.image || (![questionText isEqualToString:message] && questionText.length > 0)) {
        [UIAlertView alertViewWithTitle:@"提示"
                                message:@"如果您退出当前页面，您的数据会丢失！"
                                 cancel:@"取消"
                      otherButtonTitles:@[@"确定"]
                           clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle) {
                               [self dismissVC];
                               [NSObject event:@"PUBLISH002" label:@"取消发布比较"];
                           }
                            cancelBlock:^{
        }];
    } else { //无数据
        [self dismissVC];
    }
}

- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)titleViewAction:(UIButton *)button {
    UIViewController *viewVC = nil;
    NSString *pushController = nil;
    for (UIViewController *viewController in self.navigationController.viewControllers) {

        if (button.tag == 101) {
            if ([viewController isKindOfClass:CLASS(FORWARD_PUBLISHRECOMMEND_VC)]) {
                viewVC = viewController;
                pushController = FORWARD_PUBLISHRECOMMEND_VC;
            }
        } else if (button.tag == 102) {
            if ([viewController isKindOfClass:CLASS(FORWARD_PUBLISHSHIT_VC)]) {
                viewVC = viewController;
                pushController = FORWARD_PUBLISHSHIT_VC;
            }
        }
        
    }
    if (viewVC) {
        [self.navigationController popToViewController:viewVC animated:NO];
    } else {
        if (button.tag == 101) {
            pushController = FORWARD_PUBLISHRECOMMEND_VC;
        } else if (button.tag == 102) {
            pushController = FORWARD_PUBLISHSHIT_VC;
        }
        [[ForwardContainer shareInstance] pushContainer:pushController navigationController:self.navigationController params:nil animated:NO];
    }
}

#pragma mark -
#pragma mark keyboardNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    double animationDuration = 0.0f;
    NSUInteger animationCurve = 0;
    CGRect keyboardEndRect = CGRectZero;

    [animationDurationObject getValue:&animationDuration];
    [animationCurveObject getValue:&animationCurve];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:animationCurve];
//        self.bottomLayoutConstraint.constant = keyboardEndRect.size.height;
//        [self.publishButton layoutIfNeeded];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];

    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:animationCurve];
//        self.bottomLayoutConstraint.constant = 0;
//        [self.publishButton layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[self findFirstResponder] resignFirstResponder];
}

@end
