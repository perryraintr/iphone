//
//  EditRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/10.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "EditRecommendController.h"
#import "UINavigationBar+SetColor.h"
#import "PINTextView.h"
#import "PublishSceneView.h"

@interface EditRecommendController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishHeightLayoutConstraint;

@property (strong, nonatomic) UIImageView *recommendImageview;
@property (strong, nonatomic) UIButton *recommendButton;
@property (strong, nonatomic) UILabel *recommendLabel;
@property (strong, nonatomic) UITextField *recommendTextFiled;
@property (strong, nonatomic) PINTextView *recommendTextView;
@property (strong, nonatomic) PublishSceneView *publishSceneView;

@property (nonatomic, strong) NSString *myPublishTitle;
@property (nonatomic, strong) NSString *myPublishDescription;
@property (nonatomic, strong) NSString *myPublishImageUrl;
@property (nonatomic, assign) int guid;

@end

@implementation EditRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    self.title = @"推荐";
    [self initUI];
}

- (void)initBaseParams {
    self.myPublishTitle = [self.postParams objectForKey:@"myPublishTitle"];
    self.myPublishImageUrl = [self.postParams objectForKey:@"myPublishImage1Url"];
    self.myPublishDescription = [self.postParams objectForKey:@"myPublishDescription"];
    self.guid = [[self.postParams objectForKey:@"id"] intValue];
}

- (void)initUI {
    [super indexLeftBarButtonWithImage:@"close" selector:@selector(popToVC) delegate:self isIndex:NO];
    
    self.publishHeightLayoutConstraint.constant = FITHEIGHT(56);
    
    self.publishSceneView = [[PublishSceneView alloc] initWithPinTopSceneType:-1 withTag2Array:[self.postParams objectForKey:@"myPublishTag2Array"]];
    [self.publishSceneView publishBlock:^(NSMutableArray *array) {
        [self dismissVC];
        [self postPublishData:array];
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
    [NSObject event:@"PUBLISH003" label:@"发布推荐"];
}

- (void)postPublishData:(NSMutableArray *)mechandiseArray {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *imageArray = @[self.recommendImageview.image];
    NSString *fileName = [NSString stringWithFormat:@"%zd%@tag1.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSArray *fileNameArry = @[fileName];
    [dic setObject:imageArray forKey:@"imageArray"];
    [dic setObject:fileNameArry forKey:@"fileNameArray"];
    [dic setObject:@"file" forKey:@"key"];
    [dic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [dic setObject:@"1" forKey:@"t1"];
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
    
    [dic setObject:[NSNumber numberWithInt:self.guid] forKey:@"id"];
    [super pinPostImageData:dic withMethodName:@"modifypost.a" withMethodBack:@"modifypost" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    [super requestFinished:request];
    [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
}

#pragma mark -
#pragma mark Button Action
- (void)chooseRecommendImageAction:(UIButton *)sender { // 选择推荐图片
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
    [self dismissVC];
}

- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
        imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
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
    
    self.recommendImageview = Building_UIImageViewWithSuperView(bottomView, nil);
    [self.recommendImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(FITWITH(25));
        make.bottom.equalTo(bottomView).offset(-FITWITH(25));
        make.width.and.height.equalTo(@(FITWITH(130)));
    }];
    
    self.recommendButton = Building_UIButtonWithSuperView(bottomView, self, @selector(chooseRecommendImageAction:), nil);
    float interVel = FITWITH(49);
    self.recommendButton.layer.borderWidth = 1;
    self.recommendButton.layer.borderColor = HEXCOLOR(pinColorCellLineBackground).CGColor;
    [self.recommendButton setImage:nil forState:UIControlStateNormal];
    [self.recommendButton setImageEdgeInsets:UIEdgeInsetsMake(interVel, interVel, interVel, interVel)];
    [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(FITWITH(25));
        make.bottom.equalTo(bottomView).offset(-FITWITH(25));
        make.width.and.height.equalTo(@(FITWITH(130)));
    }];
    
    self.recommendLabel = Building_UILabelWithSuperView(bottomView, Font(fFont12), HEXCOLOR(pinColorDarkOrange), NSTextAlignmentCenter, 1);
    
    self.recommendLabel.text = @"";
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
    
    // 来自我的发布
    self.recommendTextFiled.text = self.myPublishTitle;
    self.recommendTextView.text = self.myPublishDescription;
    [self.recommendImageview sd_setImageWithURL:[NSURL URLWithString:self.myPublishImageUrl] placeholderImage:nil];
}

@end
