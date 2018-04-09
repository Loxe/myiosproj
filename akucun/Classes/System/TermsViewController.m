//
//  TermsViewController.m
//  akucun
//
//  Created by Jarry on 17/7/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TermsViewController.h"
#import <WebKit/WebKit.h>

@interface TermsViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UIProgressView * progressView;

@end

@implementation TermsViewController

- (void) dealloc
{
    self.wkWebView.scrollView.delegate = nil;
}

- (void) setupContent
{
    [super setupContent];
    //    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"爱库存 APP 使用（服务）条款";
    /*
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Resources"];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:htmlContent baseURL:baseURL];
     */
    
    [self.view addSubview:self.wkWebView];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];

    [self startLoading];
    NSString *url = FORMAT(@"http://www.akucun.com/terms/terms.html?t=%@", [NSDate timeIntervalString]);
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

- (WKWebView *) wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView.backgroundColor = WHITE_COLOR; //RGBCOLOR(0xF2, 0xF2, 0xF2);
        _wkWebView.opaque = NO;
        [_wkWebView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                         UIViewAutoresizingFlexibleHeight)];
//        [_wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
//        _wkWebView.scrollView.bounces = NO;
        
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

@end
