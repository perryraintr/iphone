//
//  SinglePickerView.m
//  SinglePickerView
//
//  Created by shiyaorong on 13-5-22.
//  Copyright (c) 2013年 shiyaorong. All rights reserved.
//

#import "SinglePickerView.h"

@implementation SinglePickerView
@synthesize dataArray, defaultValue, indexPath;

- (id)initWithTitle:(NSString *)toolBarTitle {
    if (self = [super initWithTitle:toolBarTitle]) {
        index = 0;
    }
    return self;
}

- (void)setIndex:(int)_index {
    index = _index;
    [picker selectRow:index inComponent:0 animated:NO];
}

- (void)setDefaultValue:(NSString *)_defaultValue {
    if ([_defaultValue length] == 0) {
        index = 0;
    } else {
        for (int i = 0; i < [dataArray count]; i++) {
            if ([_defaultValue isEqualToString:[dataArray objectAtIndex:i]]) {
                index = i;
                break;
            }
        }
        
    }
    [picker selectRow:index inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [dataArray count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WITH - 40, 40)];
	label.backgroundColor = [UIColor clearColor];
	label.font = FontBold(fFont18);
    label.textAlignment = NSTextAlignmentLeft;
	label.text = [dataArray objectAtIndex:row];
	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    index = row;
}

- (void)selectAction {
	if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"selectPickerBack:withIndexPath:")]) {
		SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"selectPickerBack:withIndexPath:") withObject:[dataArray objectAtIndex:index] withObject:indexPath])
	}
    if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"selectPickerBack:withIndex:")]) {
		SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"selectPickerBack:withIndex:") withObject:[dataArray objectAtIndex:index] withObject:[NSNumber numberWithInteger:index]])
	}
	[self selectCancelAction];
}

- (void)selectCancelAction {
    [super selectCancelAction];
    
    if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"selectPickerCancel")]) {
        SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"selectPickerCancel")])
    }
}

- (void)showInView:(UIView *)view {
    [super showInView:view];
}

@end
