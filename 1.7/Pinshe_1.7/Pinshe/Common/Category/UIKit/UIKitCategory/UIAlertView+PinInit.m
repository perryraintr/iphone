//
//  UIAlertView+PinInit.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UIAlertView+PinInit.h"
static CompletionClickedBlock __clickedBlock;
static CompletionCancelBlock  __cancelBlock;

@implementation UIAlertView (PinInit)

+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                             cancel:(NSString *)cancel
                       clickedBlock:(CompletionClickedBlock)clickedBlock
                        cancelBlock:(CompletionCancelBlock)cancelBlock {
    
    __clickedBlock = [clickedBlock copy];
    __cancelBlock = [cancelBlock copy];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:nil];
    
    [alertView show];
    return alertView;
}

+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                             cancel:(NSString *)cancel
                  otherButtonTitles:(NSArray <NSString *>*)titles
                       clickedBlock:(CompletionClickedBlock)clickedBlock
                        cancelBlock:(CompletionCancelBlock)cancelBlock {
    
    __clickedBlock = [clickedBlock copy];
    __cancelBlock = [cancelBlock copy];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:nil];
    
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertView addButtonWithTitle:obj];
    }];
    
    [alertView show];
    return alertView;
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (__cancelBlock) {
            __cancelBlock();
        }
    } else {
        if (__clickedBlock) {
            __clickedBlock(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
        }
    }
}

@end
