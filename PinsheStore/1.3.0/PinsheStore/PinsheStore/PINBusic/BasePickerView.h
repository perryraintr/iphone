//
//  BasePickerView.h
//  BasePickerView
//
//  Created by shiyaorong on 13-3-29.
//  Copyright (c) 2013年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate> {
	UIPickerView  *picker;
	UIToolbar *toolBar;
	int selectedRow;
}

- (id)initWithTitle:(NSString *)toolBarTitle;
- (void)showInView:(UIView *)view;
- (void)selectCancelAction;
@end
