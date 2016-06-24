//
//  BaseViewController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.httpService = [[PINMainModuleService alloc] init];
    
    [self initBaseUI];
    [self initBaseParams];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)dealloc {
    PLog(@"%s -- %@",__func__,self);
}

- (void)initBaseParams {
    
}

- (void)initParams {
    
}

- (void)initUI {
    
}

- (void)setTitle:(NSString *)title {
    super.title = title;
    if ([super.title length] == 0) {
        self.navigationItem.titleView = nil;
        return;
    }
    float width = [super.title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.navigationController.navigationBar.bounds))
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:FontNotSou(fFont16), NSFontAttributeName, nil]
                                            context:nil].size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WITH - width)/2, 0, width, CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FontNotSou(fFont16);
    titleLabel.text = super.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([self isKindOfClass:CLASS(FORWARD_MYCENTRAL_VC)]) {
        self.parentViewController.navigationItem.titleView = titleLabel;
    } else {
        self.navigationItem.titleView = titleLabel;
    }
}

- (void)setTitleImage {
    if (super.title.length == 0) {
        self.navigationItem.titleView = nil;
    }
    CGFloat width = FITWITH(182/3.0);
    CGFloat height = FITHEIGHT(62/3.0);
    UIImageView *imageView = Building_UIImageViewWithFrame(CGRectMake((CGRectGetWidth(self.navigationController.navigationBar.bounds) - width) / 2.0, 0, width, height), IMG_Name(@"navigationItemTitleImage"));
    self.parentViewController.navigationItem.titleView = imageView;
}

- (void)indexLeftBarButtonWithImage:(NSString *)imageName selector:(SEL)sel delegate:(id)delegate isIndex:(BOOL)isIndex {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMG_Name(imageName) forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 36);
    [button addTarget:delegate action:sel forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixedSpace.width = -15;
    if (isIndex) {
        self.parentViewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
    } else {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
    }
}

- (void)indexLeftBarButtonWithLeftView:(UIView *)leftView sel:(SEL)sel delegate:(id)delegate isIndex:(BOOL)isIndex {    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMG_Name(@"email") forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 36);
    [button addTarget:delegate action:sel forControlEvents:UIControlEventTouchDown];
    [leftView addSubview:button];
    
    UILabel *label = Building_UILabelWithFrameAndSuperView(leftView, CGRectMake(33, 2, FITWITH(15), FITWITH(15)), Font(fFont11), HEXCOLOR(pinColorWhite), NSTextAlignmentCenter, 0);
    label.tag = 2222;
    label.backgroundColor = HEXCOLOR(pinColorRed);
    label.layer.masksToBounds = YES;
    label.text = [NSString stringWithFormat:@"%zd", [UserDefaultManagement instance].messageCount];
    label.layer.cornerRadius = FITWITH(15) / 2.0;
    label.hidden = ([UserDefaultManagement instance].messageCount > 0) ? NO : YES;

    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixedSpace.width = -15;
    if (isIndex) {
        self.parentViewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
    } else {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
    }
}

- (void)indexRightBarButtonWithImage:(NSString *)imageName selector:(SEL)sel delegate:(id)delegate isIndex:(BOOL)isIndex {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMG_Name(imageName) forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 36);
    [button addTarget:delegate action:sel forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixedSpace.width = -15;
    if (isIndex) {
        self.parentViewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
    } else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
    }
}

- (void)resetNavigationItemTiltView:(UIView *)titleView withTitleArray:(NSArray *)titleArray sel:(SEL)sel delegate:(id)delegate tag:(NSInteger)tag isParentItem:(BOOL)isParentItem isIndex:(BOOL)isIndex {
    CGFloat titleWith =  37;
    CGFloat interval = isIndex ? (FITWITH(72)) : 15;
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = Building_UIButtonWithSuperView(titleView, delegate, sel, nil);
        button.frame = CGRectMake(i * (titleWith + interval), 0, titleWith, 44);
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xdddddd) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateSelected];
        button.titleLabel.font = FontNotSou(fFont16);
        button.tag = 100 + i;
        button.selected = (tag == 100 + i ? YES : NO);
        [titleView addSubview:button];
    }
    
    if (isParentItem) {
        self.parentViewController.navigationItem.titleView = titleView;
    } else {
        self.navigationItem.titleView = titleView;
    }
}

- (void)rightBarButton:(NSString *)aTitle color:(UIColor *)color selector:(SEL)sel delegate:(id)delegate {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = Font(fFont16);
    float width = 50;
    if ([aTitle length] > 2) {
        width = 50 + ([aTitle length] - 2) * 10;
    }
    button.frame = CGRectMake(0, 0, width, 34);
    [button addTarget:delegate action:sel forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixedSpace.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
}

- (void)leftBarButton:(NSString *)aTitle color:(UIColor *)color selector:(SEL)sel delegate:(id)delegate {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = Font(fFont16);
    float width = 50;
    if ([aTitle length] > 2) {
        width = 50 + ([aTitle length] - 2) * 10;
    }
    button.frame = CGRectMake(0, 0, width, 34);
    [button addTarget:delegate action:sel forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixedSpace.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
}

#pragma mark -
#pragma mark ---- 创建公用View方法 ----

- (void)initBaseUI {
    if ([self.navigationController.viewControllers count] > 1) {
        [self addBackBarButton:YES];
    } else {
        [self addBackBarButton:NO];
    }
}

- (void)addBackBarButton:(BOOL)add {
    self.navigationItem.title = @"";
    if (add) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:IMG_Name(@"navigationItemBack.png") forState:UIControlStateNormal];
        [button setImage:IMG_Name(@"navigationItemBack.png") forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 40, 36);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
        fixedSpace.width = -15;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fixedSpace, barButton, nil];
        
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (PinNavigationController *)navigationController {
    if ([self isKindOfClass:CLASS(FORWARD_INDEXACTIVITY_VC)]
        || [self isKindOfClass:CLASS(FORWARD_INDEXRECOMMEND_VC)]
        || [self isKindOfClass:CLASS(FORWARD_MYCENTRAL_VC)]) {
        return pinSheAppDelegate().pinNavigationController;
    }
    return (PinNavigationController *)super.navigationController?:pinSheAppDelegate().pinNavigationController;
}

- (void)backAction {
    [self backActionAnimated:NO];
}

- (void)backActionAnimated:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:animated];
}

#pragma mark -
#pragma mark ---- 内部方法 ----

- (UIView *)findFirstResponderInView:(UIView *)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView *firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

- (UIView *)findFirstResponder {
    UIView *view = [self findFirstResponderInView:self.view];
    if (view) {
        return view;
    } else {
        return [self findFirstResponderInView:self.navigationController.navigationBar];
    }
}

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark -
#pragma mark keyboardNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    
}

#pragma mark -
#pragma mark showSheet
- (UIActionSheet *)createSheet:(id)delegate {
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"取消", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"取消", nil];
    }
    sheet.tag = 255;
    return sheet;
}

- (NSInteger)imagePickerController:(NSInteger)buttonIndex {
    NSUInteger sourceType = -1;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                // 取消
                break;
        }
    } else {
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    return sourceType;
}

#pragma mark -
- (UITableViewCell *)blankContentCellWithTableView:(UITableView *)tableView
                                         indexPath:(NSIndexPath *)indexPath
                                        noDataText:(NSString *)noDataText {
    NSString *nullCellID = [NSString stringWithFormat:@"nullContentCellID%@", indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nullCellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nullCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = noDataText;
    cell.textLabel.font = Font(fFont14);
    cell.textLabel.textColor = HEXCOLOR(pinColorLightGray);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = HEXCOLOR(pinColorMainBackground);
    return cell;
}

- (UICollectionViewCell *)blankContentCellWithCollectionView:(UICollectionView *)collectionView
                                                   indexPath:(NSIndexPath *)indexPath
                                                  noDataText:(NSString *)noDataText
                                                  nullCellID:(NSString *)nullCellID {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:nullCellID forIndexPath:indexPath];
    [cell.contentView removeFromSuperview];
    UILabel *nullLabel = Building_UILabelWithFrameAndSuperView(cell.contentView, CGRectMake(0, 0, SCREEN_WITH, cell.height), Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentCenter, 0);
    nullLabel.text = noDataText;
    nullLabel.backgroundColor = HEXCOLOR(pinColorMainBackground);
    return cell;
}

@end
