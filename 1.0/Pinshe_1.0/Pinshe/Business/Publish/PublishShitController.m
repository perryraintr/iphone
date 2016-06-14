//
//  PublishShitController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PublishShitController.h"
#import "UINavigationBar+SetColor.h"
#import "PINTextView.h"
#import "PublishSceneView.h"

@interface PublishShitController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishHeightLayoutConstraint;

@property (strong, nonatomic) UIImageView *recommendImageview;
@property (strong, nonatomic) UIButton *recommendButton;
@property (strong, nonatomic) UILabel *recommendLabel;
@property (strong, nonatomic) UITextField *recommendTextFiled;
@property (strong, nonatomic) PINTextView *recommendTextView;
@property (strong, nonatomic) PublishSceneView *publishSceneView;
@property (strong, nonatomic) UIImage *paramImage;

@end

@implementation PublishShitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    [self initUI];
}

- (void)initBaseParams {
    self.paramImage = [self.postParams objectForKey:@"paramImage"];
}

- (void)initUI {
    [super indexLeftBarButtonWithImage:@"close" selector:@selector(popToVC) delegate:self isIndex:NO];
    
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, 141, 44));;
    [super resetNavigationItemTiltView:view withTitleArray:@[@"比较", @"推荐", @"吐槽"] sel:@selector(titleViewAction:) delegate:self tag:102 isParentItem:NO isIndex:NO];
    
    self.publishHeightLayoutConstraint.constant = FITHEIGHT(56);
    
    self.publishSceneView = [[PublishSceneView alloc] initWithPinTopSceneType:0 withTag2Array:[self.postParams objectForKey:@"myPublishTag2Array"]];
    [self.publishSceneView publishBlock:^(NSMutableArray *array) {
        [self postPublishData:array];
        [self dismissVC];
        [NSObject event:@"PUBLISH007" label:@"确定发布吐槽"];
    }];
    
    [self createPublishView];
    
}

- (void)publishRequest {
    
    if (!self.recommendImageview.image) {
        [self chatShowHint:@"请添加您的图片"];
        return;
    }
    
    if (STR_Is_NullOrEmpty(self.recommendTextFiled.text)) {
        [self chatShowHint:@"请填写商品名称"];
        return;
    }
    
    [self.publishSceneView showFrame];
    [NSObject event:@"PUBLISH006" label:@"发布吐槽"];
}

- (void)postPublishData:(NSMutableArray *)mechandiseArray {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *imageArray = @[self.recommendImageview.image];
    NSString *fileName = [NSString stringWithFormat:@"%zd%@tag2.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSArray *fileNameArry = @[fileName];
    [dic setObject:imageArray forKey:@"imageArray"];
    [dic setObject:fileNameArry forKey:@"fileNameArray"];
    [dic setObject:@"file" forKey:@"key"];
    [dic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [dic setObject:@"2" forKey:@"t1"];
    // 名称
    if (STR_Not_NullAndEmpty(self.recommendTextFiled.text)) {
        [dic setObject:self.recommendTextFiled.text forKey:@"name"];
    }
    // 推荐语
    if (STR_Not_NullAndEmpty(self.recommendTextView.text)) {
        [dic setObject:self.recommendTextView.text forKey:@"description"];
    }
    // 商品类别
    if (mechandiseArray.count > 0) {
        NSString *mechandse = @"";
        for (NSNumber *number in mechandiseArray) {
            NSString *str = [NSString stringWithFormat:@",%zd", [number integerValue] + 1];
            mechandse = [mechandse stringByAppendingString:str];
        }
        mechandse = [mechandse substringFromIndex:1];
        [dic setObject:mechandse forKey:@"t2"];
    }
    
    [super pinPostImageData:dic withMethodName:@"addpost.a" withMethodBack:@"addpost" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    [super requestFinished:request];
    [PINBaseRefreshSingleton instance].refreshShit = 1;
    [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
}

#pragma mark -
#pragma mark Button Action
- (void)chooseRecommendImageAction:(UIButton *)sender {
    [[self findFirstResponder] resignFirstResponder];
    UIActionSheet *sheet = [super createSheet:self];
    [sheet showInView:self.view.window];
}

- (IBAction)publishRecommendAction:(UIButton *)sender { // 发布推荐
    PLog(@"发布推荐");
    [self publishRequest];
}

#pragma mark -
#pragma mark Private Method
- (void)popToVC {
    // 有数据
    if (self.recommendImageview.image) {
        [UIAlertView alertViewWithTitle:@"提示"
                                message:@"如果您退出当前页面，您的数据会丢失！"
                                 cancel:@"取消"
                      otherButtonTitles:@[@"确定"]
                           clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle) {
                               [self dismissVC];
                                [NSObject event:@"PUBLISH008" label:@"发布吐槽"];
                           }
                            cancelBlock:^{
                            }];
        return;
    }
    
    [self dismissVC];
}

- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)titleViewAction:(UIButton *)button {
    UIViewController *viewVC = nil;
    NSString *pushController = nil;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if (button.tag == 100) {
            if ([viewController isKindOfClass:CLASS(FORWARD_PUBLISHCOMPARE_VC)]) {
                viewVC = viewController;
                pushController = FORWARD_PUBLISHCOMPARE_VC;
            }
        } else if (button.tag == 101) {
            if ([viewController isKindOfClass:CLASS(FORWARD_PUBLISHRECOMMEND_VC)]) {
                viewVC = viewController;
                pushController = FORWARD_PUBLISHRECOMMEND_VC;
            }
        }
        
    }
    if (viewVC) {
        [self.navigationController popToViewController:viewVC animated:NO];
    } else {
        if (button.tag == 100) {
            pushController = FORWARD_PUBLISHCOMPARE_VC;
        } else if (button.tag == 101) {
            pushController = FORWARD_PUBLISHRECOMMEND_VC;
        }
        [[ForwardContainer shareInstance] pushContainer:pushController navigationController:self.navigationController params:nil animated:NO];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[self findFirstResponder] resignFirstResponder];
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    self.recommendImageview.image = image;
    [self.recommendButton setImage:nil forState:UIControlStateNormal];
    self.recommendLabel.text = @"";
    
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

- (void)createPublishView {
    UIView *bgView = Building_UIViewWithSuperView(self.view);
    bgView.backgroundColor = HEXCOLOR(pinColorWhite);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.equalTo(@(FITHEIGHT(350)));
    }];
    
    UIView *topView = Building_UIViewWithSuperView(bgView);
    topView.backgroundColor = HEXCOLOR(pinColorWhite);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.height.equalTo(@(FITHEIGHT(50)));
    }];
    
    UIView *lineView = Building_UIViewWithSuperView(bgView);
    lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.equalTo(@1);
    }];
    
    UIView *bottomView = Building_UIViewWithSuperView(bgView);
    bottomView.backgroundColor = HEXCOLOR(pinColorWhite);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.bottom.equalTo(bgView);
    }];
    
    self.recommendTextFiled = Building_UITextFieldWithSuperView(topView, HEXCOLOR(pinColorGray), Font(fFont16), NSTextAlignmentLeft, nil);
    self.recommendTextFiled.delegate = self;
    self.recommendTextFiled.attributedPlaceholder = getAttributedString(@"商品名称", pinColorGray, @"（如：Muji壁挂式CD播放器）", pinColorGray, fFont16, fFont13, YES);
    [self.recommendTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(FITWITH(25));
        make.right.equalTo(topView).offset(-FITWITH(25));
        make.top.bottom.equalTo(topView);
    }];
    
    self.recommendImageview = Building_UIImageViewWithSuperView(bottomView, self.paramImage?:nil);
    [self.recommendImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(FITWITH(25));
        make.bottom.equalTo(bottomView).offset(-FITWITH(25));
        make.width.and.height.equalTo(@(FITWITH(130)));
    }];
    
    self.recommendButton = Building_UIButtonWithSuperView(bottomView, self, @selector(chooseRecommendImageAction:), nil);
    float interVel = FITWITH(49);
    self.recommendButton.layer.borderWidth = 1;
    self.recommendButton.layer.borderColor = HEXCOLOR(pinColorCellLineBackground).CGColor;
    [self.recommendButton setImage:self.paramImage ? nil : IMG_Name(@"pulishAddPic")  forState:UIControlStateNormal];
    [self.recommendButton setImageEdgeInsets:UIEdgeInsetsMake(interVel, interVel, interVel, interVel)];
    [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(FITWITH(25));
        make.bottom.equalTo(bottomView).offset(-FITWITH(25));
        make.width.and.height.equalTo(@(FITWITH(130)));
    }];
    
    self.recommendLabel = Building_UILabelWithSuperView(bottomView, Font(fFont12), HEXCOLOR(pinColorDarkOrange), NSTextAlignmentCenter, 1);
    
    self.recommendLabel.text = self.paramImage ? @"" : @"推荐一张图片";
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(FITWITH(25));
        make.width.equalTo(@(FITWITH(130)));
        make.bottom.equalTo(bottomView).offset(-FITWITH(53));
    }];
    
    self.recommendTextView = [[PINTextView alloc] init];
    self.recommendTextView.font = Font(fFont16);
    self.recommendTextView.placeholderColor = HEXCOLOR(pinColorGray);
    self.recommendTextView.textColor = HEXCOLOR(pinColorGray);
    self.recommendTextView.delegate = self;
    [bottomView addSubview:_recommendTextView];
    self.recommendTextView.placeholder = @"分享你的体验...";
    
    [self.recommendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(FITWITH(10));
        make.left.equalTo(bottomView).offset(FITWITH(20));
        make.right.equalTo(bottomView).offset(-FITWITH(20));
        make.bottom.equalTo(self.recommendImageview.mas_top).offset(-FITWITH(15));
    }];
}

@end
