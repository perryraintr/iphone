//
//  PINFeature2Controller.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/3.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINFeature2Controller.h"
#import "PlainCellBgView.h"
#import "PINStoreFeatureModel.h"
#import "PINFeatureCell.h"

@interface PINFeature2Controller () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *featureArray;

@property (strong, nonatomic) NSArray *paramFeatureArray;

@property (weak, nonatomic) id delegate;

@end

@implementation PINFeature2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self initUI];
    [self requestStoreFeature2];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.delegate = nil;
}

- (void)initBaseParams {
    self.delegate = [self.postParams objectForKey:@"delegate"];
    self.paramFeatureArray = [self.postParams objectForKey:@"feature2s"];
}

- (void)initParams {
    self.featureArray = [NSMutableArray array];
}

- (void)initUI {
    [super rightBarButton:@"保存" isRoot:NO color:HEXCOLOR(pinColorWhite) selector:@selector(saveFeature) delegate:self];
}

- (void)requestStoreFeature2 {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.httpService store_feature2_imageWithFinished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINStoreFeatureModel *storeFeatureModel = [PINStoreFeatureModel modelWithDictionary:dic];
            storeFeatureModel.isChoosed = NO;
            for (PINStoreFeatureModel *model in self.paramFeatureArray) {
                if (storeFeatureModel.guid == model.guid) {
                    storeFeatureModel.isChoosed = YES;
                }
            }
            [self.featureArray addObject:storeFeatureModel];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"请求失败"];
    }];
}

#pragma mark ---
#pragma mark Button Action
- (void)saveFeature {
    NSMutableArray *featureArray = [NSMutableArray array];
    for (PINStoreFeatureModel *model in self.featureArray) {
        if (model.isChoosed) {
            [featureArray addObject:model];
        }
    }
    
    if (featureArray.count == 0) {
        [self chatShowHint:@"请至少选择一项特色"];
        return;
    } else {
        if (featureArray.count > 8) {
            [self chatShowHint:@"特色最多可选8项"];
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"resetFeature2:")]) {
            SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"resetFeature2:") withObject:featureArray]);
            [super backAction];
        }
    }
    PLog(@"featureArray : %@", featureArray);
    
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.featureArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 10));
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 10));
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *featureCellId = @"featureCellId";
    PINFeatureCell *featureCell = [tableView dequeueReusableCellWithIdentifier:featureCellId];
    if (featureCell == nil) {
        featureCell = [[PINFeatureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:featureCellId];
    }
    PINStoreFeatureModel *model = [self.featureArray objectAtIndex:indexPath.row];
    featureCell.nameLabel.text = model.name;
    if (model.isChoosed) {
        featureCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        featureCell.accessoryType = UITableViewCellAccessoryNone;
    }
    featureCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
    return featureCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PINStoreFeatureModel *model = [self.featureArray objectAtIndex:indexPath.row];
    model.isChoosed = !model.isChoosed;
    [self.tableview reloadData];
}

@end
