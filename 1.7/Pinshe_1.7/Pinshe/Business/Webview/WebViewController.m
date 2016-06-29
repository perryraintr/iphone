//
//  WebViewController.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/5.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "WebViewController.h"
#import "PINNetActivityIndicator.h"
#import <WebKit/WebKit.h>
@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, strong) NSURL *showLoadingUrl;

@property (nonatomic, strong) NSString *loadUrl;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.postParams objectForKey:@"title"];
    [self initUI];
    [self showLoadingViewWithUrl:self.loadUrl];
}

- (void)initUI {
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WITH, SCREEN_HEIGHT - 64)];
    self.webview.navigationDelegate = self;
    [self.view addSubview:_webview];
}

- (void)initBaseParams {
    self.loadUrl = [self.postParams objectForKey:@"loadUrl"];
}

- (void)dealloc {
    self.webview.navigationDelegate = nil;
    [self.webview removeFromSuperview];
}

- (void)showLoadingViewWithUrl:(NSString *)url {
    [PINNetActivityIndicator startActivityIndicator:PinIndicatorStyle_DefaultIndicator];

    if (url.length > 0) {
        NSURL *requestUrl = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
        self.showLoadingUrl = requestUrl;
        [self.webview loadRequest:request];
        PLog(@"showLoadingUrl === %@", self.showLoadingUrl);
    }
}

- (void)hideLoadingView {
    [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
}

#pragma mark -
#pragma mark WKNavigationDelegate
// 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    PLog(@"didStartProvisionalNavigation");
}

// 加载成功
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    PLog(@"didFinishNavigation");
    [self hideLoadingView];
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    PLog(@"didFailNavigationError: %@", [error localizedFailureReason]);
    [self hideLoadingView];
    if (pinSheAppDelegate().networkType == PinNetworkType_None) {
        [self chatShowHint:@"网络不给力\n请稍候再试试吧"];
    }
}

@end
