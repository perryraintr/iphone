//
//  UIView+ClickOn.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionClickOn) (id clickOnView);

@interface UIView (ClickOn)

- (void)clickedOnViewWithCompletion:(CompletionClickOn)completion;

@end
