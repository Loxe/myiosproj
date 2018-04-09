//
//  MyViewController.m
//  akucun
//
//  Created by Jarry on 2017/3/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MyViewController.h"
#import "ECTabBarController.h"
#import "MainViewController.h"
#import "NSString+akucun.h"
#import "TableCellBase.h"
#import "MyOrderTableCell.h"
#import "AfterSaleTableCell.h"
#import "AddrManageController.h"
#import "AddressViewController.h"
#import "UserEditViewController.h"
#import "AccountDetailController.h"
#import "MyOrderController.h"
#import "AfterSalesController.h"
#import "AddressView.h"
#import "IconButton.h"
#import "UserManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderTableCell.h"
#import "MJRefresh.h"
#import "RequestUserInfo.h"
#import "RequestOrderCount.h"
#import "RequestUserAccount.h"
#import "RequestKefuCheck.h"
#import "VIPPurchaseController.h"
#import "SCStarRateView.h"
#import "ServiceViewController.h"
#import "ASaleListController.h"
#import "InviteCodeController.h"
#import "JXMCSUserManager.h"

@interface UserView : UIView

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel, *mobileLabel, *weixinLabel;

@property (nonatomic, strong) UILabel *vipLabel;

@property (nonatomic, strong) IconButton *editButton;

@property (nonatomic, strong) UserInfo *userInfo;

@end

@interface MyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableView;
//@property (nonatomic,strong) NSMutableArray* dataSource;

@property (nonatomic, strong) UserView *userView;
@property (nonatomic, strong) AddressView *addressView;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, assign) NSInteger count0, count1, count2, count3, count4;
@property (nonatomic, assign) NSInteger acount0, acount1, acount2, acount3, acount4;

@property (nonatomic, strong) SCStarRateView *vipStarView;

@property (nonatomic, assign) NSInteger msgCount;

@end

@implementation MyViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"我";
    
    [self ec_setTabTitle:@"我"];
    [self ec_setTabImage:@"icon_my"];

    UserInfo *userInfo = [UserManager instance].userInfo;
    self.userView.userInfo = userInfo;
    self.addressView.address = userInfo.defaultAddr;

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    //
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestUserInfo];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;
}

- (void) initViewData
{
//    _dataSource = [NSMutableArray array];
    
//    OrderModel *order = [OrderModel new];
//    OrderCellLayout *layout = [[OrderCellLayout alloc] initWithModel:order];
//    [self.dataSource addObject:layout];
//    layout = [[OrderCellLayout alloc] initWithModel:order];
//    [self.dataSource addObject:layout];
//    
//    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
//    [((MainViewController *)self.ec_tabBarController) updateLeftButton:nil];
    
    self.msgCount = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil]; //临时修改，发通知让“转发按钮隐藏”
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    UserInfo *userInfo = [UserManager instance].userInfo;
    self.userView.userInfo = userInfo;
    self.addressView.address = userInfo.defaultAddr;
//    [self.addressView updateLayout];
    [self.tableView reloadData];
    
    //
//    [self requestUserAccount];
    [self requestOrderCount];
}

- (void) requestUserInfo
{
    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         //
         UserInfo *userInfo = [UserManager instance].userInfo;
         self.userView.userInfo = userInfo;
         self.addressView.address = userInfo.defaultAddr;
         [self.tableView reloadData];
         
         [self requestOrderCount];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }
                                  onError:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestUserAccount
{
    RequestUserAccount *request = [RequestUserAccount new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self requestOrderCount];

     } onFailed:nil];
}

- (void) requestOrderCount
{
    RequestOrderCount *request = [RequestOrderCount new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *jsonData = response.responseData;
         
         NSDictionary *stat = [jsonData objectForKey:@"stat"];
         self.count0 = [stat getIntegerValueForKey:@"0"];
         self.count1 = [stat getIntegerValueForKey:@"1"];
         self.count2 = [stat getIntegerValueForKey:@"3"];
         self.count3 = [stat getIntegerValueForKey:@"2"];
         self.count4 = [stat getIntegerValueForKey:@"4"];

         NSDictionary *aftersale = [jsonData objectForKey:@"aftersalestat"];
         self.acount0 = [aftersale getIntegerValueForKey:@"0"];
         self.acount1 = [aftersale getIntegerValueForKey:@"1"];
         self.acount2 = [aftersale getIntegerValueForKey:@"2"];
         self.acount3 = [aftersale getIntegerValueForKey:@"3"];
         self.acount4 = [aftersale getIntegerValueForKey:@"5"];

         [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 3)] withRowAnimation:UITableViewRowAnimationNone];

     } onFailed:^(id content)
     {
     } onError:^(id content)
     {
     }];
}
/*
- (void) requestCheckMessage
{
    RequestKefuCheck *request = [RequestKefuCheck new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         HttpResponseBase *response = content;
         NSDictionary *msgDic = response.responseData;
         self.msgCount = [msgDic getIntegerValueForKey:@"cnt"];

         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
         
     } onFailed:^(id content) {
         
     }];
}*/

#pragma mark - Actions

- (IBAction) editUserAction:(id)sender
{
    UserEditViewController *controller = [UserEditViewController new];
    controller.finishBlock = ^{
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) editAddressAction
{
    AddrManageController *controller = [AddrManageController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) orderAction:(int)type
{
    MyOrderController *controller = [MyOrderController new];
    controller.orderType = type;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) salesAction:(int)type
{
    if (type == ASaleTypeList) {
        ASaleListController *controller = [ASaleListController new];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    AfterSalesController *controller = [AfterSalesController new];
    controller.salesType = type;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    header.backgroundColor = COLOR_SEPERATOR_LIGHT;
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    return offset;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    return footer;
}
    
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        UserInfo *userInfo = [UserManager instance].userInfo;
        if (userInfo.prcstatu) {
            return 4;
        }
        return 3;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.userView.height;
    }
    else if (indexPath.section == 1) {
        return self.addressView.height;
    }
    else if (indexPath.section == 2) {
        return isPad ? kPadCellHeight : kTableCellHeight;
    }
    else if (indexPath.section == 3 || indexPath.section == 4) {
        CGSize size = [@"我的订单" boundingRectWithSize:CGSizeMake(320, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[FontUtils normalFont]} context:nil].size;
        CGFloat headerHeight = size.height + kOFFSET_SIZE*0.6f + 4;
        return headerHeight + kOFFSET_SIZE*2 + 60;
    }
    return kTableCellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.userView];
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.addressView];
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString* Identifier = @"MyOrderCell";
        MyOrderTableCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        }
        [cell setOrderCount1:self.count0 count2:self.count1 count3:self.count2 count4:self.count3 count5:self.count4];
        @weakify(self)
        cell.selectBlock = ^(int type) {
            @strongify(self)
            [self orderAction:(type-1)];
        };
        return cell;
    }
    else if (indexPath.section == 4) {
        static NSString* ASIdentifier = @"ASIdentifier";
        AfterSaleTableCell* cell = [tableView dequeueReusableCellWithIdentifier:ASIdentifier];
        if (!cell) {
            cell = [[AfterSaleTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ASIdentifier];
        }
        [cell setOrderCount1:self.acount0 count2:self.acount1 count3:self.acount2 count4:self.acount3 count5:self.acount4];
        @weakify(self)
        cell.selectBlock = ^(int type) {
            @strongify(self)
            [self salesAction:(type-1)];
        };
        return cell;
    }
    
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"会员状态";
        cell.detailTextLabel.font = [FontUtils smallFont];
        cell.detailTextLabel.text = @"";
        
        if ([UserManager instance].userInfo.vipflag > 0) {
            self.vipStarView.currentScore = [UserManager instance].userInfo.viplevel;
            CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
            self.vipStarView.top = (height - 20)/2.0f;
            self.vipStarView.right =  SCREEN_WIDTH - kOFFSET_SIZE;
            [cell.contentView addSubview:self.vipStarView];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"您还不是会员";
        }
    }
    else if (indexPath.row == 1) {
        cell.detailTextLabel.font = [FontUtils buttonFont];
        cell.detailTextLabel.textColor = COLOR_APP_ORANGE;
        
        UserAccount *account = [UserManager instance].userInfo.account;
        cell.textLabel.text = @"账户余额";
        cell.detailTextLabel.text = [NSString priceString:account.keyongyue];
    }
    else if (indexPath.row == 2) {
        cell.showSeperator = [UserManager instance].userInfo.prcstatu;
        cell.textLabel.text = @"联系客服";
        
        cell.detailTextLabel.textColor = RED_COLOR;
        cell.detailTextLabel.font = [FontUtils smallFont];
        if (self.msgCount > 0) {
            cell.detailTextLabel.text = FORMAT(@"您有%ld条未读消息", (long)self.msgCount);
        }
    }
    else if (indexPath.row == 3) {
        cell.showSeperator = NO;
        cell.textLabel.text = @"我的邀请码";
        cell.textLabel.textColor = RED_COLOR;
        
        UIImageView *hotImage = [[UIImageView alloc] initWithImage:IMAGENAMED(@"image_hot")];
        CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
        hotImage.top = (height - 24)/2.0f;
        CGSize size = [cell.textLabel.text sizeWithMaxWidth:300 andFont:[FontUtils normalFont]];
        hotImage.left = size.width + kOFFSET_SIZE + 5.0f;
        [cell.contentView addSubview:hotImage];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
//#ifdef APPSTORE
            VIPPurchaseController *controller = [VIPPurchaseController new];
            [self.navigationController pushViewController:controller animated:YES];
//#endif
        }
        else if (indexPath.row == 1) {
            AccountDetailController *controller = [AccountDetailController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (indexPath.row == 2) {
//            ServiceViewController *controller = [ServiceViewController new];
//            [self.navigationController pushViewController:controller animated:YES];

            /** 佳信售前客服 */
            if ([ServiceTypeManager instance].serviceType == ServiceTypeFeed) {
                [sClient.mcsManager leaveService];
            }

            [SVProgressHUD showWithStatus:@"加载中..."];
            // 获取当前登录用户的信息
            NSString *userID = [UserManager subuserId]; // 子账号ID
            NSString *name   = [UserManager instance].userInfo.name;
            NSString *bianhao = [UserManager instance].userInfo.yonghubianhao;
            NSString *viplevel = kIntergerToString([UserManager instance].userInfo.viplevel);
            NSDictionary *clientConfig = @{@"cid" : userID,
                                           @"crm" : @{@"name" : name,
                                                      @"extendFields" : @{@"extend1" : bianhao, @"extend2" : viplevel}
                                                      }};
            [sClient initializeSDKWithAppKey:JX_SALEAPPKEY andLaunchOptions:nil andConfig:clientConfig];
            WEAKSELF;
            [[JXMCSUserManager sharedInstance] loginWithCallback:^(BOOL success, id response) {
                [SVProgressHUD dismiss];
                if (success) {
                    [ServiceTypeManager instance].serviceType = ServiceTypeSale;
//                    JXMcsChatConfig *config = [JXMcsChatConfig defaultConfig];
//                    config.avatorImage = [UIImage imageNamed:@"testAvator"];
//                    [[JXMCSUserManager sharedInstance] requestCSForUI:weakSelf.navigationController witConfig:config];
                    [[JXMCSUserManager sharedInstance] requestCSForUI:weakSelf.navigationController];
                } else {
                    NSLog(@"%@", response);
                }
            }];
            
        }
        else if (indexPath.row == 3) {
            InviteCodeController *controller = [InviteCodeController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - Views

- (UserView *) userView
{
    if (!_userView) {
        _userView = [[UserView alloc] initWithFrame:CGRectZero];
        [_userView.editButton addTarget:self action:@selector(editUserAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userView;
}

- (AddressView *) addressView
{
    if (!_addressView) {
        _addressView  = [[AddressView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _addressView.actionBlock = ^ {
            @strongify(self)
            [self editAddressAction];
        };
    }
    return _addressView;
}

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        //        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
#ifdef XCODE9VERSION
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
#endif
    }
    return _tableView;
}

- (SCStarRateView *) vipStarView
{
    if (!_vipStarView) {
        _vipStarView = [[SCStarRateView alloc] initWithFrame:CGRectMake(0, 0, 68, 20)];
    }
    return _vipStarView;
}

@end

@implementation UserView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    
    self.width = SCREEN_WIDTH;
    self.height = 80 + kOFFSET_SIZE * 2;
    
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.mobileLabel];
    [self addSubview:self.weixinLabel];
    [self addSubview:self.editButton];

    [self addSubview:self.vipLabel];

//    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0.0f, SCREEN_WIDTH-kOFFSET_SIZE, 0.5f)];
//    _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
//    [self addSubview:_lineView];
    
    return self;
}

- (void) setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    
    self.nameLabel.text = FORMAT(@"昵　称：%@", userInfo.name);
    self.mobileLabel.text = FORMAT(@"手机号：%@", userInfo.shoujihao);
    self.weixinLabel.text = FORMAT(@"代购编号：%@", userInfo.yonghubianhao);
    
    if (userInfo.vipflag > 0) {
        self.vipLabel.text = FORMAT(@"VIP%ld", (long)userInfo.viplevel);
        self.vipLabel.backgroundColor = COLOR_SELECTED;
        self.vipLabel.width = 28;
    }
    else {
        self.vipLabel.text = FORMAT(@"VIP");
        self.vipLabel.backgroundColor = COLOR_TEXT_LIGHT;
        self.vipLabel.width = 25;
    }
    
    [self.nameLabel sizeToFit];
    [self.mobileLabel sizeToFit];
    [self.weixinLabel sizeToFit];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]
                          placeholderImage:IMAGENAMED(@"icon_user_default")
                                   options:SDWebImageDelayPlaceholder];
    
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    self.headImageView.top = offset;
    self.nameLabel.top = self.headImageView.top;
    self.nameLabel.left = self.headImageView.right + kOFFSET_SIZE;
    self.mobileLabel.centerY = self.headImageView.centerY;
    self.mobileLabel.left = self.nameLabel.left;
    self.weixinLabel.bottom = self.headImageView.bottom;
    self.weixinLabel.left = self.nameLabel.left;
    
    if (self.nameLabel.right > SCREEN_WIDTH - kOFFSET_SIZE - 32) {
        self.nameLabel.width = SCREEN_WIDTH - self.nameLabel.left - kOFFSET_SIZE - 32;
    }
    
    self.vipLabel.left = self.nameLabel.right + 5.0f;
    self.vipLabel.centerY = self.nameLabel.centerY;
    
    self.editButton.bottom = self.weixinLabel.bottom + 5;
    self.editButton.right = self.width - kOFFSET_SIZE;

    self.height = self.headImageView.bottom + offset;
}

- (UIImageView *) headImageView
{
    if (!_headImageView) {
        UIImage *image = IMAGENAMED(@"icon_user_default");
        _headImageView = [[UIImageView alloc] initWithImage:image];
        _headImageView.frame = CGRectMake(kOFFSET_SIZE, kOFFSET_SIZE, 80, 80);
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 8.0f;
    }
    return _headImageView;
}

- (UILabel *) nameLabel
{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = COLOR_TEXT_DARK;
        _nameLabel.font = [FontUtils normalFont];
    }
    return _nameLabel;
}

- (UILabel *) mobileLabel
{
    if (!_mobileLabel) {
        _mobileLabel  = [[UILabel alloc] init];
        _mobileLabel.backgroundColor = CLEAR_COLOR;
        _mobileLabel.textColor = COLOR_TEXT_DARK;
        _mobileLabel.font = [FontUtils normalFont];
    }
    return _mobileLabel;
}

- (UILabel *) weixinLabel
{
    if (!_weixinLabel) {
        _weixinLabel  = [[UILabel alloc] init];
        _weixinLabel.backgroundColor = CLEAR_COLOR;
        _weixinLabel.textColor = COLOR_TEXT_DARK;
        _weixinLabel.font = [FontUtils normalFont];
    }
    return _weixinLabel;
}

- (UILabel *) vipLabel
{
    if (!_vipLabel) {
        _vipLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 14)];
        _vipLabel.backgroundColor = COLOR_TEXT_LIGHT;
        _vipLabel.textColor = WHITE_COLOR;
        _vipLabel.font = BOLDSYSTEMFONT(10);
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.clipsToBounds = YES;
        _vipLabel.layer.cornerRadius = 5.0f;
    }
    return _vipLabel;
}

- (IconButton *) editButton
{
    if (!_editButton) {
        _editButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
        [_editButton setTitleFont:[FontUtils smallFont]];
        [_editButton setTitle:@"编辑" icon:FA_ICONFONT_EDIT];
    }
    return _editButton;
}

@end
