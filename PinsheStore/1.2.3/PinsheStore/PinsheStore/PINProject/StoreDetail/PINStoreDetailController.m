//
//  PINStoreDetailController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreDetailController.h"
#import "PINStoreModel.h"
#import "XRCarouselView.h"

@interface PINStoreDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) PINStoreModel *pinStoreModel;

@end

@implementation PINStoreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initBaseParams {
    self.pinStoreModel = [self.postParams objectForKey:@"storeModel"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XRCarouselView clearDiskCache];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_WITH * 900 / 1242.0;
    } else {
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *loopScrollCellId = @"loopScrollCellId";
        UITableViewCell *loopScrollCell = [tableView dequeueReusableCellWithIdentifier:loopScrollCellId];
        if (loopScrollCell == nil) {
            loopScrollCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loopScrollCellId];
            XRCarouselView *xRCarouseView = [XRCarouselView carouselViewWithImageArray:self.pinStoreModel.images describeArray:nil];
            xRCarouseView.time = 3;
            [xRCarouseView setPageColor:HEXCOLOR(pinColorTextLightGray) andCurrentPageColor:HEXCOLOR(pinColorDarkBlack)];
            xRCarouseView.pagePosition = PositionBottomCenter;
            [loopScrollCell.contentView addSubview:xRCarouseView];
            [xRCarouseView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(loopScrollCell.contentView);
            }];
        }
        return loopScrollCell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

@end
