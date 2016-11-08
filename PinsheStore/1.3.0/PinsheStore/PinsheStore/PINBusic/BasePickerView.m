//
//  BasePickerView.m
//  BasePickerView
//
//  Created by shiyaorong on 13-3-29.
//  Copyright (c) 2013年 shiyaorong. All rights reserved.
//

#import "BasePickerView.h"
#import "Masonry.h"

#define ToolBarHeight    44
#define PickerHeight     216

@implementation BasePickerView

//
- (id)initWithTitle:(NSString *)toolBarTitle {
    if (self = [super init]) {
		picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
		picker.delegate = self;
        picker.dataSource = self;
		picker.showsSelectionIndicator = YES;
        picker.backgroundColor = HEXCOLOR(pinColorMainBackground);
		[self addSubview:picker];
        
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(SCREEN_HEIGHT));
            make.left.equalTo(self);
            make.height.mas_equalTo(@(PickerHeight));
            make.bottom.equalTo(self);
        }];
        
		toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		toolBar.barStyle = UIBarStyleDefault;
        toolBar.translucent = YES;
		[toolBar sizeToFit];
        
        //CancelBtn
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:HEXCOLOR(pinColorRed) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = FontNotSou(fFont14);
        cancelButton.frame = CGRectMake(0, 0, 36, 29);
        [cancelButton addTarget:self action:@selector(selectCancelAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        
		UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = HEXCOLOR(pinColorDarkBlack);
        titleLabel.font = Font(fFont18);
        titleLabel.text = toolBarTitle;
        titleLabel.shadowColor = HEXCOLOR(pinColorTextLightGray);
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
		UIBarButtonItem *titleBtn = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
        
		UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        //DoneBtn
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:HEXCOLOR(pinColorRed) forState:UIControlStateNormal];
        confirmButton.titleLabel.font = FontNotSou(fFont14);
        confirmButton.frame = CGRectMake(0, 0, 36, 29);
        [confirmButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
		
		[toolBar setItems:[NSArray arrayWithObjects:cancelBtn, flexItem1, titleBtn, flexItem2, confirmBtn, nil] animated:NO];
		
		[self addSubview:toolBar];
    }
    return self;
}

- (void)layoutFrame:(CGRect)frame {
	self.frame = CGRectMake(0, CGRectGetMaxY(frame), CGRectGetMaxX(frame), PickerHeight+ToolBarHeight);
	toolBar.frame = CGRectMake(0, 0, CGRectGetMaxX(frame), ToolBarHeight);
}

- (void)return2Parent {
	[self removeFromSuperview];
}

- (void)showInView:(UIView *)view {
	[self layoutFrame:view.bounds];
	[self removeFromSuperview];
	[view addSubview:self];
	[view bringSubviewToFront:self];
	
	CGRect originFrame = self.frame;
	CGRect finalFrame = CGRectMake(originFrame.origin.x, 
								   CGRectGetMinY(originFrame)-originFrame.size.height, 
								   originFrame.size.width, 
								   originFrame.size.height);
//    if (IS_IPHONE4()) {
//        finalFrame = CGRectMake(originFrame.origin.x,
//                                CGRectGetMinY(originFrame)-originFrame.size.height+44,
//                                originFrame.size.width,
//                                originFrame.size.height);
//
//    }
//	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.25f];
	self.frame = finalFrame;
	[UIView commitAnimations];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

- (void)selectCancelAction {
	CGRect originFrame = self.frame;
	CGRect finalFrame = CGRectMake(originFrame.origin.x, 
								   CGRectGetMinY(originFrame)+originFrame.size.height, 
								   originFrame.size.width, 
								   originFrame.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(return2Parent)];
	self.frame = finalFrame;
	[UIView commitAnimations];  
}

- (void)selectAction {
	[self selectCancelAction];
}
@end

