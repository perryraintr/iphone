//
//  PINStoreListController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/28.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreListController.h"
#import "PlainCellBgView.h"
#import "PINStoreModel.h"
#import "PINStoreCell.h"

@interface PINStoreListController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *storeListArray;

@end

@implementation PINStoreListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择店铺";
    [self initParams];
    [self requestStoreList];
}

- (void)initParams {
    self.storeListArray = [NSMutableArray array];
}

- (void)requestStoreList {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.httpService storeRequestWithMid:[PINUserDefaultManagement instance].pinUser.guid finished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINStoreModel *pinStoreModel = [PINStoreModel modelWithDictionary:dic];
            [self.storeListArray addObject:pinStoreModel];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.storeListArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return FITHEIGHT(55);
    } else {
        return FITHEIGHT(70);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *titleCellId = @"cashTitleCellId";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (titleCell == nil) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.backgroundColor = [UIColor clearColor];
        }
        titleCell.textLabel.text = @"我管理的店铺";
        titleCell.textLabel.font = Font(fFont16);
        return titleCell;
    } else {
        static NSString *storeCellId = @"storeCellId";
        PINStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:storeCellId];
        if (storeCell == nil) {
            storeCell = [[PINStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellId];
        }
        PINStoreModel *pinStoreModel = [self.storeListArray objectAtIndex:indexPath.row];
        [storeCell.iconImageview sd_setImageWithURL:[NSURL URLWithString:pinStoreModel.image] placeholderImage:nil];
        storeCell.nameLabel.text = pinStoreModel.name;
        if ([PINUserDefaultManagement instance].sid == pinStoreModel.guid) {
            PLog(@"sid = %zd", [PINUserDefaultManagement instance].sid);
            storeCell.chooseImageview.hidden = NO;
        } else {
            storeCell.chooseImageview.hidden = YES;
        }
        storeCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:indexPath.row == 0];
        return storeCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PINStoreModel *pinStoreModel = [self.storeListArray objectAtIndex:indexPath.row];
    [PINUserDefaultManagement instance].sid = pinStoreModel.guid;
    [PINUserDefaultManagement instance].storeName = pinStoreModel.name;
    [PINUserDefaultManagement instance].storeCurrent = pinStoreModel.current;
    [PINAppDelegate() rootVC];
}

@end
