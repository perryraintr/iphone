//
//  PinTabBarController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINTabBarController.h"
#import "PINTabBar.h"

#define TABBAR_HEIGHT FITHEIGHT(56)

@interface PINTabBarController () <PINTabBarDelegate> {
    PINTabBar *tabBar;
    NSArray *tabBarItems;
}

@property (nonatomic, strong) UIView *pinMessageCircle;

@end

@implementation PINTabBarController

- (id) init {
    self = [super init];
    if (self) {
        BaseViewController *baseViewController0 = [[[[PINTabBarController tabBarControllerClasses] objectAtIndex:0] alloc] init];
        BaseViewController *baseViewController1 = [[[[PINTabBarController tabBarControllerClasses] objectAtIndex:1] alloc] init];
        
        tabBarItems = [[NSArray alloc] initWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon0.png", @"image", baseViewController0, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabIcon1.png", @"image", baseViewController1, @"viewController", nil],
                       nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = -1;
    tabBar = [[PINTabBar alloc] initWithItemCount:tabBarItems.count
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

- (UIImage *)imageFor:(PINTabBar *)tabBar atIndex:(NSUInteger)itemIndex {
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
//        make.bottom.mas_equalTo(self.view.mas_bottom);
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
    return @[CLASS(FORWARD_ROOT_VC), CLASS(FORWARD_MYCENTER_VC)];
}

@end
