//
//  MyInstalledController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyInstalledController.h"
#import "MyInstalledCell.h"
#import "UINavigationBar+SetColor.h"
#import "PinUser.h"

@interface MyInstalledController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property(nonatomic, strong) NSArray *infoArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSString *weixinName; // 微信名
@property (nonatomic, strong) NSString *userName; // 用户名
@property (nonatomic, strong) NSString *telphone; // 手机号
@property (nonatomic, strong) NSString *address; // 地址

@property (nonatomic, strong) UIImage *picImage; // 图片

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, assign) BOOL picImageChange;

@end

@implementation MyInstalledController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    [self initParams];
    [self initUI];
}

- (void)initParams {
    self.infoArray = @[@"头像", @"微信号", @"用户名", @"手机号", @"地址"];
    self.isChange = NO;
    self.picImageChange = NO;
}

- (void)initUI {
    [super leftBarButton:@"取消" color:HEXCOLOR(pinColorWhite) selector:@selector(cancelAction) delegate:self];
    [super rightBarButton:@"保存" color:HEXCOLOR(pinColorWhite) selector:@selector(saveAction) delegate:self];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

    self.weixinName = [UserDefaultManagement instance].pinUser.wechat;
    self.userName = [UserDefaultManagement instance].pinUser.name;
    self.telphone = [UserDefaultManagement instance].pinUser.phone;
    self.address = [UserDefaultManagement instance].pinUser.address;
}

#pragma mark -
#pragma mark Button Action
- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction {
    if (self.isChange) {
        [UIAlertView alertViewWithTitle:@"提示"
                                message:@"如果您退出当前页面，您的数据会丢失！"
                                 cancel:@"取消"
                      otherButtonTitles:@[@"确定"]
                           clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle) {
                               [self dismissVC];
                               [NSObject event:@"WD004" label:@"取消个人信息修改"];
                           }
                            cancelBlock:^{
                            }];

    } else {
        [self dismissVC];
    }
}

- (void)saveAction {
    [self updateUserInfo];
    [NSObject event:@"WD005" label:@"保存个人信息修改"];
}

- (void)updateUserInfo {
    [[super findFirstResponder] resignFirstResponder];
    if (!self.isChange && !self.picImageChange) {
        [self dismissVC];
        return;
    }
    
    if (STR_Not_NullAndEmpty(self.telphone) && !validateMobile(self.telphone)) {
        [self chatShowHint:@"请输入正确的手机号码"];
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"id"];
    
    if (self.picImageChange) {
        NSString *fileName = [NSString stringWithFormat:@"%zd%@userImage.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
        [paramDic setObject:@[self.picImage] forKey:@"imageArray"];
        [paramDic setObject:@[fileName] forKey:@"fileNameArray"];
        [paramDic setObject:@"file" forKey:@"key"];
    }
    
    if (STR_Not_NullAndEmpty(self.userName)) {
        [paramDic setObject:self.userName forKey:@"name"];
    }
    if (STR_Not_NullAndEmpty(self.telphone)) {
        [paramDic setObject:self.telphone forKey:@"phone"];
    }
    if (STR_Not_NullAndEmpty(self.address)) {
        [paramDic setObject:self.address forKey:@"address"];
    }
    [super pinPostImageData:paramDic withMethodName:@"modifyuser.a" withMethodBack:@"modifyuser" withUserInfo:nil withIndicatorStyle:PinIndicatorStyle_DefaultIndicator];
}

- (void)requestFinished:(PinResponseResult *)request {
    if ([super isErrorResponseData:request]) {
        return;
    }
    [super requestFinished:request];
    NSString *responseString = request.responseString;
    PinBaseModel *pinBaseModel = [PinBaseModel modelWithJSON:responseString];
    if ([request.methodBack isEqualToString:@"modifyuser"]) {
        [UserDefaultManagement instance].pinUser = [PinUser modelWithDictionary:pinBaseModel.body];
        [self dismissVC];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return FITHEIGHT(100);
    } else {
        return FITHEIGHT(44);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *myInstalledCellId = @"myInstalledCellId";
    MyInstalledCell *myInstalledCell = [tableView dequeueReusableCellWithIdentifier:myInstalledCellId];
    if (!myInstalledCell) {
        myInstalledCell = [[[NSBundle mainBundle] loadNibNamed:@"MyInstalledCell" owner:self options:nil] objectAtIndex:0];
    }
    
    myInstalledCell.nameTextFiled.tag = 100 + indexPath.row;
    [self setCellFieldWith:myInstalledCell withTableView:tableView withIndexPath:indexPath];
    myInstalledCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
    myInstalledCell.selectedBackgroundView = [PlainCellBgView cellBgWithSelected:(indexPath.row == 0 || indexPath.row == self.infoArray.count - 1) ? YES : NO needFirstCellTopLine:indexPath.row == 0];
    return myInstalledCell;
}

- (void)setCellFieldWith:(MyInstalledCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.nameTextFiled.delegate = self;
    cell.nameTextFiled.hidden = YES;
    cell.nameTextFiled.userInteractionEnabled = NO;
    cell.arrowImageview.hidden = YES;
    cell.picImageview.hidden = (indexPath.row == 0 ? NO : YES);
    
    cell.nameLabel.text = [self.infoArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (self.picImageChange) {
                cell.picImageview.image = self.picImage;
            } else {
                [cell.picImageview sd_setImageWithURL:[NSURL URLWithString:[UserDefaultManagement instance].pinUser.avatar] placeholderImage:nil];
            }
            cell.arrowImageview.hidden = NO;
        }
            break;
        case 1:
        {
            cell.nameTextFiled.hidden = NO;
            cell.nameTextFiled.text = self.weixinName;
        }
            break;
        case 2:
        {
            cell.nameTextFiled.hidden = NO;
            cell.nameTextFiled.text = self.userName;
            cell.nameTextFiled.userInteractionEnabled = YES;
            cell.nameTextFiled.returnKeyType = UIReturnKeyNext;
            cell.nameTextFiled.placeholder = @"请输入用户名";
        }
            break;
        case 3:
        {
            cell.nameTextFiled.hidden = NO;
            cell.nameTextFiled.text = self.telphone;
            cell.nameTextFiled.userInteractionEnabled = YES;
            cell.nameTextFiled.returnKeyType = UIReturnKeyDone;
            cell.nameTextFiled.placeholder = @"请输入手机号";
        }
            break;
        case 4:
        {
            cell.nameTextFiled.hidden = NO;
            cell.nameTextFiled.text = self.address;
            cell.arrowImageview.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [[super findFirstResponder] resignFirstResponder];
        UIActionSheet *sheet = [super createSheet:self];
        [sheet showInView:self.view.window];
    } else if (indexPath.row == self.infoArray.count - 1) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self forKey:@"delegate"];
        [dic setObject:[NSNumber numberWithInteger:PinLoginType_MyInstalled] forKey:@"pinLoginType"];
        PinNavigationController *navigationController = [[PinNavigationController alloc] init];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_TEXTVIEW_VC navigationController:navigationController params:dic animated:NO];
        [super.navigationController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)sureTextView:(NSString *)str {
    self.address = str;
    self.isChange = YES;
    [self.tableview reloadData];
}

#pragma mark -
#pragma mark UITextFiled Delegte
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 102) {
        MyInstalledCell *cell = (MyInstalledCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.nameTextFiled becomeFirstResponder];
    } else if (textField.tag == 103) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *inputText = [NSMutableString stringWithFormat:@"%@",textField.text];

    NSString *textValue = getTrimString(inputText);
    if (textField.tag == 102) {
        self.userName = textValue;
    } else if (textField.tag == 103) {
        self.telphone =  textValue;
    }
    self.isChange = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 102) {
        self.userName = textField.text;
    } else if (textField.tag == 103) {
        self.telphone =  textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 100) {
        self.userName = @"";
    } else if (textField.tag == 103) {
        self.telphone = @"";
    }
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
    
    self.picImage = image;
    [self.tableview reloadData];
    
    self.picImageChange = YES;
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
