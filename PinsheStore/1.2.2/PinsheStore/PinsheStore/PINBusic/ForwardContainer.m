//
//  ForwardContainer.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "ForwardContainer.h"

@implementation ForwardContainer
+ (ForwardContainer *)shareInstance {
    static ForwardContainer *forwardContainer = nil;
    static dispatch_once_t onceToken1;
    
    dispatch_once(&onceToken1, ^{
        forwardContainer = [[self alloc] init];
    });
    return forwardContainer;
}

- (void)pushContainer:(NSString *)methodName
 navigationController:(PINNavigationController *)navigationController
               params:(NSMutableDictionary *)params
             animated:(BOOL)animated {
    id viewController = [[CLASS(methodName) alloc] init];
    if ([viewController isKindOfClass:CLASS(@"BaseViewController")]) {
        ((BaseViewController *)viewController).postParams = params;
    }
    [navigationController pushViewController:viewController animated:animated];
}

@end
