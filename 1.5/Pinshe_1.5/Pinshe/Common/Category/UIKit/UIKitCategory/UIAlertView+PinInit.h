//
//  UIAlertView+PinInit.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CompletionClickedBlock) (NSInteger buttonIndex, NSString *buttonTitle);
typedef void (^CompletionCancelBlock) ();

@interface UIAlertView (PinInit) <UIAlertViewDelegate>

+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                             cancel:(NSString *)cancel
                       clickedBlock:(CompletionClickedBlock)clickedBlock
                        cancelBlock:(CompletionCancelBlock)cancelBlock;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                             cancel:(NSString *)cancel
                  otherButtonTitles:(NSArray <NSString *>*)titles
                       clickedBlock:(CompletionClickedBlock)clickedBlock
                        cancelBlock:(CompletionCancelBlock)cancelBlock;

@end
