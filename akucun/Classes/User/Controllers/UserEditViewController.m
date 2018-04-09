//
//  UserEditViewController.m
//  akucun
//
//  Created by Jarry on 2017/4/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "UserEditViewController.h"
#import "BindPhoneController.h"
#import "TableCellBase.h"
#import "UserManager.h"
#import "RequestUserUpdate.h"
#import "NSString+akucun.h"

@interface UserEditViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *nameTextField, *mobileTextField, *wxTextField;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation UserEditViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"信息修改";
    
    [self.view addSubview:self.tableView];
    
    //
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo) {
        self.nameTextField.text = userInfo.name;
        self.mobileTextField.text = userInfo.shoujihao;
//        self.wxTextField.text = userInfo.weixinhao;
    }
}

#pragma mark -

- (IBAction) saveAction:(id)sender
{
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
        return;
    }
    
//    NSString *mobile = self.mobileTextField.text;
//    if (![mobile checkValidateMobile]) {
//        [SVProgressHUD showInfoWithStatus:@"请输入合法的手机号"];
//        return;
//    }

    [self sendRequest];
}

- (void) sendRequest
{
    RequestUserUpdate *request = [RequestUserUpdate new];
    request.name = self.nameTextField.text;
    request.weixinhao = self.wxTextField.text;

    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(id content)
     {
         //
         [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
         
         //
         UserInfo *userInfo = [UserManager instance].userInfo;
         userInfo.name = self.nameTextField.text;
         userInfo.shoujihao = self.mobileTextField.text;
//         userInfo.weixinhao = self.wxTextField.text;

         if (self.finishBlock) {
             self.finishBlock();
         }
         
         [self.navigationController popViewControllerAnimated:YES];
         
     }
                                 onFailed:^(id content)
     {
     }];
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
//    if (section == 0) {
//        return 2;
//    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isPad ? kPadCellHeight : kTableCellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    header.backgroundColor = COLOR_SEPERATOR_LINE;
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kOFFSET_SIZE;
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.showSeperator = NO;
            cell.textLabel.text = @"昵　称 ：";
            [cell.contentView addSubview:self.nameTextField];
        }
        else if (indexPath.row == 1) {
            cell.showSeperator = NO;
            cell.textLabel.text = @"微信号 ：";
            [cell.contentView addSubview:self.wxTextField];
        }
    }
    else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showSeperator = NO;
        cell.textLabel.text = @"绑定手机号";
        UserInfo *userInfo = [UserManager instance].userInfo;
        cell.detailTextLabel.text = userInfo.shoujihao;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    if (indexPath.section == 1) {
        BindPhoneController *controller = [BindPhoneController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(250, 250, 250);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE * 4 + 44)];
        footer.backgroundColor = CLEAR_COLOR;
        [footer addSubview:self.saveButton];
        _tableView.tableFooterView = footer;
        
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

- (UITextField *) nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
        _nameTextField.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH*0.5 - kOFFSET_SIZE, height);
        _nameTextField.font = SYSTEMFONT(15);
        _nameTextField.textColor = COLOR_TEXT_DARK;
        _nameTextField.textAlignment = NSTextAlignmentRight;
        _nameTextField.placeholder = @"";
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UITextField *) mobileTextField
{
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH*0.5 - kOFFSET_SIZE, kTableCellHeight);
        _mobileTextField.font = SYSTEMFONT(15);
        _mobileTextField.textColor = COLOR_TEXT_DARK;
        _mobileTextField.textAlignment = NSTextAlignmentRight;
        _mobileTextField.placeholder = @"";
        _mobileTextField.returnKeyType = UIReturnKeyDone;
        _mobileTextField.delegate = self;
    }
    return _mobileTextField;
}

- (UITextField *) wxTextField
{
    if (!_wxTextField) {
        _wxTextField = [[UITextField alloc] init];
        CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
        _wxTextField.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH*0.5 - kOFFSET_SIZE, height);
        _wxTextField.font = SYSTEMFONT(15);
        _wxTextField.textColor = COLOR_TEXT_DARK;
        _wxTextField.textAlignment = NSTextAlignmentRight;
        _wxTextField.placeholder = @"";
        _wxTextField.returnKeyType = UIReturnKeyDone;
        _wxTextField.delegate = self;
    }
    return _wxTextField;
}

- (UIButton *) saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _saveButton.frame = CGRectMake(20, kOFFSET_SIZE*2, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _saveButton.clipsToBounds = YES;
        _saveButton.layer.cornerRadius = 5;
        _saveButton.layer.borderWidth = 0.5f;
        _saveButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _saveButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_saveButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_saveButton setBackgroundColor:COLOR_SELECTED];
        [_saveButton setNormalTitle:@"保　存"];
        
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
