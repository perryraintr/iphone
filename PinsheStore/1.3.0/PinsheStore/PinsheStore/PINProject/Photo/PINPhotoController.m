//
//  PINPhotoController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINPhotoController.h"
#import "PINPhotoCell.h"

@interface PINPhotoController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (assign, nonatomic) NSInteger indexRow;

@property (weak, nonatomic) id delegate;

@end

@implementation PINPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择图片";
    [self initUI];
}

- (void)initBaseParams {
    self.imageArray = [NSMutableArray arrayWithArray:[self.postParams objectForKey:@"images"]];
    self.delegate = [self.postParams objectForKey:@"delegate"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.delegate = nil;
}

- (void)initUI {
    [self.imageArray addObject:IMG_Name(@"addImage")];
    
    [super rightBarButton:@"保存" isRoot:NO color:HEXCOLOR(pinColorWhite) selector:@selector(addPhoto) delegate:self];
    
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PINPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photoCellId"];
}

- (void)addPhoto {
    if (self.imageArray.count == 1) {
        [self chatShowHint:@"请至少添加一张图片"];
        return;
    }
    
    [self.imageArray removeLastObject];
    
    if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"resetPhotoArray:")]) {
        SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"resetPhotoArray:") withObject:self.imageArray]);
        [super backAction];
    }
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
    PINPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCellId" forIndexPath:indexPath];
    id imageDate = [self.imageArray objectAtIndex:indexPath.item];
    if ([imageDate isKindOfClass:[UIImage class]]) {
        cell.photoImageview.image = imageDate;
    } else {
        [cell.photoImageview sd_setImageWithURL:[NSURL URLWithString:imageDate] placeholderImage:nil];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WITH - 32) / 3;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.item == self.imageArray.count - 1) { // 最后一个是添加图片
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
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = sourceType;
        imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        if (buttonIndex == 0) {
            [self.imageArray removeObjectAtIndex:self.indexRow];
            [self.collectionView reloadData];
        }
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
    if (image.size.width > UPLOADIMAGEWIDTH) {
        image = [image snapSmallImage:UPLOADIMAGEWIDTH];
    }
    [self.imageArray insertObject:image atIndex:self.imageArray.count - 1];
    [self.collectionView reloadData];
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
    viewController.navigationController.navigationBar.barTintColor = HEXCOLOR(pinColorNativeBarColor);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
