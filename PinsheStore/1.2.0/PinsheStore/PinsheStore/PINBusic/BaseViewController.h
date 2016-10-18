//
//  BaseViewController.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PINMainModuleService.h"
#import "PINNavigationController.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) PINMainModuleService *httpService;
@property (nonatomic, strong) NSMutableDictionary *postParams; // 传参
@property (nonatomic, strong) PINNavigationController *navigationController;

- (void)setTitleImage; // 设置bar的titleView
- (void)leftBarButton:(NSString *)aTitle isRoot:(BOOL)isRoot color:(UIColor *)color selector:(SEL)sel delegate:(id)delegate;
- (void)rightBarButton:(NSString *)aTitle isRoot:(BOOL)isRoot color:(UIColor *)color selector:(SEL)sel delegate:(id)delegate;
- (void)indexLeftBarButtonWithImage:(NSString *)imageName selector:(SEL)sel delegate:(id)delegate isIndex:(BOOL)isIndex;
- (void)indexRightBarButtonWithImage:(NSString *)imageName selector:(SEL)sel delegate:(id)delegate isIndex:(BOOL)isIndex;
- (void)resetNavigationItemTiltView:(UIView *)titleView withTitleArray:(NSArray *)titleArray sel:(SEL)sel delegate:(id)delegate tag:(NSInteger)tag isParentItem:(BOOL)isParentItem isIndex:(BOOL)isIndex;

- (void)initBaseParams;
- (void)initParams;
- (void)initUI;

- (void)backAction;
- (void)backActionAnimated:(BOOL)animated; // pop返回

- (UIView *)findFirstResponder;
- (void)addKeyboardNotification;
- (void)removeKeyboardNotification;

// 选择相册
- (UIActionSheet *)createSheet:(id)delegate;
- (NSInteger)imagePickerController:(NSInteger)buttonIndex;

//- (BOOL)isErrorResponseData:(PinResponseResult *)request;

- (UITableViewCell *)blankContentCellWithTableView:(UITableView *)tableView
                                         indexPath:(NSIndexPath *)indexPath
                                        noDataText:(NSString *)noDataText;
- (UICollectionViewCell *)blankContentCellWithCollectionView:(UICollectionView *)collectionView
                                                   indexPath:(NSIndexPath *)indexPath
                                                  noDataText:(NSString *)noDataText
                                                  nullCellID:(NSString *)nullCellID;
@end
