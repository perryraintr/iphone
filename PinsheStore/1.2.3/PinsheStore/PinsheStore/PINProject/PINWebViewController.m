//
//  PINWebViewController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/10/24.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINWebViewController.h"
#import <WebKit/WebKit.h>

@interface PINWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, strong) NSURL *showLoadingUrl;

@property (nonatomic, strong) NSString *loadUrl;

@end

@implementation PINWebViewController

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (url.length > 0) {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *requestUrl = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
        self.showLoadingUrl = requestUrl;
        [self.webview loadRequest:request];
        PLog(@"showLoadingUrl");
    }
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    if (PINAppDelegate().networkType == PINNetworkType_None) {
        [self chatShowHint:@"网络不给力\n请稍候再试试吧"];
    }
}

@end
