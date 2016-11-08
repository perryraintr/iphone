//
//  PINStorePushController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStorePushController.h"
#import "PlainCellBgView.h"
#import "PINStorePushModel.h"
#import "PINStorePushCell.h"

@interface PINStorePushController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) PINStorePushModel *storePushModel;

@property (strong, nonatomic) UIImage *paramImage;

@end

@implementation PINStorePushController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建推送内容";
    [self initParams];
}

- (void)initParams {
    self.storePushModel = [[PINStorePushModel alloc] init];
}

- (void)buttonAction {
    [[super findFirstResponder] resignFirstResponder];

    if (!self.paramImage) {
        [self chatShowHint:@"请选择图片"];
        return;
    }
    
    if (self.storePushModel.name.length == 0) {
        [self chatShowHint:@"请填写推送标题"];
        return;
    }
    
    if (self.storePushModel.url.length == 0) {
        [self chatShowHint:@"请填写推送链接"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.httpService storePushAddRequestWithSid:[PINUserDefaultManagement instance].sid name:self.storePushModel.name url:self.storePushModel.url images:@[self.paramImage] imageNames:@[@"storepush.png"] finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"保存成功"];
        [super backAction];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"保存失败"];
        
    }];
    
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        } else {
            return 44;
        }
    } else {
        return FITHEIGHT(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 10));
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == tableView.numberOfSections - 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 0));
    if (section == tableView.numberOfSections - 1) {
        view.height = 10;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"pushCellId";
        PINStorePushCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[PINStorePushCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.nameTextField.tag = 1000 + indexPath.row;
        cell.nameTextField.kbMoving.kbMovingView = self.tableview;
        cell.nameTextField.delegate = self;
        [self setCellFieldWithCell:cell withTableView:tableView withIndexPath:indexPath];
        cell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        return cell;
    } else {
        static NSString *buttonCellId = @"cellId";
        UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonCellId];
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellId];
            buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            buttonCell.backgroundColor = HEXCOLOR(pinColorMainBackground);
            
            UIButton *button = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(buttonAction), [UIColor clearColor]);
            [button setTitle:@"保存" forState:UIControlStateNormal];
            button.titleLabel.font = FontNotSou(fFont16);
            [button setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [button setBackgroundColor:HEXCOLOR(pinColorGreen)];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.right.equalTo(buttonCell.contentView).offset(-20);
                make.top.bottom.equalTo(buttonCell.contentView);
            }];
        }
        return buttonCell;
    }
}

- (void)setCellFieldWithCell:(PINStorePushCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.nameTextField.hidden = NO;
    cell.nameImageview.hidden = YES;
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"选择图片";
        cell.nameTextField.hidden = YES;
        cell.nameImageview.hidden = NO;
        cell.nameImageview.image = self.paramImage ? : nil;
    } else if (indexPath.row == 1) {
        cell.nameLabel.text = @"推送标题";
        cell.nameTextField.placeholder = @"填写推送标题";
        cell.nameTextField.returnKeyType = UIReturnKeyNext;
        cell.nameTextField.text = self.storePushModel.name;
    } else if (indexPath.row == 2) {
        cell.nameLabel.text = @"推送链接";
        cell.nameTextField.placeholder = @"填写推送链接";
        cell.nameTextField.returnKeyType = UIReturnKeyDone;
        cell.nameTextField.text = self.storePushModel.url;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self chooseRecommendImageAction];
        }
    }
    
}

#pragma mark -
#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *inputText = [NSMutableString stringWithFormat:@"%@",textField.text];
    
    NSString *textValue = getTrimString(inputText);
    if (textField.tag == 1001) {
        self.storePushModel.name = textValue;
    } else if (textField.tag == 1002) {
        self.storePushModel.url = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1001) {
        PINStorePushCell *cell = (PINStorePushCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1002) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.storePushModel.name = textField.text;
    } else if (textField.tag == 1002) {
        self.storePushModel.url = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.storePushModel.name = @"";
    } else if (textField.tag == 1002) {
        self.storePushModel.url = @"";
    }
    return YES;
}

#pragma mark ---
#pragma mark UIActionSheet
- (void)chooseRecommendImageAction { // 选择推荐图片
    [[self findFirstResponder] resignFirstResponder];
    UIActionSheet *sheet = [super createSheet:self];
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
    
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    if (image.size.width > UPLOADIMAGEWIDTH) {
        image = [image snapSmallImage:UPLOADIMAGEWIDTH];
    }
    PLog(@"image == %@", image);
    self.paramImage = image;
    [self.tableview reloadData];
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
