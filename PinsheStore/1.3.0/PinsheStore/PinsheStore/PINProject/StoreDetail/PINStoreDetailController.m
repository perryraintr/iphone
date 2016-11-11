//
//  PINStoreDetailController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreDetailController.h"
#import "PlainCellBgView.h"
#import "PINStoreModel.h"
#import "XRCarouselView.h"
#import "PINNameSloganCell.h"
#import "PINStoreOwnerCell.h"
#import "PINDescCell.h"
#import "PINAddressDateCell.h"
#import "PINStoreFeatureCell.h"

@interface PINStoreDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) PINStoreModel *pinStoreModel;

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) NSArray *feature1s;

@property (nonatomic, strong) NSArray *feature2s;

@end

@implementation PINStoreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.pinStoreModel.name;
    [self initParams];
}

- (void)initBaseParams {
    self.pinStoreModel = [self.postParams objectForKey:@"storeModel"];
}

- (void)initParams {
    self.isExpand = NO;
    self.feature1s = [NSArray arrayWithArray:self.pinStoreModel.resultFeature1];
    self.feature2s = [NSArray arrayWithArray:self.pinStoreModel.resultFeature2];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [XRCarouselView clearDiskCache];
}

#pragma mark -
#pragma mark - UITableviewCellDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 轮播图
        return SCREEN_WITH * 900 / 1242.0;
    } else if (indexPath.section == 1) { //slogan star
        CGFloat sloganHeight = [NSString getTextHeight:SCREEN_WITH - 30 text:self.pinStoreModel.slogan fontSize:fFont20 isSuo:YES];
        return sloganHeight + FITHEIGHT(35) + 58;
    } else if (indexPath.section == 2) { // 特色2
        return ((SCREEN_WITH - 90) / 4.0) * self.feature2s.count + 15 * (self.feature2s.count - 1) + 30;
    } else if (indexPath.section == 3) { // 创始人
        return 62;
    } else if (indexPath.section == 4) { // 咖啡馆故事
        CGFloat descHeight = [NSString getTextHeight:SCREEN_WITH - 40 text:self.pinStoreModel.storeDescription withLineHiehtMultipe:0 withLineSpacing:10 fontSize:fFont16 isSuo:YES];
        if (self.isExpand) {
            return descHeight + 20;
        } else {
            return descHeight > 200 ? 240 : descHeight + 20;
        }
        
    } else if (indexPath.section == 5) { // 地址运营时间
        CGFloat addressHeight = [NSString getTextHeight:SCREEN_WITH - 71 text:self.pinStoreModel.address fontSize:fFont16 isSuo:YES];
        CGFloat dateHeight = [NSString getTextHeight:SCREEN_WITH - 71 text:self.pinStoreModel.date fontSize:fFont16 isSuo:YES];
        CGFloat phoneHeight = [NSString getTextHeight:SCREEN_WITH - 71 text:self.pinStoreModel.phone fontSize:fFont16 isSuo:YES];
        return 50 + addressHeight + dateHeight + phoneHeight;
    } else { // 特色1
        return ((SCREEN_WITH - 90) / 4.0) * self.feature1s.count + 15 * (self.feature1s.count - 1) + 30;
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
    } else if (indexPath.section == 1) {
        static NSString *nameSloganCellId = @"nameSloganCellId";
        PINNameSloganCell *nameSloganCell = [tableView dequeueReusableCellWithIdentifier:nameSloganCellId];
        if (nameSloganCell == nil) {
            nameSloganCell = [[PINNameSloganCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameSloganCellId];
        }
        [nameSloganCell resetNameSloganCell:self.pinStoreModel];
        return nameSloganCell;
    } else if (indexPath.section == 2) {
        static NSString *storeFeatureCell2Id = @"storeFeatureCellId";
        PINStoreFeatureCell *storeFeatureCell2 = [tableView dequeueReusableCellWithIdentifier:storeFeatureCell2Id];
        if (storeFeatureCell2 == nil) {
            storeFeatureCell2 = [[PINStoreFeatureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeFeatureCell2Id];
        }
        [storeFeatureCell2 resetFeatureCell:self.feature2s];
        return storeFeatureCell2;

    } else if (indexPath.section == 3) {
        static NSString *storeOwnerCellId = @"storeOwnerCellId";
        PINStoreOwnerCell *storeOwnerCell = [tableView dequeueReusableCellWithIdentifier:storeOwnerCellId];
        if (!storeOwnerCell) {
            storeOwnerCell = [[[NSBundle mainBundle] loadNibNamed:@"PINStoreOwnerCell" owner:self options:nil] objectAtIndex:0];
        }
        if (self.pinStoreModel.avatarImage) {
            storeOwnerCell.avatarImageview.image = self.pinStoreModel.avatarImage;
        } else {
            [storeOwnerCell.avatarImageview sd_setImageWithURL:[NSURL URLWithString:self.pinStoreModel.avatar] placeholderImage:IMG_Name(@"icon")];
        }
        storeOwnerCell.ownerLabel.text = self.pinStoreModel.owner;
        return storeOwnerCell;
    } else if (indexPath.section == 4) {
        static NSString *descCellId = @"descCellId";
        PINDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:descCellId];
        if (descCell == nil) {
            descCell = [[PINDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descCellId];
        }
        [descCell resetDescCell:self.pinStoreModel isExpand:self.isExpand];
        [descCell descBlockAction:^{
            self.isExpand = YES;
            [self.tableview reloadData];
        }];
        return descCell;
    } else if (indexPath.section == 5) {
        static NSString *addressDateCellId = @"addressDateCellId";
        PINAddressDateCell *addressDateCell = [tableView dequeueReusableCellWithIdentifier:addressDateCellId];
        if (addressDateCell == nil) {
            addressDateCell = [[PINAddressDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressDateCellId];
        }
        addressDateCell.addressLabel.text = self.pinStoreModel.address;
        addressDateCell.dateLabel.text = self.pinStoreModel.date;
        addressDateCell.phoneLabel.text = self.pinStoreModel.phone;
        addressDateCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
        return addressDateCell;
    } else {
        static NSString *storeFeatureCell1Id = @"storeFeatureCellId";
        PINStoreFeatureCell *storeFeatureCell1 = [tableView dequeueReusableCellWithIdentifier:storeFeatureCell1Id];
        if (storeFeatureCell1 == nil) {
            storeFeatureCell1 = [[PINStoreFeatureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeFeatureCell1Id];
        }
        storeFeatureCell1.lineView.hidden = YES;
        [storeFeatureCell1 resetFeatureCell:self.feature1s];
        storeFeatureCell1.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:NO];
        return storeFeatureCell1;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

@end
