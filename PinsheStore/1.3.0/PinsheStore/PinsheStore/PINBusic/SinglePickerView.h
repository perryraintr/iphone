//
//  SinglePickerView.h
//  SinglePickerView
//
//  Created by shiyaorong on 13-5-22.
//  Copyright (c) 2013年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePickerView.h"

@interface SinglePickerView : BasePickerView {
    NSInteger index;
    NSArray *dataArray;
    NSIndexPath *indexPath;
}

@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSString *defaultValue;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
