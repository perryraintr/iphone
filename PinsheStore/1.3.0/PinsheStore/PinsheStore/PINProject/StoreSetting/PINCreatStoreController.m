//
//  PINCreatStoreController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINCreatStoreController.h"
#import "PlainCellBgView.h"
#import "PINStoreModel.h"
#import "PINCreatStoreCell.h"
#import "PINStoreFeatureModel.h"

@interface PINCreatStoreController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) PINStoreModel *pinStoreModel;

@property (nonatomic, assign) BOOL isAvatar;

@property (nonatomic, assign) BOOL isImage;

@property (nonatomic, strong) NSArray *storeArray;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, assign) BOOL isLogin;

@end

@implementation PINCreatStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建店铺";
    [self initParams];
}

- (void)initBaseParams {
    self.isLogin = [[self.postParams objectForKey:@"isLogin"] boolValue];
}

- (void)initParams {
    self.pinStoreModel = [[PINStoreModel alloc] init];
    self.pinStoreModel.imageNames = [NSMutableArray array];
    self.pinStoreModel.images = [NSMutableArray array];
    self.pinStoreModel.avatarImageName = @"avatarImageName.jpg";
    self.pinStoreModel.avatarImage = IMG_Name(@"icon");
    
    self.nameArray = [NSArray arrayWithObjects:@"店长头像", @"店长昵称", @"联系方式", nil];
    self.storeArray = [NSArray arrayWithObjects:@"店铺封面", @"店铺名称", @"店铺描述", @"门店故事", @"门店地址", @"运营时间", @"装修风格", @"特色1", @"特色2", nil];
    self.isAvatar = NO;
    self.isImage = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self findFirstResponder] resignFirstResponder];
}

#pragma mark -
#pragma mark - Button Action
- (void)creatStoreButtonAction {
    [[self findFirstResponder] resignFirstResponder];

    if (![self verifyStore]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    self.pinStoreModel.address = @"北京市朝阳区三元桥站";
    [self.httpService addressChangeLocation:self.pinStoreModel.address finished:^(NSDictionary *result, NSString *message) {
        PLog(@"location : %@", [result objectForKey:@"location"]);
//        116.443108,39.921470
        NSArray *locationsArr = [[result objectForKey:@"location"] componentsSeparatedByString:@","];
        self.pinStoreModel.longitude = [locationsArr[0] doubleValue];
        self.pinStoreModel.latitude = [locationsArr[1] doubleValue];
        
        [self.httpService storeAddRequestWithStoreModel:self.pinStoreModel finished:^(NSDictionary *result, NSString *message) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [UIAlertView alertViewWithTitle:@"添加成功" message:@"您的店铺已创建成功,品社客服会在24小时之内审核,审核通过后可在服务公众号中发现该店" cancel:@"确定" clickedBlock:^(NSInteger buttonIndex, NSString *buttonTitle, UIAlertView *alertview) {
            } cancelBlock:^{
                if (self.isLogin) {
                    PINStoreModel *model = [PINStoreModel modelWithDictionary:result];
                    [PINUserDefaultManagement instance].hasStore = YES;
                    [PINUserDefaultManagement instance].sid = model.guid;
                    [PINAppDelegate() rootVC];
                } else {
                    [super backAction];
                }
            }];

        } failure:^(NSDictionary *result, NSString *message) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self chatShowHint:@"图片尺寸过大，添加失败"];
        }];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"地址信息不正确"];
    }];
    
}

- (void)resetDescText:(NSString *)text {
    PLog(@"resetDescText-- %@", text);
    self.pinStoreModel.storeDescription = text;
    [self.tableview reloadData];
}

- (void)resetFeature1:(NSArray *)feature1 {
    self.pinStoreModel.feature1s = feature1;
    [self.tableview reloadData];
    self.pinStoreModel.feature1 = @"";
    for (PINStoreFeatureModel *model in self.pinStoreModel.feature1s) {
        self.pinStoreModel.feature1 = [NSString stringWithFormat:@"%@,%zd", self.pinStoreModel.feature1, model.guid];
    }
    self.pinStoreModel.feature1 = [self.pinStoreModel.feature1 substringFromIndex:1];
}

- (void)resetFeature2:(NSArray *)feature2 {
    self.pinStoreModel.feature2s = feature2;
    [self.tableview reloadData];
    self.pinStoreModel.feature2 = @"";
    for (PINStoreFeatureModel *model in self.pinStoreModel.feature2s) {
        self.pinStoreModel.feature2 = [NSString stringWithFormat:@"%@,%zd", self.pinStoreModel.feature2, model.guid];
    }
    self.pinStoreModel.feature2 = [self.pinStoreModel.feature2 substringFromIndex:1];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else if (section == 1) {
        return self.nameArray.count;
    } else if (section == 3) {
        return self.storeArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 40;
    } else {
        return FITHEIGHT(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 0));
    if (section == 4) {
        view.height = 20;
    } else {
        view.height = 0;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 0));
    if (section == 4) {
        view.height = 20;
    } else {
        view.height = 0;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *nameCellId = @"nameCellId";
        UITableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:nameCellId];
        if (nameCell == nil) {
            nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameCellId];
            nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        nameCell.textLabel.text = @"基本信息";
        nameCell.textLabel.font = Font(fFont14);
        nameCell.backgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:NO];
        return nameCell;
    } else if (indexPath.section == 1) {
        static NSString *creatNameCellId = @"creatNameCellId";
        PINCreatStoreCell *creatNameCell = [tableView dequeueReusableCellWithIdentifier:creatNameCellId];
        if (creatNameCell == nil) {
            creatNameCell = [[PINCreatStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:creatNameCellId];
        }
        creatNameCell.clipsToBounds = YES;
        creatNameCell.nameTextField.tag = 1000 + indexPath.row;
        creatNameCell.nameTextField.kbMoving.kbMovingView = self.tableview;
        [self setCellFieldWithCell:creatNameCell withTableView:tableView withIndexPath:indexPath];
        creatNameCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];

        return creatNameCell;
    } else if (indexPath.section == 2) {
        static NSString *storeCellId = @"storeCellId";
        UITableViewCell *storeCell = [tableView dequeueReusableCellWithIdentifier:storeCellId];
        if (storeCell == nil) {
            storeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellId];
            storeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        storeCell.textLabel.text = @"店铺信息";
        storeCell.textLabel.font = Font(fFont14);
        storeCell.backgroundView = [PlainCellBgView cellBgWithSelected:YES needFirstCellTopLine:NO];
        return storeCell;
    } else if (indexPath.section == 3) {
        static NSString *creatStoreCellId = @"creatStoreCellId";
        PINCreatStoreCell *creatStoreCell = [tableView dequeueReusableCellWithIdentifier:creatStoreCellId];
        if (creatStoreCell == nil) {
            creatStoreCell = [[PINCreatStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:creatStoreCellId];
        }
        creatStoreCell.clipsToBounds = YES;
        creatStoreCell.nameTextField.tag = 3000 + indexPath.row;
        creatStoreCell.nameTextField.kbMoving.kbMovingView = self.tableview;
        [self setCellFieldWithCell:creatStoreCell withTableView:tableView withIndexPath:indexPath];
        creatStoreCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
        
        return creatStoreCell;
    } else {
        static NSString *buttonCellId = @"cellId";
        UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonCellId];
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellId];
            buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            buttonCell.backgroundColor = HEXCOLOR(pinColorMainBackground);
            
            UIButton *creatStoreButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(creatStoreButtonAction), [UIColor clearColor]);
            [creatStoreButton setTitle:@"创建店铺" forState:UIControlStateNormal];
            creatStoreButton.titleLabel.font = FontNotSou(fFont16);
            [creatStoreButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [creatStoreButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
            creatStoreButton.layer.cornerRadius = 5;
            creatStoreButton.layer.masksToBounds = YES;
            [creatStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.right.equalTo(buttonCell.contentView).offset(-20);
                make.top.bottom.equalTo(buttonCell.contentView);
            }];
        }
        return buttonCell;
    }
}

- (void)setCellFieldWithCell:(PINCreatStoreCell *)cell withTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    cell.nameTextField.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.avatarImageview.hidden = YES;
    cell.nameTextField.hidden = NO;
    cell.nameTextField.userInteractionEnabled = YES;
    if (indexPath.section == 1) {
        cell.nameLabel.text = [self.nameArray objectAtIndex:indexPath.row];

        if (indexPath.row == 0) {
            cell.nameTextField.hidden = YES;
            cell.avatarImageview.hidden = NO;
            cell.avatarImageview.layer.masksToBounds = YES;
            cell.avatarImageview.layer.cornerRadius = FITHEIGHT(40) / 2.0;
            cell.avatarImageview.image = self.pinStoreModel.avatarImage;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.nameTextField.placeholder = @"请填写店长昵称";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.pinStoreModel.owner;
        } else if (indexPath.row == 2) {
            cell.nameTextField.placeholder = @"请填写门店联系方式(座机或手机号)";
            cell.nameTextField.returnKeyType = UIReturnKeyDone;
            cell.nameTextField.text = self.pinStoreModel.phone;
        }
    } else if (indexPath.section == 3) {
        cell.nameLabel.text = [self.storeArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.nameTextField.hidden = YES;
            cell.avatarImageview.hidden = NO;
            cell.avatarImageview.image = IMG_Name(@"icon");
            if (self.pinStoreModel.images.count > 0) {
                cell.avatarImageview.image = self.pinStoreModel.images[0];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.nameTextField.placeholder = @"请填写店铺名称";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.pinStoreModel.name;
        } else if (indexPath.row == 2) {
            cell.nameTextField.placeholder = @"请使用一句话描述您的店铺";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.pinStoreModel.slogan;
        } else if (indexPath.row == 3) {
            cell.nameTextField.placeholder = @"请填写门店故事";
            cell.nameTextField.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.nameTextField.text = self.pinStoreModel.storeDescription;
        } else if (indexPath.row == 4) {
            cell.nameTextField.placeholder = @"请填写完整地址(XX省XX市XX区XX路XX号)";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.pinStoreModel.address;
        } else if (indexPath.row == 5) {
            cell.nameTextField.placeholder = @"请填写门店运营时间";
            cell.nameTextField.returnKeyType = UIReturnKeyNext;
            cell.nameTextField.text = self.pinStoreModel.date;
        } else if (indexPath.row == 6) {
            cell.nameTextField.placeholder = @"例胡同院落,两层,宽敞,胡同房子(选填)";
            cell.nameTextField.returnKeyType = UIReturnKeyDone;
            cell.nameTextField.text = self.pinStoreModel.feature3;
        } else if (indexPath.row == 7) {
            cell.nameTextField.userInteractionEnabled = NO;
            if (self.pinStoreModel.feature1s.count > 0) {
                cell.nameTextField.text = @"已选择";
            } else {
                cell.nameTextField.text = @"未选择";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        } else if (indexPath.row == 8) {
            cell.nameTextField.userInteractionEnabled = NO;
            if (self.pinStoreModel.feature2s.count > 0) {
                cell.nameTextField.text = @"已选择";
            } else {
                cell.nameTextField.text = @"未选择";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {

            self.isAvatar = YES;
            self.isImage = NO;
            [self chooseRecommendImageAction];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {

            self.isAvatar = NO;
            self.isImage = YES;
            [self chooseRecommendImageAction];
        } else if (indexPath.row == 3) {
            
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setObject:self forKey:@"delegate"];
            [paramDic setObject:self.pinStoreModel.storeDescription?:@"" forKey:@"desc"];
            [[ForwardContainer shareInstance] pushContainer:FORWARD_STOREDESC_VC navigationController:self.navigationController params:paramDic animated:YES];
            
        } else if (indexPath.row == 7) {

            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setObject:self forKey:@"delegate"];
            [paramDic setObject:self.pinStoreModel.feature1s.count > 0 ? self.pinStoreModel.feature1s : @[] forKey:@"feature1s"];
            [[ForwardContainer shareInstance] pushContainer:FORWARD_FEATURE1_VC navigationController:self.navigationController params:paramDic animated:YES];
        } else if (indexPath.row == 8) {

            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setObject:self forKey:@"delegate"];
            [paramDic setObject:self.pinStoreModel.feature2s.count > 0 ? self.pinStoreModel.feature2s : @[] forKey:@"feature2s"];
            [[ForwardContainer shareInstance] pushContainer:FORWARD_FEATURE2_VC navigationController:self.navigationController params:paramDic animated:YES];
        }
    }
}

#pragma mark -
#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *inputText = [NSMutableString stringWithFormat:@"%@",textField.text];
    
    NSString *textValue = getTrimString(inputText);
    if (textField.tag == 1001) {
        self.pinStoreModel.owner = textValue;
    } else if (textField.tag == 1002) {
        self.pinStoreModel.phone = textValue;
    } else if (textField.tag == 3001) {
        self.pinStoreModel.name = textValue;
    } else if (textField.tag == 3002) {
        self.pinStoreModel.slogan = textValue;
    } else if (textField.tag == 3004) {
        self.pinStoreModel.address = textValue;
    } else if (textField.tag == 3005) {
        self.pinStoreModel.date = textValue;
    } else if (textField.tag == 3006) {
        self.pinStoreModel.feature3 = textValue;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1001) {
        PINCreatStoreCell *cell = (PINCreatStoreCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 1002) {
        [textField resignFirstResponder];
    } else if (textField.tag == 3001) {
        PINCreatStoreCell *cell = (PINCreatStoreCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:3]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 3002) {
        PINCreatStoreCell *cell = (PINCreatStoreCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:3]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 3004) {
        PINCreatStoreCell *cell = (PINCreatStoreCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:3]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 3005) {
        PINCreatStoreCell *cell = (PINCreatStoreCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:3]];
        [cell.nameTextField becomeFirstResponder];
    } else if (textField.tag == 3006) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.pinStoreModel.owner = textField.text;
    } else if (textField.tag == 1002) {
        self.pinStoreModel.phone = textField.text;
    } else if (textField.tag == 3001) {
        self.pinStoreModel.name = textField.text;
    } else if (textField.tag == 3002) {
        self.pinStoreModel.slogan = textField.text;
    } else if (textField.tag == 3004) {
        self.pinStoreModel.address = textField.text;
    } else if (textField.tag == 3005) {
        self.pinStoreModel.date = textField.text;
    } else if (textField.tag == 3006) {
        self.pinStoreModel.feature3 = textField.text;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.pinStoreModel.owner = @"";
    } else if (textField.tag == 1002) {
        self.pinStoreModel.phone = @"";
    } else if (textField.tag == 3001) {
        self.pinStoreModel.name = @"";
    } else if (textField.tag == 3002) {
        self.pinStoreModel.slogan = @"";
    } else if (textField.tag == 3004) {
        self.pinStoreModel.address = @"";
    } else if (textField.tag == 3005) {
        self.pinStoreModel.date = @"";
    } else if (textField.tag == 3006) {
        self.pinStoreModel.feature3 = @"";
    }
    return YES;
}

#pragma mark -
#pragma mark - verifyStore Action
- (BOOL)verifyStore {
    if (self.pinStoreModel.owner.length == 0) {
        [self chatShowHint:@"请填写店长昵称"];
        return NO;
    }
    
    if (self.pinStoreModel.phone.length == 0) {
        [self chatShowHint:@"请填写门店联系方式"];
        return NO;
    }
    
    if (self.pinStoreModel.images.count == 0) {
        [self chatShowHint:@"请选择一张店铺封面"];
        return NO;
    }

    if (self.pinStoreModel.name.length == 0) {
        [self chatShowHint:@"请填写店铺名称"];
        return NO;
    }
    
    if (self.pinStoreModel.slogan.length == 0) {
        [self chatShowHint:@"请使用一句话描述您的店铺"];
        return NO;
    }
    
    if (self.pinStoreModel.storeDescription.length == 0) {
        [self chatShowHint:@"请填写您的门店故事"];
        return NO;
    }
    
    if (self.pinStoreModel.address.length == 0) {
        [self chatShowHint:@"请填写完整门店地址"];
        return NO;
    }
    
    if (self.pinStoreModel.date.length == 0) {
        [self chatShowHint:@"请填写门店运营时间"];
        return NO;
    }
    
    if (self.pinStoreModel.feature1s.count == 0) {
        [self chatShowHint:@"特色1至少选择1个"];
        return NO;
    }
    
    if (self.pinStoreModel.feature2s.count == 0) {
        [self chatShowHint:@"特色2至少选择1个"];
        return NO;
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
            self.isAvatar = NO;
            self.isImage = NO;
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
    PLog(@"image = %@", image);
    if (self.isAvatar) {
        self.pinStoreModel.avatarImage = image;
    }
    if (self.isImage) {
        [self.pinStoreModel.imageNames addObject:@"image1.jpg"];
        [self.pinStoreModel.images addObject:image];
    }
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

- (void)backAction {
    [super backAction];
    if (self.isLogin) {
        // 变为未登录状态
        [PINConstant cleanUserDefault];
    }
}

@end
