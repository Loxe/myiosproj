//
//  UserManagerController.m
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "UserManagerController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "RequestUnbindUser.h"
#import "RequestCartSaveStatus.h"
#import "RequestUserInfo.h"
#import "RequestSubuserList.h"
#import "RequestChangeWXAccount.h"

@interface UserManagerController () <UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISwitch *switchControl;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation UserManagerController

- (void) setupContent
{
    [super setupContent];
    
    self.title = @"子账号管理";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requestSubuserList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.textColor = LIGHTGRAY_COLOR;
    self.tableView.mj_header = refreshHeader;

    self.dataSource = [NSMutableArray arrayWithArray:[UserManager instance].userInfo.subUserinfos];
//    UserInfo *userInfo = [UserManager instance].userInfo;
//    for (SubUser *item in userInfo.subUserinfos) {
//        if (![item isPrimaryAccount]) {
//            [self.dataSource addObject:item];
//        }
//    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self requestSubuserList];
}

#pragma mark -

- (void) switchValueChanged:(UISwitch *)stch
{
    [self requestSaveStatus:stch.on];
}

- (void) requestSaveStatus:(BOOL)isMerge
{
    RequestCartSaveStatus *request = [RequestCartSaveStatus new];
    request.isMerge = isMerge ? 1 : 0;
    
    [SVProgressHUD showWithStatus:nil];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD showSuccessWithStatus:@"已保存 ！"];
         
         [UserManager instance].userInfo.isCartMerge = isMerge;
         
     } onFailed:^(id content) {
         
     }];
}

- (void) requestUnbindUser:(SubUser *)subUser index:(NSIndexPath *)indexPath
{
    RequestUnbindUser *request = [RequestUnbindUser new];
    request.subAccount = subUser.subUserId;
    
    [SVProgressHUD showWithStatus:nil];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        if ([subUser.subUserId isEqualToString:[UserManager subuserId]]) {
            
            [SVProgressHUD dismiss];
            
            [self alertWithIcon:FA_ICONFONT_ALERT detail:@"您已成功解绑，请重新登录" block:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOKEN_EXPIRED object:nil];
            }];
            
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"子账号已成功解绑！"];
            [self requestSubuserList];
        }
        
        /*
        [self.tableView beginUpdates];
        [self.dataSource removeObject:subUser];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        */
        
        
    } onFailed:^(id content) {
        
    }];
}

- (void) requestUserInfo
{
    RequestUserInfo *request = [RequestUserInfo new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestSubuserList
{
    RequestSubuserList *request = [RequestSubuserList new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
         ResponseSubuserList *response = content;
         self.dataSource = response.result;
         [self.tableView reloadData];
     }
                                 onFailed:^(id content)
     {
         [self.tableView.mj_header endRefreshing];
     } onError:^(id content) {
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void) requestChangeWXAccount:(NSString*)subUserid
{
    [SVProgressHUD showWithStatus:nil];
    RequestChangeWXAccount *request = [RequestChangeWXAccount new];
    request.subUserId = subUserid;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         if (![UserManager isPrimaryAccount] && [UserManager instance].userInfo.istabaccount) {
             
             [SVProgressHUD dismiss];
             
             [self alertWithIcon:FA_ICONFONT_ALERT detail:@"已成功修改主账号，请重新登录" block:^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOKEN_EXPIRED object:nil];
             }];
         }
         else {
             [SVProgressHUD showSuccessWithStatus:@"已成功设置主账号"];
             [self requestSubuserList];
         }
     }
                                 onFailed:^(id content)
     {
     }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;//kTableCellHeight*1.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = kTableCellHeight*1.5f;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, 300, height)];
    titleLabel.font = [FontUtils buttonFont];
    titleLabel.textColor  =COLOR_TEXT_DARK;
    titleLabel.text = @"子账号独立购物车";
    [header addSubview:titleLabel];
    
    self.switchControl.right = SCREEN_WIDTH - kOFFSET_SIZE;
    self.switchControl.centerY = height/2.0f;
    self.switchControl.on = [UserManager instance].userInfo.isCartMerge;
    [header addSubview:self.switchControl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height-1.0f, SCREEN_WIDTH, kPIXEL_WIDTH)];
    line.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [header addSubview:line];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    return footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubUserCell" forIndexPath:indexPath];
    
    SubUser *user =self.dataSource[indexPath.section];
    cell.subUser = user;
    
    @weakify(self)
    cell.actionBlock = ^{
        @strongify(self)
        [self confirmWithIcon:FA_ICONFONT_QUESTION
                        title:FORMAT(@"是否确定解绑子账号\n【%@】 ?",user.subusername)
                         block:^
        {
            [self requestUnbindUser:user index:indexPath];
            
        } canceled:^{
            
        }];
    };
    
    cell.defaultBlock = ^{
        @strongify(self)
        [self confirmWithIcon:FA_ICONFONT_QUESTION
                        title:FORMAT(@"是否确定\n设置【%@】为主账号 ?",user.subusername)
                        block:^
         {
             [self requestChangeWXAccount:user.subUserId];
             
         } canceled:nil];
    };
    
    return cell;
}

#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有绑定子账号\n用微信号登录可以绑定子账号";
    NSDictionary *attributes = @{NSFontAttributeName : [FontUtils normalFont],
                                 NSForegroundColorAttributeName : COLOR_TEXT_LIGHT };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *) imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGENAMED(@"image_order");
}

- (BOOL) emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.dataSource ? YES : NO;
}

- (BOOL) emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (CGFloat) verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kTableCellHeight;
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //_tableView.frame = CGRectMake(0, self.titleView.height, self.view.width, self.view.height-self.titleView.height);
        _tableView.backgroundColor = COLOR_BG_LIGHTGRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 100;
        
        [_tableView registerClass:[SubUserCell class] forCellReuseIdentifier:@"SubUserCell"];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}

- (UISwitch *) switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        _switchControl.onTintColor = COLOR_SELECTED;
        
        [_switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

@end

@implementation SubUserCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = WHITE_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;
    self.textLabel.backgroundColor = CLEAR_COLOR;
    self.textLabel.textColor = COLOR_TEXT_DARK;
    self.textLabel.font = [FontUtils normalFont];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0.0f, SCREEN_WIDTH-kOFFSET_SIZE, 0.5f)];
    _lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [self.contentView addSubview:_lineView];
    
    self.seperatorLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1 / [UIScreen mainScreen].scale);
    
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.unbindButton];
    [self.contentView addSubview:self.defaultButton];

    return self;
}

- (void) setSubUser:(SubUser *)subUser
{
    _subUser = subUser;
    
//    if ([UserManager isPrimaryAccount]) {
//        self.defaultButton.hidden = NO;
//    }
//    else {
//        self.defaultButton.hidden = YES;
//    }
    
    if (subUser.avatar && subUser.avatar.length > 0) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:subUser.avatar] placeholderImage:nil options:SDWebImageDelayPlaceholder];
    }
    else {
        self.avatarImage.image = IMAGENAMED(@"userAvator");
    }
    
    self.textLabel.text = subUser.subusername;
    
    if (subUser.istabaccount) {
        [self.defaultButton setNormalTitle:@"主账号"];
        [self.defaultButton setImage:@"icon_check"];
    }
    else {
        [self.defaultButton setNormalTitle:@"设置为主账号"];
        [self.defaultButton setImage:@"icon_uncheck"];
    }
}

- (IBAction) unbindAction:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (IBAction) defaultAction:(id)sender
{
    if (self.subUser.istabaccount) {
        return;
    }
    
    if (self.defaultBlock) {
        self.defaultBlock();
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarImage.top = 20;
    self.seperatorLine.bottom = self.height;
    
    self.textLabel.centerY = self.avatarImage.centerY;
    self.textLabel.left = self.avatarImage.right + kOFFSET_SIZE;

    self.unbindButton.right = SCREEN_WIDTH;
    self.unbindButton.bottom = self.height-.5f;
    
    self.lineView.bottom = self.height - 31;
    
    self.defaultButton.left = kOFFSET_SIZE;
    self.defaultButton.top = self.lineView.bottom;
}

- (UIImageView *) avatarImage
{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOFFSET_SIZE, 0, 30, 30)];
        _avatarImage.backgroundColor = COLOR_BG_LIGHT;
        _avatarImage.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.userInteractionEnabled = YES;
        
        _avatarImage.layer.cornerRadius = 15.0f;
    }
    return _avatarImage;
}

- (UIButton *) unbindButton
{
    if (_unbindButton) {
        return _unbindButton;
    }
    _unbindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _unbindButton.frame = CGRectMake(0, 0, 80, 30);
    _unbindButton.backgroundColor = COLOR_BG_BUTTON;
//    _unbindButton.clipsToBounds = YES;
//    _unbindButton.layer.cornerRadius = 3.0f;
    _unbindButton.titleLabel.font = BOLDSYSTEMFONT(13);
    [_unbindButton setNormalTitle:@"解 绑"];
    [_unbindButton setNormalColor:WHITE_COLOR highlighted:LIGHTGRAY_COLOR selected:nil];
    
    [_unbindButton addTarget:self action:@selector(unbindAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    return _unbindButton;
}

- (IconButton *) defaultButton
{
    if (!_defaultButton) {
        _defaultButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        [_defaultButton setTitleFont:BOLDSYSTEMFONT(13)];
        [_defaultButton setNormalTitle:@"设置为主账号"];
        [_defaultButton setImage:@"icon_check"];
        [_defaultButton setImageSize:15.0f];
        
        [_defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        _defaultButton.hidden = YES;
    }
    return _defaultButton;
}

@end
