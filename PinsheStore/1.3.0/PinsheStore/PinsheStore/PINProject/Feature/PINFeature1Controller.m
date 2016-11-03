//
//  PINFeature1Controller.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/3.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINFeature1Controller.h"
#import "PlainCellBgView.h"
#import "PINStoreFeatureModel.h"

@interface PINFeature1Controller () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *featureArray;

@end

@implementation PINFeature1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParams];
    [self requestStoreFeature1];
}

- (void)initParams {
    self.featureArray = [NSMutableArray array];
}

- (void)requestStoreFeature1 {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.httpService store_feature1_imageWithFinished:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            PINStoreFeatureModel *storeFeatureModel = [PINStoreFeatureModel modelWithDictionary:dic];
            [self.featureArray addObject:storeFeatureModel];
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self chatShowHint:@"请求失败"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.featureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

@end
