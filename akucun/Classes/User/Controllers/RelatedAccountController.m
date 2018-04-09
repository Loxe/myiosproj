//
//  RelatedAccountController.m
//  akucun
//
//  Created by Jarry Z on 2018/4/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RelatedAccountController.h"
#import "MJRefresh.h"
#import "SCImageView.h"
#import "TipTextView.h"
#import "RelatedAlertView.h"
#import "RelatedSMSAlert.h"
#import "RequestRelatedGetCode.h"
#import "RequestRelateAccount.h"
#import "RequestRelatedInfo.h"
#import "RequestCheckFriend.h"
#import "UIImageView+WebCache.h"

@interface RelatedAccountController ()

@property (nonatomic, strong) SCImageView *iconImgView;
@property (nonatomic, strong) UIButton *applyButton;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SCImageView *avatorImgView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *bianhaoLabel, *mobileLabel;

@property (nonatomic, strong) TipTextView *tipTextView1,*tipTextView2,*tipTextView3;

@end

@implementation RelatedAccountController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo.isrelevance) {
        [self requestRelatedInfo];
    }
}

- (void) setupContent
{
    [super setupContent];
        
    [self.view addSubview:self.iconImgView];
    [self.view addSubview:self.applyButton];

    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-kOFFSET_SIZE*4));
        make.height.equalTo(@(44));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-self.view.height/4);
        make.width.height.equalTo(@(110));
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    //
    [self.scrollView addSubview:self.avatorImgView];
    [self.scrollView addSubview:self.statusLabel];
    [self.scrollView addSubview:self.nameLabel];
    
    [self.avatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(kOFFSET_SIZE*1.5);
        make.width.height.equalTo(@(100));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.avatorImgView.mas_bottom).offset(10);
        make.width.equalTo(@(40));
        make.height.equalTo(@(15));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(10);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.height.equalTo(@(kPIXEL_WIDTH));
    }];
    
    [self.scrollView addSubview:self.bianhaoLabel];
    [self.scrollView addSubview:self.mobileLabel];
    [self.bianhaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(line1.mas_bottom).offset(kOFFSET_SIZE);
        make.width.equalTo(@(SCREEN_WIDTH*0.5));
    }];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(self.bianhaoLabel);
        make.width.equalTo(@(SCREEN_WIDTH*0.5));
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.scrollView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.bianhaoLabel.mas_bottom).offset(kOFFSET_SIZE);
        make.height.equalTo(@(kPIXEL_WIDTH));
    }];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.scrollView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(line1);
        make.bottom.equalTo(line2);
        make.width.equalTo(@(kPIXEL_WIDTH));
    }];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(line2.mas_bottom);
    }];
    
    [contentView addSubview:self.tipTextView1];
    [contentView addSubview:self.tipTextView2];
    [contentView addSubview:self.tipTextView3];
    [self.tipTextView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(kOFFSET_SIZE*2);
        make.left.equalTo(contentView).offset(kOFFSET_SIZE);
        make.right.equalTo(contentView).offset(-kOFFSET_SIZE);
    }];
    [self.tipTextView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipTextView1.mas_bottom).offset(kOFFSET_SIZE);
        make.left.right.equalTo(self.tipTextView1);
    }];
    [self.tipTextView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipTextView2.mas_bottom).offset(kOFFSET_SIZE);
        make.left.right.equalTo(self.tipTextView1);
    }];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo.isrelevance) {
        self.title = @"我的关联主账号";
        self.scrollView.hidden = YES;
        self.iconImgView.hidden = YES;
        self.applyButton.hidden = YES;
    }
    else {
        self.title = @"关联账号管理";
        self.scrollView.hidden = YES;
        self.iconImgView.hidden = NO;
        self.applyButton.hidden = NO;
    }
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestRelatedInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.scrollView.mj_header = refreshHeader;
}

- (IBAction) applyAction:(id)sender
{
    @weakify(self)
    [RelatedAlertView showWithConfirmed:^{
        @strongify(self)
        [self showSMSAlert];
    }];
}

- (void) showSMSAlert
{
    RelatedSMSAlert *alertView = [[RelatedSMSAlert alloc] init];
    @weakify(self)
    alertView.confirmBlock = ^(id content1, id content2) {
        @strongify(self)
//        [self requestRelateAccount:content1 code:content2];
        // 检查是否是好友关系
        [self requestCheckFriend:content1 code:content2];
    };
    alertView.attachedView = self.navigationController.view;
    [alertView show];
}

#pragma mark - Request

// 请求关联主账号
- (void) requestRelateAccount:(NSString *)userNo code:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestRelateAccount *request = [RequestRelateAccount new];
    request.mainDaigouid = userNo;
    request.code = code;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [SVProgressHUD showSuccessWithStatus:@"关联申请已提交，请等待审核结果"];
        
        self.iconImgView.hidden = YES;
        self.applyButton.hidden = YES;
        
        UserInfo *userInfo = [UserManager instance].userInfo;
        userInfo.isrelevance = YES;
        
        [self requestRelatedInfo];
        
    } onFailed:nil];
}

// 查询已关联的主账号信息
- (void) requestRelatedInfo
{
    RequestRelatedInfo *request = [RequestRelatedInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.scrollView.mj_header endRefreshing];
         
         ResponseRelatedAccount *response = content;
         if (response.member) {
             
             if (![NSString isEmpty:response.member.avatar]) {
                 [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:response.member.avatar]];
             }
             self.nameLabel.text = response.member.username;
             self.bianhaoLabel.text = FORMAT(@"代购编号： %@", response.member.daigouId);
             self.mobileLabel.text = FORMAT(@"手机号： %@", [response.member.mobile displayMobile]);

             if (response.checkStatus) {
                 self.statusLabel.text = @"已关联";
                 self.statusLabel.backgroundColor = RGBCOLOR(0x00, 0xa0, 0xe9);
                 self.tipTextView1.hidden = NO;
                 self.tipTextView2.hidden = NO;
                 self.tipTextView3.hidden = NO;
             }
             else {
                 self.statusLabel.text = @"审核中";
                 self.statusLabel.backgroundColor = COLOR_MAIN;
                 self.tipTextView1.hidden = YES;
                 self.tipTextView2.hidden = YES;
                 self.tipTextView3.hidden = YES;
             }
             
             NSString *account = response.member.daigouId;
             NSString *text = FORMAT(@"您已成功与主账号【%@】进行了关联，您的销售业绩将被关联至主账号，所有后续的奖励都将发放给主账号。", account);
             NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
             NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
             style.lineSpacing = 5; // 行间距
             [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
             [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(8, account.length+2)];
             [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(8, account.length+2)];
             [self.tipTextView1 setAttributeText:attStr];
             
             self.scrollView.hidden = NO;
         }
         
     } onFailed:^(id content) {
         [self.scrollView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.scrollView.mj_header endRefreshing];
     }];
}

- (void) requestCheckFriend:(NSString *)userId code:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    RequestCheckFriend *request = [RequestCheckFriend new];
    request.mainDaigouid = userId;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         NSInteger check = [jsonData getIntegerValueForKey:@"code"];
         if (check > 0) {
             [self confirmWithIcon:FA_ICONFONT_ALERT
                             title:@"你与主账号存在好友关系，账号关联后好友关系自动解除，所有奖励均合并至主账号进行发放，若同意请点确定。"
                             block:^
             {
                 [self requestRelateAccount:userId code:code];
                 
             } canceled:^{
                 [SVProgressHUD dismiss];
             }];
         }
         else {
             [self requestRelateAccount:userId code:code];
         }
         
     } onFailed:nil];
}

#pragma mark -

- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = WHITE_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.hidden = YES;
    }
    return _scrollView;
}

- (SCImageView *) avatorImgView
{
    if (_avatorImgView == nil) {
        _avatorImgView = [[SCImageView alloc]init];
        _avatorImgView.image = [UIImage imageNamed:@"userAvator"];
        _avatorImgView.layer.masksToBounds = YES;
        _avatorImgView.layer.cornerRadius = 100*0.5f;
    }
    return _avatorImgView;
}

- (UILabel *) statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.text = @"审核中";
        _statusLabel.backgroundColor     = COLOR_MAIN;
        _statusLabel.layer.cornerRadius  = 4.0;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.textColor = WHITE_COLOR;
        _statusLabel.font      = BOLDSYSTEMFONT(10);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UILabel *) nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"--";
        _nameLabel.textColor = COLOR_TEXT_NORMAL;
        _nameLabel.font   = BOLDSYSTEMFONT(18);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *) bianhaoLabel
{
    if (_bianhaoLabel == nil) {
        _bianhaoLabel = [[UILabel alloc] init];
        _bianhaoLabel.text = @"代购编号： --";
        _bianhaoLabel.textColor = COLOR_TEXT_NORMAL;
        _bianhaoLabel.font   = [FontUtils smallFont];
        _bianhaoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bianhaoLabel;
}

- (UILabel *) mobileLabel
{
    if (_mobileLabel == nil) {
        _mobileLabel = [[UILabel alloc] init];
        _mobileLabel.text = @"手机号： --";
        _mobileLabel.textColor = COLOR_TEXT_NORMAL;
        _mobileLabel.font   = [FontUtils smallFont];
        _mobileLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _mobileLabel;
}

- (TipTextView *) tipTextView1
{
    if (_tipTextView1 == nil) {
        _tipTextView1 = [[TipTextView alloc] init];
        
    }
    return _tipTextView1;
}

- (TipTextView *) tipTextView2
{
    if (_tipTextView2 == nil) {
        _tipTextView2 = [[TipTextView alloc] init];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"您的账号今后不再享受任何奖励和排名。"];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5; // 行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(6, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(6, 4)];
        [_tipTextView2 setAttributeText:attStr];
    }
    return _tipTextView2;
}

- (TipTextView *) tipTextView3
{
    if (_tipTextView3 == nil) {
        _tipTextView3 = [[TipTextView alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"您与主账号共享唯一的收货地址，每月只能修改 5 次地址（ 主账号体系下所有账号合计修改次数 ）。"];
        // 段落换行居中及默认属性
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5; // 行间距
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(5, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(5, 4)];
        [attStr addAttribute:NSForegroundColorAttributeName value:RED_COLOR range:NSMakeRange(22, 1)];
        [attStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(22, 1)];
        [_tipTextView3 setAttributeText:attStr];
    }
    return _tipTextView3;
}

- (SCImageView *) iconImgView
{
    if (_iconImgView == nil) {
        _iconImgView = [[SCImageView alloc] init];
        _iconImgView.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
        _iconImgView.image = [UIImage imageNamed:@"icon_related"];
        _iconImgView.contentMode = UIViewContentModeCenter;
        
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.layer.cornerRadius = 110*0.5f;
        
        _iconImgView.hidden = YES;
        
        @weakify(self)
        _iconImgView.clickedBlock = ^{
            @strongify(self)
            [self applyAction:nil];
        };
    }
    return _iconImgView;
}

- (UIButton *) applyButton
{
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.backgroundColor = COLOR_BG_BUTTON;
        _applyButton.layer.masksToBounds = YES;
        _applyButton.layer.cornerRadius = 5;
        
        _applyButton.titleLabel.font = [FontUtils buttonFont];
        
        [_applyButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
        [_applyButton setNormalTitle:@"申请关联主账号"];
        
        [_applyButton addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _applyButton.hidden = YES;
    }
    return _applyButton;
}

@end
