//
//  AddressViewController.m
//  akucun
//
//  Created by Jarry on 2017/4/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AddressViewController.h"
#import "PlaceholderTextView.h"
#import "ZYKeyboardUtil.h"
#import "PopupPickerView.h"
#import "RequestAddAddr.h"
#import "RequestModifyAddr.h"
#import "RequestOrderModifyAddr.h"
#import "RequestAddrValidateCode.h"
#import "UserManager.h"
#import "TipMessageView.h"
#import "AKAlertView.h"
#import "SMSAlertView.h"

@interface AddressViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

//@property (nonatomic,strong) TipMessageView *messageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *nameTextField, *mobileTextField;
@property (nonatomic, strong) PlaceholderTextView *addressTextView;

@property (nonatomic, strong) UISwitch *switchControl;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSArray *citysData;

@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, copy) NSString *province, *city, *area, *address;

@end

@implementation AddressViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"新建地址";

//    [self.messageView hide];
//    [self.view addSubview:self.messageView];
    [self.view addSubview:self.tableView];
    
    /*
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (userInfo && userInfo.addr) {
        self.province = userInfo.addr.province;
        self.city = userInfo.addr.city;
        self.area = userInfo.addr.area;
        self.address = userInfo.addr.address;
        
        self.nameTextField.text = userInfo.addr.name;
        self.mobileTextField.text = userInfo.addr.mobile;
        self.addressTextView.text = self.address;
        
        self.title = @"编辑地址";
    }
     */
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GCD_DEFAULT(^{
        // 异步 读取省份城市信息
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        _citysData = [data objectFromJSONData];
    });
    
    //
//    [UIView animateWithDuration:.3f animations:^{
//        [self.messageView show];
//        [self.view layoutIfNeeded];
//    }];
}

- (void) setAddr:(Address *)addr
{
    _addr = addr;
    
    self.province = addr.province;
    self.city = addr.city;
    self.area = [addr.area stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.address = addr.address;
    
    //
    if ([self.province isEqualToString:@"上海市"]) {
        self.province = @"上海";
        self.city = self.province;
    }
    else if ([self.province isEqualToString:@"北京市"]) {
        self.province = @"北京";
        self.city = self.province;
    }
    else if ([self.province isEqualToString:@"天津市"]) {
        self.province = @"天津";
        self.city = self.province;
    }
    else if ([self.province isEqualToString:@"重庆市"]) {
        self.province = @"重庆";
        self.city = self.province;
    }
    
    self.nameTextField.text = addr.name;
    self.mobileTextField.text = addr.mobile;
    self.addressTextView.text = addr.address;
    
    self.title = @"编辑地址";
}

- (void) setAdOrder:(AdOrder *)adOrder
{
    _adOrder = adOrder;
    
    NSArray *array = [adOrder.shouhuodizhi componentsSeparatedByString:@" "];
    if (array.count >= 4) {
        self.province = array[0];
        self.city = array[1];
        self.area = array[2];
        self.address = [adOrder.shouhuodizhi stringByReplacingOccurrencesOfString:FORMAT(@"%@ %@ %@ ", self.province, self.city, self.area) withString:@""];
    }
    else if (array.count == 3) {
        self.province = array[0];
        self.city = array[0];
        self.area = array[1];
        self.address = array[2];
    }
    
    self.nameTextField.text = adOrder.shouhuoren;
    self.mobileTextField.text = adOrder.lianxidianhua;
    self.addressTextView.text = self.address;

    self.title = @"修改地址";
}

#pragma mark -

- (IBAction) saveAction:(id)sender
{
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入收货人名字"];
        return;
    }
    
    if(![self.mobileTextField.text checkValidateMobile])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (!self.province || !self.city || !self.area) {
        [SVProgressHUD showInfoWithStatus:@"请选择城市信息"];
        return;
    }
    
    if (self.addressTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址信息"];
        return;
    }
    
    NSInteger totalCount = [UserManager instance].addrCount;
    NSInteger changedCount = [UserManager instance].addrChanged;
    NSString *title = FORMAT(@"每月只能修改 %ld 次收货地址，\n当前已经修改 %ld 次", (long)totalCount, (long)changedCount);
    @weakify(self)
    MMPopupItemHandler handler = ^(NSInteger index) {
        if (index == 1) {
            @strongify(self)
            if (totalCount > changedCount) {
                [self showSMSAlert:self.mobileTextField.text];
            }
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, handler),
      MMItemMake(@"确定", MMItemTypeHighlight, handler)];
    AKAlertView *alertView = [[AKAlertView alloc] initWithConfirmTitle:FA_ICONFONT_ALERT titleFont:FA_ICONFONTSIZE(35) titleColor:RED_COLOR detail:title items:items];
    alertView.attachedView = self.navigationController.view;
    [alertView show];
}

- (void) showSMSAlert:(NSString *)mobile
{
    SMSAlertView *alertView = [[SMSAlertView alloc] initWithTitle:@"校验手机号" mobile:mobile];
    alertView.attachedView = self.navigationController.view;
    @weakify(self)
    alertView.confirmBlock = ^(id content) {
        @strongify(self)
        [self requestValidateCode:content];
    };
    
    [alertView show];
}

- (void) sendRequest
{
    [SVProgressHUD showWithStatus:nil];
    BOOL isDefault = self.switchControl.on;
    HttpRequestPOST *addrRequest = nil;
    if (self.adOrder) {
        RequestOrderModifyAddr *request = [RequestOrderModifyAddr new];
        request.adorderid = self.adOrder.adorderid;
        request.name = self.nameTextField.text;
        request.mobile = self.mobileTextField.text;
        request.province = self.province;
        request.city = self.city;
        request.area = self.area;
        request.address = self.addressTextView.text;
        
        addrRequest = request;
    }
    else if (self.addr) {
        RequestModifyAddr2 *request = [RequestModifyAddr2 new];
        request.addrid = self.addr.addrid;
        request.name = self.nameTextField.text;
        request.mobile = self.mobileTextField.text;
        request.province = self.province;
        request.city = self.city;
        request.area = self.area;
        request.address = self.addressTextView.text;
        request.defaultflag = isDefault ? 1 : 0;

        addrRequest = request;
    }
    else {
        RequestAddAddr2 *request = [RequestAddAddr2 new];
        request.name = self.nameTextField.text;
        request.mobile = self.mobileTextField.text;
        request.province = self.province;
        request.city = self.city;
        request.area = self.area;
        request.address = self.addressTextView.text;
        request.defaultflag = isDefault ? 1 : 0;
/*
        UserInfo *userInfo = [UserManager instance].userInfo;
        if (!userInfo.addrList || userInfo.addrList.count == 0) {
            request.defaultflag = 1;
            isDefault = YES;
        }
*/
        addrRequest = request;
    }
    
    [SCHttpServiceFace serviceWithPostRequest:addrRequest
                                    onSuccess:^(id content)
     {
         //
         if (self.adOrder) {
             [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
         }
         else if (self.addr) {
             [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
         }
         else {
             [SVProgressHUD showSuccessWithStatus:@"新地址已添加！"];
             
             HttpResponseBase *response = content;
             NSDictionary *jsonData = response.responseData;
             NSString *addrId = [jsonData getStringForKey:@"addrid"];
             
             if (isDefault) {
                 Address *address = [Address new];
                 address.addrid = addrId;
                 address.name = self.nameTextField.text;
                 address.mobile = self.mobileTextField.text;
                 address.province = self.province;
                 address.city = self.city;
                 address.area = self.area;
                 address.address = self.addressTextView.text;
                 //
                 UserInfo *userInfo = [UserManager instance].userInfo;
                 userInfo.addr = address;
                 NSMutableArray *array = [NSMutableArray arrayWithArray:userInfo.addrList];
                 [array addObject:address];
                 userInfo.addrList = array;
             }             
         }

         GCD_DELAY(^{
             if (self.finishBlock) {
                 self.finishBlock();
             }
             [self.navigationController popViewControllerAnimated:YES];
         }, 1.0f);
     }
                                 onFailed:^(id content)
     {
     }];
}

- (void) requestValidateCode:(NSString *)code
{
    [SVProgressHUD showWithStatus:nil];
    RequestAddrValidateCode *request = [RequestAddrValidateCode new];
    request.phone = self.mobileTextField.text;
    request.code = code;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
    {
        [self sendRequest];
        
    } onFailed:nil];
}

#pragma mark -

- (NSArray *) provinceArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *item in self.citysData) {
        [array addObject:item[@"name"]];
    }
    
    return array;
}

- (NSArray *) citysArrayBy:(NSString *)province
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *item in self.citysData) {
        NSString *name = item[@"name"];
        if ([province hasPrefix:name]) {
            self.cityArray = item[@"city"];
            for (NSDictionary *city in self.cityArray) {
                [array addObject:city[@"name"]];
            }
        }
    }
    return array;
}

- (NSArray *) areasArrayBy:(NSString *)city
{
    NSMutableArray *array = [NSMutableArray array];
    if (!self.cityArray) {
        for (NSDictionary *item in self.citysData) {
            NSString *name = item[@"name"];
            if ([self.province hasPrefix:name]) {
                self.cityArray = item[@"city"];
            }
        }
    }
    
    for (NSDictionary *item in self.cityArray) {
        NSString *name = item[@"name"];
        if ([city hasPrefix:name]) {
            [array addObjectsFromArray:item[@"area"]];
        }
    }
    return array;
}

- (void) selectProvince
{
    PopupPickerView *pickerView = [[PopupPickerView alloc] init];
    pickerView.dataArray = [NSArray arrayWithObject:[self provinceArray]];
    pickerView.selectedItem = self.province;
    @weakify(self)
    [pickerView showWithConfirmBlock:^(id content) {
        @strongify(self)
        self.province = content;
        self.city = nil;
        self.area = nil;
        
        [self.tableView reloadData];
        [self selectCity];
    }];
}

- (void) selectCity
{
    PopupPickerView *pickerView = [[PopupPickerView alloc] init];
    pickerView.dataArray = [NSArray arrayWithObject:[self citysArrayBy:self.province]];
    pickerView.selectedItem = self.city;
    @weakify(self)
    [pickerView showWithConfirmBlock:^(id content) {
        @strongify(self)
        self.city = content;
        self.area = nil;
        
        [self.tableView reloadData];
        [self selectArea];
    }];
}

- (void) selectArea
{
    PopupPickerView *pickerView = [[PopupPickerView alloc] init];
    pickerView.dataArray = [NSArray arrayWithObject:[self areasArrayBy:self.city]];
    pickerView.selectedItem = self.area;
    @weakify(self)
    [pickerView showWithConfirmBlock:^(id content) {
        @strongify(self)
        self.area = content;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.adOrder) {
        return 6;
    }
    return 7;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 120.0f;
    }
    return isPad ? 50.0f : kTableCellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    header.backgroundColor = COLOR_SEPERATOR_LINE;
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kOFFSET_SIZE-1.0f, SCREEN_WIDTH, 1.0f)];
//    line.backgroundColor = COLOR_SEPERATOR_LINE;
//    [header addSubview:line];
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    footer.backgroundColor = COLOR_SEPERATOR_LINE;
    return footer;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

    if (indexPath.row == 0) {
        cell.showAccessory = NO;
        cell.textLabel.text = @"收货人 ：";
        [cell.contentView addSubview:self.nameTextField];
    }
    else if (indexPath.row == 1) {
        cell.showAccessory = NO;
        cell.textLabel.text = @"电　话 ：";
        [cell.contentView addSubview:self.mobileTextField];
    }
    
    else if (indexPath.row == 2) {
        cell.showAccessory = YES;
        cell.textLabel.text = @"省　份";
        cell.detailTextLabel.text = self.province ? self.province : @"请选择";
        [cell setCellSelection:YES];
    }
    else if (indexPath.row == 3) {
        cell.showAccessory = YES;
        cell.textLabel.text = @"城　市";
        cell.detailTextLabel.text = self.city ? self.city : @"请选择";
        [cell setCellSelection:(self.province!=nil)];
    }
    else if (indexPath.row == 4) {
        cell.showAccessory = YES;
        cell.textLabel.text = @"地　区";
        cell.detailTextLabel.text = self.area ? self.area : @"请选择";
        [cell setCellSelection:(self.city!=nil)];
    }
    else if (indexPath.row == 5) {
        cell.showAccessory = NO;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text= @"";
        self.addressTextView.text = self.address;
        [cell.contentView addSubview:self.addressTextView];
    }
    else if (indexPath.row == 6) {
        cell.showAccessory = NO;
        cell.textLabel.text = @"设为默认地址";
        if (self.addr) {
            self.switchControl.on = (self.addr.defaultflag == 0);
            if (self.addr.defaultflag == 0) {
                self.switchControl.enabled = NO;
            }
        }
        else {
            self.switchControl.enabled = NO;
            self.switchControl.on = YES;
//            UserInfo *userInfo = [UserManager instance].userInfo;
//            if (!userInfo.addrList || userInfo.addrList.count == 0) {
//                self.switchControl.on = YES;
//            }
//            else {
//                self.switchControl.on = NO;
//            }
        }
        self.switchControl.right = self.view.width - kOFFSET_SIZE;
        CGFloat height = isPad ? 50.0f : kTableCellHeight;
        self.switchControl.centerY = height/2.0f;
        [cell.contentView addSubview:self.switchControl];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self.nameTextField becomeFirstResponder];
        return;
    }
    else if (indexPath.row == 1) {
        [self.mobileTextField becomeFirstResponder];
        return;
    }
    
    [self.view endEditing:YES];
    
    if (indexPath.row == 2) {
        [self selectProvince];
    }
    else if (indexPath.row == 3) {
        if (!self.province) {
            return;
        }
        [self selectCity];
    }
    else if (indexPath.row == 4) {
        if (!self.city) {
            return;
        }
        [self selectArea];
    }
    else if (indexPath.row == 6 && self.switchControl.enabled) {
        BOOL on = self.switchControl.on;
        [self.switchControl setOn:!on animated:YES];
//        self.switchControl.on = !on;
    }
}

#pragma mark - Lazy Load
/*
- (TipMessageView *) messageView
{
    if (!_messageView) {
        NSString *msg = @"注意：代购您好！爱库存不支持一件代发，请不要直接填写客户地址，仅限代购本人收货地址，爱库存合并发货，如果您直接填写客户地址造成您的货品全部发到客户地址，造成的后果有您自己承担！谢谢配合！";
        _messageView = [[TipMessageView alloc] initWithFrame:CGRectZero message:msg];
        @weakify(self)
        _messageView.closeBlock = ^{
            @strongify(self)
            [UIView animateWithDuration:.3f animations:^{
                [self.messageView hide];
                [self.view layoutIfNeeded];
            }];
        };
    }
    return _messageView;
}
*/
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
        _nameTextField.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH*0.5 - kOFFSET_SIZE, 50);
        _nameTextField.font = SYSTEMFONT(15);
        _nameTextField.textColor = COLOR_TEXT_DARK;
        _nameTextField.textAlignment = NSTextAlignmentRight;
        _nameTextField.placeholder = @"请输入收货人名字";
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UITextField *) mobileTextField
{
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH*0.5 - kOFFSET_SIZE, 50);
        _mobileTextField.font = SYSTEMFONT(15);
        _mobileTextField.textColor = COLOR_TEXT_DARK;
        _mobileTextField.textAlignment = NSTextAlignmentRight;
        _mobileTextField.placeholder = @"请输入收货人手机号";
        _mobileTextField.returnKeyType = UIReturnKeyDone;
        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.delegate = self;
    }
    return _mobileTextField;
}

- (PlaceholderTextView *) addressTextView
{
    if (!_addressTextView) {
        _addressTextView = [[PlaceholderTextView alloc] initWithPlaceholder:@"输入详细地址，如街道、楼牌号等"];
        CGFloat offset = kOFFSET_SIZE * 0.8;
        _addressTextView.frame = CGRectMake(offset, 10, SCREEN_WIDTH-offset*2, 100);
        _addressTextView.font = SYSTEMFONT(15);
        _addressTextView.textColor = COLOR_TEXT_DARK;
        _addressTextView.placeholderFont = SYSTEMFONT(15);
        _addressTextView.returnKeyType = UIReturnKeyDone;
    }
    return _addressTextView;
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

- (UISwitch *) switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        _switchControl.onTintColor = COLOR_SELECTED;
        
        [_switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

- (void) switchValueChanged:(UISwitch *)stch
{

}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

@implementation AddressCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = WHITE_COLOR;
    self.contentView.backgroundColor = WHITE_COLOR;
    self.textLabel.textColor = COLOR_TEXT_NORMAL;
    self.textLabel.font = SYSTEMFONT(15);
    
    self.detailTextLabel.font = SYSTEMFONT(15);
    self.detailTextLabel.textColor = COLOR_TEXT_DARK;
    
    self.accessoryType = UITableViewCellAccessoryNone;

    _accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    _accessoryLabel.backgroundColor = CLEAR_COLOR;
    _accessoryLabel.textColor = COLOR_TEXT_DARK;
    _accessoryLabel.textAlignment = NSTextAlignmentRight;
    _accessoryLabel.font = FA_ICONFONTSIZE(25);
    _accessoryLabel.text = FA_ICONFONT_RIGHT;
    self.accessoryView = _accessoryLabel;
    
    _seperatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    _seperatorLine.backgroundColor = COLOR_SEPERATOR_LINE;
    [self.contentView addSubview:_seperatorLine];
    
    [self setCellSelection:NO];
    
    return self;
}

- (void) setShowAccessory:(BOOL)showAccessory
{
    _showAccessory = showAccessory;
    
    self.accessoryView.hidden = !showAccessory;
}

- (void) setCellSelection:(BOOL)enable
{
    UIColor *color;
    
    if (enable) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        color = COLOR_TEXT_DARK;
    }
    else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        color = COLOR_TEXT_LIGHT;
    }
    
    self.detailTextLabel.textColor = color;
    self.accessoryLabel.textColor = color;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    self.textLabel.textColor = highlighted ? COLOR_SELECTED : COLOR_TEXT_NORMAL;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.left = kOFFSET_SIZE;
    self.detailTextLabel.right = SCREEN_WIDTH-kOFFSET_SIZE-20;
    self.accessoryView.right = SCREEN_WIDTH-kOFFSET_SIZE;
    
    self.seperatorLine.bottom = self.height-0.5f;
    self.seperatorLine.width = self.width;
    self.seperatorLine.height = 0.5f;
}

@end
