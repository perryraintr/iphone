//
//  WebViewController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/5.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "WebViewController.h"
#import "PINActivityIndicatorView.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (nonatomic, strong) NSURL *showLoadingUrl;

@property (nonatomic, strong) NSString *loadUrl;

@property (strong, nonatomic) UIView *loadingBackgroundView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.postParams objectForKey:@"title"];
    [self initUI];
    [self showLoadingViewWithUrl:self.loadUrl];
}

- (void)initBaseParams {
    self.loadUrl = [self.postParams objectForKey:@"loadUrl"];
}

- (void)initUI {
    self.loadingBackgroundView = [[UIView alloc] init];
    self.loadingBackgroundView.backgroundColor = HEXCOLOR(pinColorMainBackground);
    [self.loadingBackgroundView addSubview:(PINActivityIndicatorView *)self.defaultBorderIndicator];
    [self.view addSubview:self.loadingBackgroundView];
    [self.view sendSubviewToBack:self.loadingBackgroundView];
    
    self.loadingBackgroundView.hidden = YES;
    [self.loadingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.defaultBorderIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(FITWITH(80)));
        make.height.equalTo(@(FITWITH(80)));
    }];
    
}

- (void)dealloc {
    self.webview.delegate = nil;
    [self.webview removeFromSuperview];
}

- (void)showLoadingViewWithUrl:(NSString *)url {
    [self.view bringSubviewToFront:self.loadingBackgroundView];
    [self startActivityIndicatorView:[NSString stringWithFormat:@"%tu", PinIndicatorStyle_DefaultIndicator]];
    self.loadingBackgroundView.hidden = NO;
    
    if (url.length > 0) {
        NSURL *requestUrl = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
        self.showLoadingUrl = requestUrl;
        [self.webview loadRequest:request];
        PLog(@"showLoadingUrl === %@", self.showLoadingUrl);
    }
}

- (void)hideLoadingView {
    [self.view sendSubviewToBack:self.loadingBackgroundView];
    [self stopActivityIndicatorView:[NSString stringWithFormat:@"%tu", PinIndicatorStyle_DefaultIndicator]];
    self.loadingBackgroundView.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    PLog(@"dacaiguoguo:\n%s\n%@",__func__,requestString);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingView];
    if ([[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request]) {
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:webView.request];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self hideLoadingView];
    if ([[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request]) {
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:webView.request];
    }
    if (pinSheAppDelegate().networkType == PinNetworkType_None) {
        [self chatShowHint:@"网络不给力\n请稍候再试试吧"];
    }
}


@end
