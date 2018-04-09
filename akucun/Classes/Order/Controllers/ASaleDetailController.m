//
//  ASaleDetailController.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleDetailController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"
#import "RequestAftersaleDetail.h"
#import "RequestAftersaleCancel.h"
#import "RequestAftersaleInfo.h"
#import "ASaleStepView.h"
#import "ASaleTuihuoController.h"
#import "WuliuInfoController.h"

@interface ASaleDetailController ()
{
    CGFloat _offsetHeight;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *danhaoLabel, *timeLabel, *typeLabel, *orderLabel;

@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) UILabel *serviceLabel;

@property (nonatomic, strong) UIView *problemView;
@property (nonatomic, strong) UILabel *problemLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) ASaleStepView *stepsView;

@property (nonatomic, assign) BOOL isCanceled;

@end

@implementation ASaleDetailController

- (instancetype) initWithProduct:(NSString *)productId
{
    self = [self init];
    if (self) {
        [self initView];
        self.productId = productId;
    }
    return self;
}

- (instancetype) initWithService:(ASaleService *)service
{
    self = [self init];
    if (self) {
        [self initView];
        self.asaleService = service;
        self.productId = service.cartproductid;
    }
    return self;
}

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = COLOR_BG_LIGHTGRAY;
    self.title = @"售后详情";
    
    [self.rightButton setTitleFont:FA_ICONFONTSIZE(20)];
    [self.rightButton setNormalTitle:FA_ICONFONT_KEFU];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void) initView
{
    [self.view addSubview:self.scrollView];
    
    _offsetHeight = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;

    [self.scrollView addSubview:self.topView];
    
    self.stepsView.top = self.topView.bottom + _offsetHeight;
    [self.scrollView addSubview:self.stepsView];
    
    [self.scrollView addSubview:self.serviceView];
    [self.scrollView addSubview:self.problemView];

    [self.scrollView addSubview:self.cancelButton];

    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestASaleDetail];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.scrollView.mj_header = refreshHeader;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.asaleService && self.productId) {
        [self requestASaleDetail];
    }
    
}

- (void) setAsaleService:(ASaleService *)asaleService
{
    _asaleService = asaleService;
    
    [self updateData];
}

- (void) updateData
{
    self.danhaoLabel.text = FORMAT(@"服务单号：%@", self.asaleService.servicehao);
    [self.danhaoLabel sizeToFit];
    
    self.timeLabel.text = FORMAT(@"申请时间：%@", self.asaleService.shenqingshijian);
    [self.timeLabel sizeToFit];
    
    self.orderLabel.text = FORMAT(@"订 单 号：%@", self.asaleService.orderid);
    [self.orderLabel sizeToFit];

    self.typeLabel.text = [self.asaleService serviceTypeText];
    [self.typeLabel sizeToFit];
    self.typeLabel.right = SCREEN_WIDTH-kOFFSET_SIZE;

    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.stepsView.height = 140.0f + offset * 2;
    if ((self.asaleService.refundhao && self.asaleService.refundhao.length > 0) ||
        (self.asaleService.reissuehao && self.asaleService.reissuehao.length > 0)) {
        self.stepsView.height = 160.0f + offset * 2;
    }
    self.stepsView.asaleService = self.asaleService;
    self.stepsView.hidden = NO;
    
    if (self.asaleService.servicedesc && self.asaleService.servicedesc.length > 0) {
        self.serviceLabel.text = self.asaleService.servicedesc;
        [self.serviceLabel sizeToFit];
        
        self.serviceView.hidden = NO;
        self.serviceView.top = self.stepsView.bottom + _offsetHeight;
        self.serviceView.height = self.serviceLabel.bottom + _offsetHeight;
        self.problemView.top = self.serviceView.bottom + _offsetHeight;
    }
    else {
        self.problemView.top = self.stepsView.bottom + _offsetHeight;
    }
    
    self.problemLabel.text = self.asaleService.wentimiaoshu;
    [self.problemLabel sizeToFit];
    
    NSString *url = [self.asaleService pingzheng];
    if (url) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.asaleService pingzheng]]];
        self.imageView.top = self.problemLabel.bottom + _offsetHeight;
        self.problemView.height = self.imageView.bottom + _offsetHeight;
    }
    else {
        self.problemView.height = self.problemLabel.bottom + _offsetHeight;
    }
    self.problemView.hidden = NO;
    
    if (self.asaleService.chulizhuangtai == ASaleStatusSubmit || self.asaleService.chulizhuangtai == ASaleStatusPending) {
        self.cancelButton.top = self.problemView.bottom + kOFFSET_SIZE*2;
        self.cancelButton.hidden = NO;
    }
    else {
        self.cancelButton.hidden = YES;
    }
    
}

#pragma mark - Actions

- (IBAction) leftButtonAction:(id)sender
{
    [super leftButtonAction:sender];
    
    if (self.isCanceled) {
        if (self.finishedBlock) {
            self.finishedBlock();
        }
    }
}

- (IBAction) rightButtonAction:(id)sender
{
//    ServiceViewController *controller = [ServiceViewController new];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) cancelAction:(id)sender
{
    @weakify(self)
    [self confirmWithIcon:FA_ICONFONT_QUESTION
                    title:@"是否确定撤销售后申请 ？"
                    block:^
    {
        @strongify(self)
        [self requestASaleCancel];
        
    } canceled:nil];
}

- (IBAction) buttonAction:(id)sender
{
    if (self.asaleService.reissuehao && self.asaleService.reissuehao.length) {
        // 查看物流
        WuliuInfoController *controller = [WuliuInfoController new];
        controller.wuliugongsi = self.asaleService.reissuecorp;
        controller.wuliuhao = self.asaleService.reissuehao;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (self.asaleService.refundhao && self.asaleService.refundhao.length > 0) {
        // 查看物流
        WuliuInfoController *controller = [WuliuInfoController new];
        controller.wuliugongsi = self.asaleService.refundcorp;
        controller.wuliuhao = self.asaleService.refundhao;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    else {
        // 填写退货快递单号
        ASaleTuihuoController *controller = [[ASaleTuihuoController alloc] initWithProduct:self.asaleService.cartproductid];
        @weakify(self)
        controller.finishedBlock = ^ {
            @strongify(self)
            [self requestASaleDetail];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - request

- (void) requestASaleDetail
{
    [SVProgressHUD showWithStatus:nil];
    
    if (self.asaleService) {
        RequestAftersaleInfo *request = [RequestAftersaleInfo new];
        request.serviceNo = self.asaleService.servicehao;
        
        [SCHttpServiceFace serviceWithRequest:request
                                    onSuccess:^(id content)
         {
             [SVProgressHUD dismiss];
             [self.scrollView.mj_header endRefreshing];
             
             ResponseAftersaleInfo *response = content;
             self.asaleService = response.asaleService;
             
         } onFailed:^(id content) {
             [self.scrollView.mj_header endRefreshing];
         } onError:^(id content) {
             [self.scrollView.mj_header endRefreshing];
         }];
    }
    else if (self.productId) {
        RequestAftersaleDetail *request = [RequestAftersaleDetail new];
        request.cartproductid = self.productId;
        
        [SCHttpServiceFace serviceWithRequest:request
                                    onSuccess:^(id content)
         {
             [SVProgressHUD dismiss];
             [self.scrollView.mj_header endRefreshing];
             
             ResponseAftersaleInfo *response = content;
             self.asaleService = response.asaleService;
             
         } onFailed:^(id content) {
             [self.scrollView.mj_header endRefreshing];
         } onError:^(id content) {
             [self.scrollView.mj_header endRefreshing];
         }];
    }
}

- (void) requestASaleCancel
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestAftersaleCancel *request = [RequestAftersaleCancel new];
    request.serviceNo = self.asaleService.servicehao;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"售后申请已撤销！"];
         self.asaleService.chulizhuangtai = ASaleStatusCanceled;
         [self updateData];
         
         self.isCanceled = YES;

     } onFailed:nil];
}

#pragma mark - 

- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = CLEAR_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.height);
    }
    return _scrollView;
}

- (UIView *) topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _topView.backgroundColor = WHITE_COLOR;
        
        self.danhaoLabel.top = _offsetHeight;
        [_topView addSubview:self.danhaoLabel];

        self.typeLabel.top = self.danhaoLabel.top;
        [_topView addSubview:self.typeLabel];

        self.timeLabel.top = self.danhaoLabel.bottom + _offsetHeight;
        [_topView addSubview:self.timeLabel];
        
        self.orderLabel.top = self.timeLabel.bottom + _offsetHeight;
        [_topView addSubview:self.orderLabel];

        _topView.height = self.orderLabel.bottom + _offsetHeight;
    }
    return _topView;
}

- (UILabel *) danhaoLabel
{
    if (!_danhaoLabel) {
        _danhaoLabel = [UILabel new];
        _danhaoLabel.left = kOFFSET_SIZE;
        _danhaoLabel.font = [FontUtils normalFont];
        _danhaoLabel.textColor = COLOR_TEXT_DARK;
        _danhaoLabel.text = @"服务单号： ----";
        [_danhaoLabel sizeToFit];
    }
    return _danhaoLabel;
}

- (UILabel *) timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.left = kOFFSET_SIZE;
        _timeLabel.font = [FontUtils normalFont];
        _timeLabel.textColor = COLOR_TEXT_DARK;
        _timeLabel.text = @"申请时间： ----";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *) orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.left = kOFFSET_SIZE;
        _orderLabel.font = [FontUtils normalFont];
        _orderLabel.textColor = COLOR_TEXT_DARK;
        _orderLabel.text = @"订 单 号： ----";
        [_orderLabel sizeToFit];
    }
    return _orderLabel;
}

- (UILabel *) typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.font = [FontUtils normalFont];
        _typeLabel.textColor = COLOR_TEXT_DARK;
        _typeLabel.text = @"";
        [_typeLabel sizeToFit];
    }
    return _typeLabel;
}

- (ASaleStepView *) stepsView
{
    if (!_stepsView) {
        _stepsView = [[ASaleStepView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        
        [_stepsView.actionButton addTarget:self action:@selector(buttonAction:)
                forControlEvents:UIControlEventTouchUpInside];
        
        _stepsView.hidden = YES;
    }
    return _stepsView;
}

- (UIView *) serviceView
{
    if (!_serviceView) {
        _serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _serviceView.backgroundColor = WHITE_COLOR;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [FontUtils smallFont];
        titleLabel.textColor = COLOR_TEXT_DARK;
        titleLabel.text = @"审核备注";
        [titleLabel sizeToFit];
        titleLabel.left = kOFFSET_SIZE;
        titleLabel.top = _offsetHeight;
        [_serviceView addSubview:titleLabel];
        
        self.serviceLabel.left = kOFFSET_SIZE;
        self.serviceLabel.top = titleLabel.bottom + _offsetHeight *0.5f;
        [_serviceView addSubview:self.serviceLabel];
        
        _serviceView.hidden = YES;
    }
    return _serviceView;
}

- (UILabel *) serviceLabel
{
    if (!_serviceLabel) {
        _serviceLabel = [UILabel new];
        _serviceLabel.font = [FontUtils smallFont];
        _serviceLabel.textColor = COLOR_TEXT_NORMAL;
        _serviceLabel.numberOfLines = 0;
    }
    return _serviceLabel;
}

- (UIView *) problemView
{
    if (!_problemView) {
        _problemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _problemView.backgroundColor = WHITE_COLOR;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [FontUtils smallFont];
        titleLabel.textColor = COLOR_TEXT_DARK;
        titleLabel.text = @"问题描述";
        [titleLabel sizeToFit];
        titleLabel.left = kOFFSET_SIZE;
        titleLabel.top = _offsetHeight;
        [_problemView addSubview:titleLabel];
        
        self.problemLabel.left = kOFFSET_SIZE;
        self.problemLabel.top = titleLabel.bottom + _offsetHeight *0.5f;
        [_problemView addSubview:self.problemLabel];
        
        self.imageView.left = kOFFSET_SIZE + 2.0f;
        [_problemView addSubview:self.imageView];
        
        _problemView.hidden = YES;
    }
    return _problemView;
}

- (UILabel *) problemLabel
{
    if (!_problemLabel) {
        _problemLabel = [UILabel new];
        _problemLabel.font = [FontUtils smallFont];
        _problemLabel.textColor = COLOR_TEXT_NORMAL;
        _problemLabel.numberOfLines = 0;
    }
    return _problemLabel;
}

- (UIImageView *) imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, 30, 30);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *) cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(kOFFSET_SIZE, 0, SCREEN_WIDTH-kOFFSET_SIZE*2, 44);
        _cancelButton.backgroundColor = COLOR_BG_BUTTON;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 5;
        
        _cancelButton.titleLabel.font = [FontUtils buttonFont];
        
        [_cancelButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_cancelButton setNormalTitle:@"撤销申请"];
        
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelButton.hidden = YES;
    }
    return _cancelButton;
}

@end
