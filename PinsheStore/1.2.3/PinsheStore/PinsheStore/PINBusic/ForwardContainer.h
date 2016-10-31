//
//  ForwardContainer.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PINNavigationController;
@interface ForwardContainer : NSObject

+ (ForwardContainer *)shareInstance;
- (void)pushContainer:(NSString *)methodName
 navigationController:(PINNavigationController *)navigationController
               params:(NSMutableDictionary *)params
             animated:(BOOL)animated;
@end
