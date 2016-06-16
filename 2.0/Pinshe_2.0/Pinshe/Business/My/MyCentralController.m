//
//  MyCentralController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "MyCentralController.h"
#import "MyCentralSegmentView.h"
#import "PinUser.h"
#import "MyWishModel.h"
#import "MyWishVoteModel.h"
#import "MyWishPostModel.h"
#import "MyPublishModel.h"
#import "MyPublishVoteModel.h"
#import "MyPublishPostModel.h"
#import "MyPublishCell.h"
#import "MyWishCell.h"
#import "PinTabBarController.h"

@interface MyCentralController () <UITableViewDelegate, UITableViewDataSource> {
    float offY1;
    float offY2;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) MyCentralSegmentView *segmentView;
@property (strong, nonatomic) UIImageView *backImageview;
@property (strong, nonatomic) UIImageView *headImageview;
@property (strong, nonatomic) UILabel *nameLabel;

@property (assign, nonatomic) NSInteger tapIndex;
@property (assign, nonatomic) int currentPage1;
@property (assign, nonatomic) int currentPage2;

@property (strong, nonatomic) NSMutableArray *collectArray;
@property (strong, nonatomic) NSMutableArray *publishArray;

@property (assign, nonatomic) BOOL isLastCollect;
@property (assign, nonatomic) BOOL isLastPublish;

@end

@implementation MyCentralController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(pinColorMainBackground);
    [self initParams];
    [self initUI];
    [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 0;
    [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 0;
    [self collectionRequest:NO withIndicatorStyle: PinIndicatorStyle_DefaultIndicator];
    [self publishRequest:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PinTabBarController *pinTabBar = pinTabBarController();
    [pinTabBar messageCountRequest];
    
    [super indexRightBarButtonWithImage:@"setting" selector:@selector(settingAction) delegate:self isIndex:YES];
    [self updateUserInfo];
    
    if ([PINBaseRefreshSingleton instance].refreshMyCentralCollection == 1) {
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 0;
        [self collectionRequest:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
    if ([PINBaseRefreshSingleton instance].refreshMyCentralPublish == 1) {
        [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 0;
        [self publishRequest:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initParams {
    self.tapIndex = 0;
    self.currentPage1 = 1;
    self.currentPage2 = 1;
    self.collectArray = [NSMutableArray array];
    self.publishArray = [NSMutableArray array];
}

- (void)initUI {
    self.tableview.tableHeaderView = [self creatTableHeadView];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.segmentView = [[MyCentralSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 44)];
    [self.segmentView segmentChangeSelect:^(NSUInteger index) {
        [self segmentChangeSelect:index];
    }];
    
    weakSelf(self);
    [self.tableview addRefreshHeaderWithCompletion:^{
        [weakSelf dragUpAction];
    }];
}

- (void)updateUserInfo {
    [self.backImageview sd_setImageWithURL:[NSURL URLWithString:[UserDefaultManagement instance].pinUser.avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString:[UserDefaultManagement instance].pinUser.avatar] placeholderImage:IMG_Name(@"picPlaceholderImage")];
    self.nameLabel.text = [UserDefaultManagement instance].pinUser.name;
    self.title = [UserDefaultManagement instance].pinUser.name;
}

- (void)segmentChangeSelect:(NSInteger)index {
    CGRect rect = [self.tableview rectForHeaderInSection:(self.tableview.numberOfSections - 1)];
    if (floorf(self.tableview.contentOffset.y + 64) >= floorf(rect.origin.y)) {
        if (self.tapIndex == 0) {
            offY1 = self.tableview.contentOffset.y;
        } else {
            offY2 = self.tableview.contentOffset.y;
        }
        [self.tableview setContentOffset:CGPointMake(0, index == 0 ? MAX(rect.origin.y - 64, offY1) : MAX(rect.origin.y - 64, offY2))];
    } else {
        offY1 = 0;
        offY2 = 0;
    }
    self.tapIndex = index;
    [self resetTapCell];
}

- (void)resetTapCell {
    [self.tableview reloadData];
    [self.tableview endRefreshing];
    if (self.tapIndex == 0) {
        if (self.collectArray.count > 0) {
            [self.tableview addFooter:self.isLastCollect];
        } else {
            [self.tableview addFooter:NO];
        }
    } else {
        if (self.publishArray.count > 0) {
            [self.tableview addFooter:self.isLastPublish];
        } else {
            [self.tableview addFooter:NO];
        }
    }
    
}

- (void)collectionRequest:(BOOL)isDragup withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    
    self.currentPage1 = isDragup ? (self.currentPage1 + 1) : 1;
    
    [self.httpService myCentralRequestWithMethodName:@"wish.a" indicatorStyle:indicatorStyle  currentPage:self.currentPage1 finished:^(NSDictionary *result, NSString *message) {
        
        if (self.currentPage1 == 1) {
            [self.collectArray removeAllObjects];
        }
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            MyWishModel *myWishModel = [[MyWishModel alloc] init];
            myWishModel.type = [[dic objectForKey:@"type"] intValue];
            if ([[dic objectForKey:@"type"] intValue] == 3) {
                myWishModel.myVoteModel = [MyWishVoteModel modelWithDictionary:dic];
                myWishModel.myPostModel = nil;
            } else {
                myWishModel.myPostModel = [MyWishPostModel modelWithDictionary:dic];
                myWishModel.myVoteModel = nil;
            }
            [self.collectArray addObject:myWishModel];
        }
        [self.tableview reloadData];
        
        if (self.tableview.mj_footer == nil && self.collectArray.count == REQUEST_FOOTER_SIZE) {
            weakSelf(self);
            [self.tableview addRefreshFooterWithCompletion:^{
                [weakSelf dragDownAction];
            }];
        }
        [self.tableview endRefreshing];
        self.isLastCollect = XONE_Dic_Is_Valid(result) ? YES : NO;
        [self.tableview addFooter:self.isLastCollect];

    } failure:^(NSDictionary *result, NSString *message) {
        [self.tableview endRefreshing];
    }];
}

- (void)publishRequest:(BOOL)isDragup withIndicatorStyle:(PinIndicatorStyle)indicatorStyle {
    
    self.currentPage2 = isDragup ? (self.currentPage2 + 1) : 1;
    [self.httpService myCentralRequestWithMethodName:@"publish.a" indicatorStyle:indicatorStyle currentPage:self.currentPage2 finished:^(NSDictionary *result, NSString *message) {
        
        if (self.currentPage2 == 1) {
            [self.publishArray removeAllObjects];
        }
        
        for (NSDictionary *dic in [result objectForKey:@"array"]) {
            MyPublishModel *myPublishModel = [[MyPublishModel alloc] init];
            myPublishModel.type = [[dic objectForKey:@"type"] intValue];
            if ([[dic objectForKey:@"type"] intValue] == 3) {
                myPublishModel.myVoteModel = [MyPublishVoteModel modelWithDictionary:dic];
                myPublishModel.myPostModel = nil;
            } else {
                myPublishModel.myVoteModel = nil;
                myPublishModel.myPostModel = [MyPublishPostModel modelWithDictionary:dic];
            }
            [self.publishArray addObject:myPublishModel];
        }
        [self.tableview reloadData];
        
        if (self.tableview.mj_footer == nil && self.publishArray.count == REQUEST_FOOTER_SIZE) {
            weakSelf(self);
            [self.tableview addRefreshFooterWithCompletion:^{
                [weakSelf dragDownAction];
            }];
        }
        [self.tableview endRefreshing];
        self.isLastPublish = XONE_Dic_Is_Valid(result) ? YES : NO;
        [self.tableview addFooter:self.isLastPublish];
        
    } failure:^(NSDictionary *result, NSString *message) {
        [self.tableview endRefreshing];
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    } else {
        CGFloat nullHeight = SCREEN_HEIGHT - FITHEIGHT(299) - 108;
        if (self.tapIndex == 0) {
            if (self.collectArray.count > 0) {
                return (FITHEIGHT(375) + 10) * ((self.collectArray.count + 1) / 2) + 10;
            } else {
                return nullHeight;
            }
        } else if (self.tapIndex == 1) {
            if (self.publishArray.count > 0) {
                return (FITHEIGHT(246) + 10) * ((self.publishArray.count + 1) / 2) + 10;
            } else {
                return nullHeight;
            }
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *sectionCellId = @"infoListCellId";
        UITableViewCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:sectionCellId];
        if (!sectionCell) {
            sectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionCellId];
            [sectionCell addSubview:_segmentView];
        }
        sectionCell.backgroundView = [PlainCellBgView cellBgWithSelected:NO needFirstCellTopLine:YES];
        return sectionCell;
    } else {
        if (self.tapIndex == 0) {
            if (self.collectArray.count == 0) {
                return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"您还没有收藏哦！"];
            } else {
                static NSString *myCollectCellId = @"myCollectCellId";
                MyWishCell *myCollectCell = [tableView dequeueReusableCellWithIdentifier:myCollectCellId];
                if (!myCollectCell) {
                    myCollectCell = [[MyWishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCollectCellId];
                }
                [myCollectCell resetMyWishCell:self.collectArray];
                [myCollectCell wishPushDetail:^(MyWishModel *myWishModel) {
                    [self myCollectPushDetail:myWishModel];
                }];
                [myCollectCell wishSupoort:^(MyWishModel *myWishModel) {
                    [self myCollectSupport:myWishModel];
                }];
                return myCollectCell;
            }
        } else if (self.tapIndex == 1) {
            if (self.publishArray.count == 0) {
                return [super blankContentCellWithTableView:tableView indexPath:indexPath noDataText:@"您还没有发布哦！"];
            } else {
                static NSString *myPublishCellId = @"myPublishCellId";
                MyPublishCell *myPublishCell = [tableView dequeueReusableCellWithIdentifier:myPublishCellId];
                if (!myPublishCell) {
                    myPublishCell = [[MyPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPublishCellId];
                }
                [myPublishCell resetMyPublishCell:self.publishArray];
                [myPublishCell editAction:^(NSInteger tag) {
                    [self myPublishEditAction:tag];
                }];
                
                return myPublishCell;
            }
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)dragUpAction {
    if (self.tapIndex == 0) {
        [self collectionRequest:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    } else {
        [self publishRequest:NO withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
}

- (void)dragDownAction {
    if (self.tapIndex == 0) {
        [self collectionRequest:YES withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    } else {
        [self publishRequest:YES withIndicatorStyle:PinIndicatorStyle_NoIndicator];
    }
}

#pragma mark -
#pragma mark Button Action
- (void)myCollectSupport:(MyWishModel *)mywishModel {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:mywishModel forKey:@"myWishModel"];
    
    if (mywishModel.type == PinMyCentralType_CentralComapre) { // 品选
        NSString *paramString = [NSString stringWithFormat:@"vid=%zd", mywishModel.myVoteModel.vote_guid];
        if (mywishModel.myVoteModel.favorite_guid == 0) { // 添加赞
            
            mywishModel.myVoteModel.favorite_guid = 1;
            mywishModel.myVoteModel.vote_favorite += 1;
            // 不需要加载动画
            [self.httpService zanRequestWithMethodName:@"addfavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
                [self.tableview reloadData];
            } failure:^(NSDictionary *result, NSString *message) {
                mywishModel.myVoteModel.favorite_guid = 0;
                mywishModel.myVoteModel.vote_favorite -= 1;
            }];
            
        } else { // 移除赞
            mywishModel.myVoteModel.favorite_guid = 0;
            mywishModel.myVoteModel.vote_favorite -= 1;
            // 不需要加载动画
            [self.httpService zanRequestWithMethodName:@"removefavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
                [self.tableview reloadData];
            } failure:^(NSDictionary *result, NSString *message) {
                mywishModel.myVoteModel.favorite_guid = 1;
                mywishModel.myVoteModel.vote_favorite += 1;
            }];
        }
    } else {
        NSString *paramString = [NSString stringWithFormat:@"pid=%zd", mywishModel.myPostModel.post_guid];
        if (mywishModel.myPostModel.favorite_guid == 0) { // 添加赞
            mywishModel.myPostModel.favorite_guid = 1;
            mywishModel.myPostModel.post_favorite += 1;
            // 不需要加载动画
            [self.httpService zanRequestWithMethodName:@"addfavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
                [self.tableview reloadData];
            } failure:^(NSDictionary *result, NSString *message) {
                mywishModel.myPostModel.favorite_guid = 0;
                mywishModel.myPostModel.post_favorite -= 1;
            }];
        } else { // 移除赞
            mywishModel.myPostModel.favorite_guid = 0;
            mywishModel.myPostModel.post_favorite -= 1;
            // 不需要加载动画
            [self.httpService zanRequestWithMethodName:@"removefavorite.a" zanId:paramString finished:^(NSDictionary *result, NSString *message) {
                [self.tableview reloadData];
            } failure:^(NSDictionary *result, NSString *message) {
                mywishModel.myPostModel.favorite_guid = 1;
                mywishModel.myPostModel.post_favorite += 1;
            }];
        }
    }
}

- (void)myCollectPushDetail:(MyWishModel *)model {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *pushName = @"";
    if (model.type == PinMyCentralType_CentralComapre) {
        [userInfo setObject:[NSNumber numberWithInteger:model.myVoteModel.vote_guid] forKey:@"id"];
        pushName = FORWARD_DEATILCOMPARE_VC;
    } else {
        [userInfo setObject:[NSNumber numberWithInteger:model.myPostModel.post_guid] forKey:@"id"];
        pushName = (model.type == PinMyCentralType_CentralRecommed ? FORWARD_DETAILRECOMMEND_VC : FORWARD_DETAILSHIT_VC);
    }
    [[ForwardContainer shareInstance] pushContainer:pushName navigationController:self.navigationController params:userInfo animated:NO];
    [NSObject event:@"WD003" label:@"点击收藏的产品"];
}

- (void)myPublishEditAction:(NSInteger)tag {
    [NSObject event:@"WD002" label:@"编辑发布信息"];
    MyPublishModel *myPublishModel = [self.publishArray objectAtIndex:tag];
    if (myPublishModel.type == PinMyCentralType_CentralComapre) { // 品选发布页
        PinNavigationController *navigationController = [[PinNavigationController alloc] init];
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        [paramsDic setObject:myPublishModel.myVoteModel.vote_name forKey:@"myPublishTitle"];
        [paramsDic setObject:myPublishModel.myVoteModel.posta_description forKey:@"myPublishDescription"];
        [paramsDic setObject:myPublishModel.myVoteModel.posta_image forKey:@"myPublishImage1Url"];
        [paramsDic setObject:myPublishModel.myVoteModel.postb_image forKey:@"myPublishImage2Url"];
        [paramsDic setObject:[NSNumber numberWithInt:myPublishModel.myVoteModel.vote_guid] forKey:@"id"];
        [[ForwardContainer shareInstance] pushContainer:FORWARD_EDITCOMPARE_VC  navigationController:navigationController params:paramsDic animated:NO];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    } else { // 编辑推荐吐槽发布页
        PinNavigationController *navigationController = [[PinNavigationController alloc] init];
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        [paramsDic setObject:[NSNumber numberWithInt:myPublishModel.myPostModel.post_guid] forKey:@"id"];
        [paramsDic setObject:myPublishModel.myPostModel.tag_t2.count > 0 ? myPublishModel.myPostModel.tag_t2 : [NSArray array] forKey:@"myPublishTag2Array"];
        [[ForwardContainer shareInstance] pushContainer:myPublishModel.type == PinMyCentralType_CentralRecommed ? FORWARD_EDITRECOMMEND_VC : FORWARD_EDITSHIT_VC navigationController:navigationController params:paramsDic animated:NO];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)settingAction { // 系统设置
    [[ForwardContainer shareInstance] pushContainer:FORWARD_SYSTEMSETTING navigationController:self.navigationController params:nil animated:NO];
}

- (void)installedButtonAction { // 个人信息
    [NSObject event:@"WD001" label:@"修改个人信息"];
    PinNavigationController *navigationController = [[PinNavigationController alloc] init];
    [[ForwardContainer shareInstance] pushContainer:FORWARD_MYINSTALL_VC navigationController:navigationController params:nil animated:YES];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];

}

#pragma mark -
#pragma mark createHeaderView
- (UIView *)creatTableHeadView {
    UIView *headView = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, FITHEIGHT(250)));
    self.backImageview = Building_UIImageViewWithSuperView(headView, IMG_Name(@""));
    self.backImageview.clipsToBounds = YES;
    self.backImageview.contentMode = UIViewContentModeScaleAspectFill;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.contentView.alpha = .65;
    [headView addSubview:effectView];
    
    UIImageView *headBackImageview = Building_UIImageViewWithSuperView(headView, IMG_Name(@"myHeadback"));
    self.headImageview = Building_UIImageViewWithSuperView(headView, nil);
    self.headImageview.layer.cornerRadius = (FITWITH(91) - 8) / 2.0;
    self.headImageview.layer.masksToBounds = YES;
    self.nameLabel = Building_UILabelWithSuperView(headView, Font(fFont12), HEXCOLOR(pinColorWhite), NSTextAlignmentCenter, 1);
    
    UIButton *installedButton = Building_UIButtonWithSuperView(headView, self, @selector(installedButtonAction), nil);
    [installedButton setImage:IMG_Name(@"mySetting") forState:UIControlStateNormal];
    [installedButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.backImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(headView);
    }];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(headView);
    }];
    
    [headBackImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.centerY.equalTo(headView).offset(-20);
        make.width.height.equalTo(@(FITWITH(91)));
    }];
    
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headBackImageview).offset(4);
        make.right.bottom.equalTo(headBackImageview).offset(-4);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headView);
        make.top.equalTo(self.headImageview.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];
    
    [installedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.bottom.equalTo(headView).offset(-FITHEIGHT(30));
        make.width.equalTo(@(FITWITH(129) + 20));
        make.height.equalTo(@(FITHEIGHT(24) + 20));
    }];
    
    return headView;
}

@end
