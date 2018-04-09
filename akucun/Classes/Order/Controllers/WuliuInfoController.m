//
//  WuliuInfoController.m
//  akucun
//
//  Created by Jarry on 2017/7/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "WuliuInfoController.h"
#import <WebKit/WebKit.h>
#import "OptionsPickerView.h"

@interface WuliuInfoController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UIProgressView * progressView;

@property (nonatomic, strong) NSArray *danhaoArray;
@property (nonatomic, copy) NSString *danhao;

@end

@implementation WuliuInfoController

- (void) setupContent
{
    [super setupContent];
    
    self.title = @"快递查询";
    
    self.rightButton.width = 80.0f;
    [self.rightButton setNormalTitle:@"选择单号"];
    self.rightButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    [self.view addSubview:self.wkWebView];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self queryWuliuInfo];
}

- (IBAction) rightButtonAction:(id)sender
{
    [OptionsPickerView showWithTitle:@"选择快递单号"
                              option:self.danhaoArray
                            selected:@""
                            competed:^(id content)
    {
        self.danhao = content;
        [self queryWuliuInfo];
    }];
    
}

- (void) queryWuliuInfo
{
//    NSString *url = FORMAT(@"https://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.wuliugongsi,self.danhao);
    NSString *url = FORMAT(@"https://m.kuaidi100.com/result.jsp?nu=%@",self.danhao);
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url urlEncodedString]]]];
    
    [self startLoading];
}

- (void) setWuliuhao:(NSString *)wuliuhao
{
    _wuliuhao = wuliuhao;
    
    self.danhaoArray = [wuliuhao componentsSeparatedByString:@","];
    self.danhao = self.danhaoArray[0];
    self.rightButton.hidden = (self.danhaoArray.count == 1);
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
                    //
//                    [self.wkWebView.scrollView.mj_header endRefreshing];
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

#pragma mark -

- (WKWebView *) wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView.backgroundColor = WHITE_COLOR; //RGBCOLOR(0xF2, 0xF2, 0xF2);
        _wkWebView.opaque = NO;
        [_wkWebView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                         UIViewAutoresizingFlexibleHeight)];
        [_wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
        _wkWebView.scrollView.bounces = NO;
        
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}
@end
