//
//  PinTabBarController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PinTabBarController.h"
#import "PinTabBar.h"
#import "PinNavigationController.h"
#import "IndexRecommendController.h"

@interface PinTabBarController () <PinTabBarDelegate> {
    PinTabBar *tabBar;
    NSArray *tabBarItems;
}

@property (nonatomic, strong) UIView *pinMessageCircle;

@end

@implementation PinTabBarController

- (id) init {
    self = [super init];
    if (self) {
        BaseViewController *baseViewController0 = [[[[PinTabBarController tabBarControllerClasses] objectAtIndex:0] alloc] init];
        BaseViewController *baseViewController1 = [[[[PinTabBarController tabBarControllerClasses] objectAtIndex:1] alloc] init];
        if (isWXAppInstalled()) { // 安装微信
            BaseViewController *baseViewController2 = [[[[PinTabBarController tabBarControllerClasses] objectAtIndex:2] alloc] init];
            tabBarItems = [[NSArray alloc] initWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon0.png", @"image", baseViewController0, @"viewController", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon1.png", @"image", baseViewController1, @"viewController", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon2.png", @"image", baseViewController2, @"viewController", nil], nil];
        } else { // 没安装微信
            tabBarItems = [[NSArray alloc] initWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon0.png", @"image", baseViewController0, @"viewController", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon1.png", @"image", baseViewController1, @"viewController", nil], nil];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = -1;
    tabBar = [[PinTabBar alloc] initWithItemCount:tabBarItems.count
                                        itemSize:CGSizeMake(SCREEN_WITH/tabBarItems.count, TABBAR_HEIGHT)
                                             tag:0
                                        delegate:self];
    tabBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tabBar];
    
    [tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(TABBAR_HEIGHT);
    }];
    self.selectedIndex = 0;
    
}

#pragma mark -
#pragma mark CustomTabBarDelegate

- (UIImage *)imageFor:(PinTabBar *)tabBar atIndex:(NSUInteger)itemIndex {
    NSDictionary *data = [tabBarItems objectAtIndex:itemIndex];
    return [UIImage imageNamed:[data objectForKey:@"image"]];
}

- (UIImage *)tabBarArrowImage {
    return IMG_Name(@"tabBarSelection.png");
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex == _selectedIndex) {
        return;
    }
    _selectedIndex = itemIndex;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.title = nil;
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    NSDictionary *data = [tabBarItems objectAtIndex:itemIndex];
    BaseViewController *selectedViewController = [data objectForKey:@"viewController"];
    [self addChildViewController:selectedViewController];
    
    for (NSInteger i = 0; i < tabBarItems.count; i++) {
        NSDictionary *data = [tabBarItems objectAtIndex:i];
        BaseViewController *unSelectedViewController = [data objectForKey:@"viewController"];
        if (i != itemIndex) {
            if ([self.view viewWithTag:i - 24680]) {
                [unSelectedViewController.view removeFromSuperview];
            }
        }
    }
    
    selectedViewController.view.tag = itemIndex - 24680;
    [self.view addSubview:selectedViewController.view];
    [self.view bringSubviewToFront:tabBar];
    [selectedViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(TABBAR_HEIGHT - FITHEIGHT(7)));
    }];
    
    if (selectedViewController.title.length > 0) {
        self.title = selectedViewController.title;
    }
}

#pragma mark ---
#pragma mark 内部方法
- (void)setSelectedIndex:(NSUInteger)index {
    [tabBar selectItemAtIndex:index];
    [self touchDownAtItemAtIndex:index];
}

- (BaseViewController *)getSelectedViewController {
    NSDictionary *lastData = [tabBarItems objectAtIndex:_selectedIndex];
    BaseViewController *viewController = [lastData objectForKey:@"viewController"];
    return viewController;
}

+ (NSArray *)tabBarControllerClasses {
    return @[CLASS(FORWARD_INDEXACTIVITY_VC),
             CLASS(FORWARD_INDEXRECOMMEND_VC),
             CLASS(FORWARD_MYCENTRAL_VC)];
}

#pragma mark AFNetworkRequestDelegate Method
- (void)messageCountRequest {
    [self.httpService messageCountRequestWithFinished:^(NSDictionary *result, NSString *message) {
        int badgeNumber = [[result objectForKey:@"count"] intValue];
        [UserDefaultManagement instance].messageCount = badgeNumber;
        self.pinMessageCircle.hidden = (badgeNumber > 0 ? NO : YES);
        [self freshMessageLeftBar];
    } failure:^(NSDictionary *result, NSString *message) {
    }];
}

- (UIView *)pinMessageCircle {
    if (!_pinMessageCircle) {
        CGFloat itemWidth = CGRectGetWidth(self.view.frame) / tabBarItems.count;
        CGFloat x = itemWidth + itemWidth / 2 + FITWITH(10);
        CGFloat y = FITHEIGHT(10);
        _pinMessageCircle = [[UIView alloc] initWithFrame:CGRectMake(x, y, FITWITH(10), FITWITH(10))];
        _pinMessageCircle.backgroundColor = HEXCOLOR(pinColorRed);
        _pinMessageCircle.clipsToBounds = YES;
        _pinMessageCircle.hidden = NO;
        _pinMessageCircle.layer.cornerRadius = CGRectGetWidth(_pinMessageCircle.bounds) / 2;
        [tabBar addSubview:self.pinMessageCircle];
    }
    return _pinMessageCircle;
}

- (NSInteger)findIndexRecommend {
    NSInteger ret = NSNotFound;
    for (int i=0; i< tabBarItems.count; i++) {
        NSDictionary *vcDic = tabBarItems[i];
        id vc = [vcDic objectForKey:@"viewController"];
        if ([vc isKindOfClass:[IndexRecommendController class]]) {
            ret = i;
        }
    }
    assert(ret != NSNotFound);
    return ret;
}

- (void)freshMessageLeftBar {
    if ([[tabBarItems objectAtIndex:[self findIndexRecommend]] objectForKey:@"viewController"]) {
        [(IndexRecommendController *)[[tabBarItems objectAtIndex:[self findIndexRecommend]]objectForKey:@"viewController"] createLeftBar];
    }
}

@end
