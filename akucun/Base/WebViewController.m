//
//  WebViewController.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UIProgressView * progressView;

@end

@implementation WebViewController

- (void) dealloc
{
    self.wkWebView.scrollView.delegate = nil;
}

- (void) setupContent
{
    [super setupContent];
    
    [self.view addSubview:self.wkWebView];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.url) {
        [self startLoading];
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

- (void) startLoading
{
    if (![self.activityView isAnimating]) {
        [self.activityView startAnimating];
    }
}

- (void) stopLoading
{
    if ([self.activityView isAnimating]) {
        [self.activityView stopAnimating];
    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.activityView.center = CGPointMake(self.view.width/2.0f, self.view.height/2.0f);
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self stopLoading];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.wkWebView) {
            if (self.progressView) {
                [self.progressView setAlpha:1.0f];
                [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
            }
            
            if(self.wkWebView.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (self.progressView) {
                        [self.progressView setAlpha:0.0f];
                    }
                } completion:^(BOOL finished) {
                    if (self.progressView) {
                        [self.progressView setProgress:0.0f animated:NO];
                    }
                }];
            }
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.pinchGestureRecognizer.enabled = NO;
    scrollView.panGestureRecognizer.enabled = NO;
    scrollView.scrollEnabled = YES;
}

- (WKWebView *) wkWebView
{
    if (!_wkWebView) {
        
        // 禁止选择CSS
        NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        
        // CSS选中样式取消
        NSMutableString *javascript = [NSMutableString string];
//        [javascript appendString:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0'); document.getElementsByTagName('head')[0].appendChild(meta);"];
        [javascript appendString:@"var style = document.createElement('style');"];
        [javascript appendString:@"style.type = 'text/css';"];
        [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
        [javascript appendString:@"style.appendChild(cssContent);"];
        [javascript appendString:@"document.body.appendChild(style);"];
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];  //禁止选择
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        
        // javascript注入
        /** 以下代码单纯适配屏幕 */
//        NSString *javascript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController *wkUserController = [[WKUserContentController alloc] init];
        [wkUserController addUserScript:wkUserScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUserController;

        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
//        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView.backgroundColor = WHITE_COLOR; //RGBCOLOR(0xF2, 0xF2, 0xF2);
        _wkWebView.opaque = NO;
        [_wkWebView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                         UIViewAutoresizingFlexibleHeight)];
        //[_wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
        //_wkWebView.scrollView.bounces = NO;
        
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate  = self;
        _wkWebView.scrollView.delegate = self;
    }
    return _wkWebView;
}


@end
