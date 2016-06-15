//
//  PublishRecommendController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PublishRecommendController.h"
#import "UINavigationBar+SetColor.h"
#import "PINTextView.h"
#import "PublishSceneView.h"
#import "PublishImageViewCell.h"

@interface PublishRecommendController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishHeightLayoutConstraint;

@property (nonatomic, assign) PinTopSceneType pinTopSceneType; // 从top10页面过来

@property (strong, nonatomic) UITextField *recommendTextFiled; // 商品名称

@property (strong, nonatomic) PINTextView *recommendTextView; // 商品描述

@property (strong, nonatomic) PublishSceneView *publishSceneView; // 发布选择场景

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImage *paramImage;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) NSMutableArray *fileNameArray;

@property (assign, nonatomic) NSInteger indexRow;

@end

@implementation PublishRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    [self initParams];
    [self initUI];
}

- (void)initBaseParams {
    self.paramImage = [self.postParams objectForKey:@"paramImage"];

    self.pinTopSceneType = [[self.postParams objectForKey:@"pinTopSceneType"] integerValue];
}

- (void)initParams {
    self.imageArray = [NSMutableArray array];
    [self.imageArray addObject:self.paramImage];
    [self.imageArray addObject:IMG_Name(@"publishAddPicture")];
    
    self.fileNameArray = [NSMutableArray array];
    NSString *fileName = [NSString stringWithFormat:@"%zd%@tag1.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    [self.fileNameArray addObject:fileName];
}

- (void)initUI {
    [super indexLeftBarButtonWithImage:@"close" selector:@selector(popToVC) delegate:self isIndex:NO];
    self.title = @"推荐";
    
    self.publishHeightLayoutConstraint.constant = FITHEIGHT(56);
    
    self.publishSceneView = [[PublishSceneView alloc] initWithPinTopSceneType:self.pinTopSceneType withTag2Array:[self.postParams objectForKey:@"myPublishTag2Array"]];
    [self.publishSceneView publishBlock:^(NSMutableArray *array) {
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
        [self chatShowHint:@"您的发布将在1分钟内生效"];
        [self postPublishData:array];
        [self dismissVC];
        [NSObject event:@"PUBLISH004" label:@"确定发布推荐"];
    }];
    
    [self createPublishView];
}

- (void)publishRequest {
    if (self.imageArray.count == 1) {
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
    if (self.imageArray.count > 1) {
        [self.imageArray removeLastObject];
    }
    [dic setObject:self.imageArray forKey:@"imageArray"];
    [dic setObject:self.fileNameArray forKey:@"fileNameArray"];
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
    
    [super pinPostImageData:dic withMethodName:@"addpost.a" withMethodBack:@"addpost" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    [super requestFinished:request];
}

#pragma mark -
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublishImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"publishImageViewCellId" forIndexPath:indexPath];
    cell.publishImageview.image = [self.imageArray objectAtIndex:indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WITH - 72) / 3.0;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 18, 0, 18);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 18;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.item == self.imageArray.count - 1 && self.fileNameArray.count != 9) { // 最后一个是添加图片
        [self chooseRecommendImageAction];
    } else {
        self.indexRow = indexPath.item;
        [self modifyRecommendImageAction];
    }
}

#pragma mark -
#pragma mark Button Action
- (void)chooseRecommendImageAction { // 选择推荐图片
    [[self findFirstResponder] resignFirstResponder];
    UIActionSheet *sheet = [super createSheet:self];
    [sheet showInView:self.view.window];
}

- (void)modifyRecommendImageAction {
    [[self findFirstResponder] resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"删除图片",@"取消", nil];
    sheet.tag = 222;
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
    [UIAlertView alertViewWithTitle:@"提示"
                            message:@"如果您退出当前页面，您的数据会丢失！"
                             cancel:@"取消"
                  otherButtonTitles:@[@"确定"]
                       clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle) {
                           [self dismissVC];
                           [NSObject event:@"PUBLISH005" label:@"取消发布推荐"];
                       }
                        cancelBlock:^{
                        }];
}

- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        if (buttonIndex == 0) {
            if (self.fileNameArray.count == 9) {
                [self.imageArray addObject:IMG_Name(@"publishAddPicture")];
            }
            [self.imageArray removeObjectAtIndex:self.indexRow];
            [self.fileNameArray removeObjectAtIndex:self.indexRow];
            [self.collectionView reloadData];
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
    
    [self updateCollectionReload:image];
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
#pragma mark scrollviewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[self findFirstResponder] resignFirstResponder];
}

- (void)updateCollectionReload:(UIImage *)image {
    [self.imageArray insertObject:image atIndex:self.imageArray.count - 1];
    NSString *fileName = [NSString stringWithFormat:@"%zd%@tag1.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    [self.fileNameArray addObject:fileName];
    
    [self reloadDataCollectionViewHeight];
}

- (void)reloadDataCollectionViewHeight {
    CGFloat height = (SCREEN_WITH - 72) / 3.0;
    if (self.imageArray.count > 3) {
        if (self.imageArray.count > 6) {
            if (self.imageArray.count == 10) {
                [self.imageArray removeLastObject];
            } else {
                self.collectionView.height = height * 3 + 54;
            }
        } else {
            self.collectionView.height = height * 2 + 36;
        }
    } else {
        self.collectionView.height = height + 18;
    }
    
    [self.collectionView reloadData];
}

- (void)createPublishView {
    UIScrollView *scrollview = Building_UIScrollViewWithFrameAndSuperView(self.view, CGRectMake(0, 64, SCREEN_WITH, SCREEN_HEIGHT - 64 - FITHEIGHT(58)), NO, YES, NO, NO, NO);
    scrollview.delegate = self;
    scrollview.contentSize = CGSizeMake(SCREEN_WITH, SCREEN_HEIGHT - 64);
    UIView *bgView = Building_UIViewWithFrameAndSuperView(scrollview, CGRectMake(0, 0, SCREEN_WITH, FITHEIGHT(220)));
    bgView.backgroundColor = HEXCOLOR(pinColorWhite);
    
    UIView *topView = Building_UIViewWithFrameAndSuperView(bgView, CGRectMake(0, 0, SCREEN_WITH, FITHEIGHT(58)));
    topView.backgroundColor = HEXCOLOR(pinColorWhite);
    
    UIView *lineView = Building_UIViewWithFrameAndSuperView(bgView, CGRectMake(0, FITHEIGHT(58), SCREEN_WITH, FITHEIGHT(1)));
    lineView.backgroundColor = HEXCOLOR(pinColorCellLineBackground);
    
    UIView *bottomView = Building_UIViewWithSuperView(bgView);
    bottomView.backgroundColor = HEXCOLOR(pinColorWhite);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.bottom.equalTo(bgView);
    }];
    
    self.recommendTextFiled = Building_UITextFieldWithSuperView(topView, HEXCOLOR(pinColorLightGray), FontNotSou(fFont16), NSTextAlignmentLeft, nil);
    self.recommendTextFiled.delegate = self;
    self.recommendTextFiled.attributedPlaceholder = getAttributedString(@"商品名称", pinColorLightGray, @"（如：Muji壁挂式CD播放器）", pinColorLightGray, fFont16, fFont13, NO);
    [self.recommendTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(FITWITH(25));
        make.right.equalTo(topView).offset(-FITWITH(25));
        make.top.bottom.equalTo(topView);
    }];
    
    self.recommendTextView = [[PINTextView alloc] init];
    self.recommendTextView.font = FontNotSou(fFont16);
    self.recommendTextView.placeholderColor = HEXCOLOR(pinColorLightGray);
    self.recommendTextView.textColor = HEXCOLOR(pinColorLightGray);
    self.recommendTextView.delegate = self;
    [bottomView addSubview:_recommendTextView];
    self.recommendTextView.placeholder = @"分享你的体验...";
    
    [self.recommendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(FITWITH(10));
        make.left.equalTo(bottomView).offset(FITWITH(20));
        make.right.equalTo(bottomView).offset(-FITWITH(20));
        make.height.equalTo(@(FITHEIGHT(121)));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat height = (SCREEN_WITH - 72) / 3.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, FITHEIGHT(220), SCREEN_WITH, height + 18) collectionViewLayout:layout];
    self.collectionView.backgroundColor = HEXCOLOR(pinColorWhite);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [scrollview addSubview:_collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PublishImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"publishImageViewCellId"];
}

@end
