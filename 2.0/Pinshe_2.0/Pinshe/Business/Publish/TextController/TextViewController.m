//
//  TextViewController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/19.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "TextViewController.h"
#import "PINTextView.h"

@interface TextViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PINTextView *textview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (weak, nonatomic) id delegate;
@property (assign, nonatomic) PinLoginType pinLoginType;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initBaseParams {
    self.delegate = [self.postParams objectForKey:@"delegate"];
    self.pinLoginType = [[self.postParams objectForKey:@"pinLoginType"] integerValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self findFirstResponder] resignFirstResponder];
    [self removeKeyboardNotification];
}

- (void)initUI {
    [super leftBarButton:@"取消" color:HEXCOLOR(pinColorWhite) selector:@selector(cancelAction) delegate:self];
    [super rightBarButton:@"确定" color:HEXCOLOR(pinColorWhite) selector:@selector(sureAction) delegate:self];
    
    self.textview.placeholder = getPlaceholder(self.pinLoginType);
    self.textview.delegate = self;
    [self.textview becomeFirstResponder];
}

- (void)cancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureAction {
#ifdef DEBUG
    if ([self.textview.text isEqualToString:@"改地址"]) {
        [[ForwardContainer shareInstance] pushContainer:FORWARD_DEBUG_VC navigationController:self.navigationController params:nil animated:NO];
        return;
    }
#endif
    
    if (STR_Is_NullOrEmpty(self.textview.text)) {
        [self chatShowHint:@"请填写内容"];
        return;
    }
    [self sureTextViewAction];
    [self cancelAction];
}

- (void)sureTextViewAction {
    if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"sureTextView:")]) {
        SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"sureTextView:") withObject:self.textview.text])
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

#pragma mark -
#pragma mark keyboardNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    [self.textview setNeedsDisplay];
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    
    double animationDuration = 0.0f;
    NSUInteger animationCurve = 0;
    CGRect keyboardEndRect = CGRectZero;
    
    [animationDurationObject getValue:&animationDuration];
    [animationCurveObject getValue:&animationCurve];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:animationCurve];
        self.bottomLayoutConstraint.constant = keyboardEndRect.size.height;
        [self.textview layoutIfNeeded];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    [self.textview setNeedsDisplay];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:animationCurve];
        self.bottomLayoutConstraint.constant = 0;
        [self.textview layoutIfNeeded];
    }];
}

@end
