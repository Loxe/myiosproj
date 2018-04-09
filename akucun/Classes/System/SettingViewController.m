//
//  SettingViewController.m
//  akucun
//
//  Created by Jarry on 2017/3/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "SettingViewController.h"
#import "TableCellBase.h"
#import "UserManager.h"
#import <GTSDK/GeTuiSdk.h>
#import "SDImageCache.h"
#import "ProductsManager.h"
#import "AboutViewController.h"
#import "TermsViewController.h"
#import "ForwardConfigController.h"
#import "RequestUserLogout.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISwitch *switchControl;

@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation SettingViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"设置";
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Actions

- (IBAction) logout:(id)sender
{
//    [SVProgressHUD showWithStatus:nil];
    RequestUserLogout *request = [RequestUserLogout new];
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
    } onFailed:nil];
    
    [SVProgressHUD showSuccessWithStatus:@"账号已退出"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOKEN_EXPIRED object:nil];

/*
    [GeTuiSdk unbindAlias:[UserManager userId] andSequenceNum:@"seq-1"];
    [UserManager clearToken];
    [UserManager clearUserInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
 */
}

- (void) clearCache
{
    [SVProgressHUD showWithStatus:nil];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
        [self.tableView reloadData];
    }];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

- (void) switchValueChanged:(UISwitch *)stch
{
    [[UserManager instance] saveRemarkSwitch:stch.on];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
//    else if (section == 1) {
//        return 2;
//    }
    
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    header.backgroundColor = COLOR_SEPERATOR_LINE;
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
//    line.backgroundColor = COLOR_SEPERATOR_LINE;
//    [header addSubview:line];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 1) {
//        return kOFFSET_SIZE * 1.5 + 15;
//    }
    return kOFFSET_SIZE;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    /*
    if (section == 1) {
        footer.height = kOFFSET_SIZE * 1.5 + 15;
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.left = kOFFSET_SIZE;
        tipLabel.top = kOFFSET_SIZE*0.5;
        tipLabel.font = [FontUtils smallFont];
        tipLabel.textColor = COLOR_TEXT_NORMAL;
        tipLabel.text = @"备注开关关闭时 下单将直接加入购物车";
        [tipLabel sizeToFit];
        [footer addSubview:tipLabel];
    }*/
    return footer;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row == 0) {
            cell.textLabel.text = @"推送消息设置";
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"同步商品数据";
        }
        else if (indexPath.row == 2) {
            cell.showSeperator = NO;
            cell.textLabel.text = @"清理图片缓存";
            
            NSInteger size = [[SDImageCache sharedImageCache] getSize];
            cell.detailTextLabel.text = FORMAT(@"%.1f M", size/1024.0/1024.0);
        }
    }
    /*
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"转发配置选项";
        }
        else if (indexPath.row == 1) {
            cell.showSeperator = NO;
            cell.selectionDisabled = YES;
            cell.textLabel.text = @"下单备注开关";
        
            CGFloat cellHeight = isPad ? kPadCellHeight : kTableCellHeight;
            self.switchControl.right = self.view.width - kOFFSET_SIZE;
            self.switchControl.centerY = cellHeight/2.0f;
            self.switchControl.on = [UserManager instance].userConfig.remarkSwitch;
            [cell.contentView addSubview:self.switchControl];
        }
    }*/
    else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"使用条款";
        }
        else if (indexPath.row == 1) {
            cell.showSeperator = NO;
            cell.textLabel.text = @"关于我们";
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else if (indexPath.row == 1) {
            [ProductsManager clearHistoryData];
            [SVProgressHUD showSuccessWithStatus:@"商品数据同步完成"];
            /*
            [SVProgressHUD showWithStatus:@"同步数据中..."];
            [ProductsManager syncProducts:^{
                //
                [SVProgressHUD showSuccessWithStatus:@"商品数据同步完成"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_COMPLETE object:nil];
                
            } failed:nil];
             */
        }
        else if (indexPath.row == 2) {
            [self clearCache];
        }
    }
//    else if (indexPath.section == 1 && indexPath.row == 0) {
//        ForwardConfigController *controller = [ForwardConfigController new];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TermsViewController *controller = [TermsViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (indexPath.row == 1) {
            AboutViewController *controller = [AboutViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _tableView.frame = CGRectMake(0, self.titleView.height, self.view.width, self.view.height-self.titleView.height);
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = isPad ? kPadCellHeight : kTableCellHeight;
//        _tableView.bounces = NO;
//        _tableView.alwaysBounceVertical = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE+44)];
        footer.backgroundColor = CLEAR_COLOR;
//        [footer addSubview:self.logoutButton];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (UIButton *) logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _logoutButton.frame = CGRectMake(20, kOFFSET_SIZE, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _logoutButton.clipsToBounds = YES;
        _logoutButton.layer.cornerRadius = 5;
        _logoutButton.layer.borderWidth = 0.5f;
        _logoutButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _logoutButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_logoutButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_logoutButton setBackgroundColor:COLOR_SELECTED];
        [_logoutButton setNormalTitle:@"退出登录"];
        
        [_logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
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
