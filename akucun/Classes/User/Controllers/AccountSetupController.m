//
//  AccountSetupController.m
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "AccountSetupController.h"
#import "TableCellBase.h"
#import "UserManager.h"
#import <GTSDK/GeTuiSdk.h>
#import "SDImageCache.h"
#import "ProductsManager.h"
#import "AboutViewController.h"
#import "TermsViewController.h"
#import "VIPPurchaseController.h"
#import "ForwardConfigController.h"
#import "AddrManageController.h"
#import "UserManagerController.h"
#import "RelatedListController.h"
#import "RelatedAccountController.h"
#import "IDCardController.h"
#import "SettingViewController.h"
#import "RequestUserLogout.h"
#import "RequestModifyUser.h"
#import "RequestRelatedUserList.h"
#import "UIImageView+WebCache.h"

#import "MMAlertView.h"
#import "LZActionSheet.h"
#import "PermissonManger.h"
#import "TZImageManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"

@interface AccountSetupController ()<UITableViewDataSource, UITableViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *avatorImgView;

@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, strong) NSString *nickNameStr;

@property (nonatomic, strong) UIImage  *avatorImg;

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation AccountSetupController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"账户设置";
}

- (void) initViewData
{
    [super initViewData];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    
    [SVProgressHUD showSuccessWithStatus:@"账号已注销"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOKEN_EXPIRED object:nil];
    
    /*
     [GeTuiSdk unbindAlias:[UserManager userId] andSequenceNum:@"seq-1"];
     [UserManager clearToken];
     [UserManager clearUserInfo];
     
     [self dismissViewControllerAnimated:YES completion:nil];
     */
}

- (void) switchValueChanged:(UISwitch *)stch
{
    [[UserManager instance] saveRemarkSwitch:stch.on];
}

#pragma mark -

- (void) requestRelatedUserList
{
    RequestRelatedUserList *request = [RequestRelatedUserList new];
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         [SVProgressHUD dismiss];
         
         ResponseRelatedUserList *response = content;
         [UserManager instance].relatedUserList = response.result;
         if (response.result.count > 0) {
             RelatedListController *controller = [RelatedListController new];
             controller.totalSales = response.totalSales;
             controller.accountSales = response.accountSales;
             controller.shadowSales = response.shadowSales;
             [self.navigationController pushViewController:controller animated:YES];
         }
         else {
             RelatedAccountController *controller = [RelatedAccountController new];
             [self.navigationController pushViewController:controller animated:YES];
         }
     }
                                 onFailed:^(id content)
     {
     }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else if (section == 1) {
        if ([UserManager instance].userInfo.istabaccount) {
            return 5;
        }
        return 3;
    }
    else if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 获取当前登录用户的信息 */
    UserInfo *userInfo = [UserManager instance].userInfo;
    // 头像
    NSString *avatorStr = userInfo.avatar;
    // 用户编号
    NSString *userCode  = userInfo.yonghubianhao;
    // 昵称
    NSString *nickName    = userInfo.name;
    // vip
    NSInteger viplevel    = userInfo.viplevel;
    NSString *viplevelStr = [NSString stringWithFormat:@"VIP%ld",(long)viplevel];
    // 手机号
    NSString *phoneStr    = userInfo.shoujihao;
    NSRange range         = NSMakeRange(3, 4);
    NSString *securPhone  = [phoneStr stringByReplacingCharactersInRange:range withString:@"****"];
    // 认证状态
    BOOL isAuthen = userInfo.identityflag;
    
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionDisabled = YES;
            cell.textLabel.text = @"用户头像";
            
            if (avatorStr && avatorStr.length > 0) {
                [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:avatorStr]];
            }
            self.avatorImgView.bounds   = CGRectMake(0, 0, 60, 60);
            self.avatorImgView.right   = isPad ? self.view.width - 2*kOFFSET_SIZE : self.view.width - kOFFSET_SIZE-20;
            self.avatorImgView.centerY = 40;
            [cell.contentView addSubview:self.avatorImgView];
        }
        else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"用户昵称";
            if (nickName.length > 0) {
                cell.detailTextLabel.text = nickName;
            }
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"手 机 号";
            if (phoneStr.length > 0) {
                cell.detailTextLabel.text = securPhone;
            }
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"代购编号";
            if (userCode.length > 0) {
                cell.detailTextLabel.text = userCode;
            }
            cell.showSeperator = NO;
        }
    }
    else if (indexPath.section == 1) {
        
        NSInteger index = 0;
        if ([UserManager instance].userInfo.istabaccount) {
            index = 2;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"会员等级";
            cell.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
            if (viplevel > 0) {
                cell.detailTextLabel.text = viplevelStr;
            }
            else {
                cell.detailTextLabel.text = @"您还不是会员";
                cell.detailTextLabel.textColor = COLOR_MAIN;
            }
        }
        else if (indexPath.row == index - 1) {
            cell.textLabel.textColor = COLOR_MAIN;
            cell.textLabel.text = @"关联账号管理";
        }
        else if (indexPath.row == index) {
            cell.textLabel.textColor = COLOR_MAIN;
            cell.textLabel.text = @"微信子账号管理";
        }
        else if (indexPath.row == index + 1) {
            cell.textLabel.text = @"地址管理";
        }
        else if (indexPath.row == index + 2) {
            cell.textLabel.text = @"实名认证";
            cell.detailTextLabel.text = isAuthen ? @"已认证": @"未认证";
            cell.accessoryType = isAuthen ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.textColor = isAuthen ? COLOR_TEXT_NORMAL : COLOR_MAIN;
            cell.showSeperator = NO;
        }
    }
    else if (indexPath.section == 2) {
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
    }
    else if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showSeperator = NO;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"设置";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return isPad ? kPadCellHeight : kTableCellHeight;//kPadCellHeight为60
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self showCameraAction];
        }
        else if (indexPath.row == 1) {
            [self showNickNameAlert];
        }
        else if (indexPath.row == 2) {
            
        }
        else if (indexPath.row == 3) {
            
        }
    }
    else if (indexPath.section == 1) { // 会员详情
        NSInteger index = 0;
        if ([UserManager instance].userInfo.istabaccount) {
            index = 2;
        }
        if (indexPath.row == 0) {
            VIPPurchaseController *controller = [VIPPurchaseController new];
            [self.navigationController pushViewController:controller animated:YES];
            /*
            UserInfo *userInfo = [UserManager instance].userInfo;
            if (userInfo.viplevel == 0) {
                MMAlertView *alertView =
                [[MMAlertView alloc] initWithInputTitle:@"您还不是会员"
                                                 detail:@"\n请输入邀请码开通会员"
                                            placeholder:@"输入邀请码"
                                                handler:^(NSString *text)
                 {
                     if (text.length < 6) {
                         [SVProgressHUD showInfoWithStatus:@"请输入正确的邀请码"];
                         return;
                     }
                     [self requestActiveCode:text];
                 }];
                [alertView show];
            }
            */
        }
        else if (indexPath.row == index - 1) {
            // 关联账号
            UserInfo *userInfo = [UserManager instance].userInfo;
            if (userInfo.isrelevance) {
                RelatedAccountController *controller = [RelatedAccountController new];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else {
                //
                [SVProgressHUD showWithStatus:nil];
                [self requestRelatedUserList];
            }
            
        }
        else if (indexPath.row == index) {
            // 子账号管理
            UserManagerController *controller = [UserManagerController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (indexPath.row == index + 1) { // 地址管理
            AddrManageController *controller = [AddrManageController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else { // 认证
            // 如果是未认证才可以进入，反之
            UserInfo *userInfo = [UserManager instance].userInfo;
            BOOL isAuthen = userInfo.identityflag;
            if (!isAuthen) {
                IDCardController *controller = [IDCardController new];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        ForwardConfigController *controller = [ForwardConfigController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) { // 设置
            SettingViewController *controller = [SettingViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
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
    if (section == 2) {
        return kOFFSET_SIZE * 1.5 + 15;
    }
    return kOFFSET_SIZE;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    if (section == 2) {
        footer.height = kOFFSET_SIZE * 1.5 + 15;
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.left = kOFFSET_SIZE;
        tipLabel.top = kOFFSET_SIZE*0.5;
        tipLabel.font = [FontUtils smallFont];
        tipLabel.textColor = COLOR_TEXT_NORMAL;
        tipLabel.text = @"备注开关关闭时 下单将直接加入购物车";
        [tipLabel sizeToFit];
        [footer addSubview:tipLabel];
    }
    return footer;
}

/** 修改头像的弹框 */
- (void)showCameraAction {
    typeof(self) __weak weakSelf = self;
    LZActionSheet *sheet = [[LZActionSheet alloc] initWithTitle:@"修改头像"
                                                   buttonTitles:@[@"拍照",@"从手机相册选择"]
                                                 redButtonIndex:-1
                                                cancelTextColor:[UIColor blackColor]
                                                        clicked:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                [weakSelf takePicture];
                break;
            case 1:
                [weakSelf takeAlbum];
                break;
        }
    }];
    
    [sheet show];
}

/** 修改昵称的弹框 */
- (void)showNickNameAlert {
    NSString *currentnNickName = [UserManager instance].userInfo.name;
    MMAlertView *alert = [[MMAlertView alloc]initWithInputTitle:@"修改昵称" detail:@"" placeholder:currentnNickName handler:^(NSString *text) {
        self.nickNameStr = text;
        // 上传修改数据
        [self changeUserInfo];
    }];
    [alert show];
}

#pragma mark - 拍照
- (void)takePicture {
#if TARGET_IPHONE_SIMULATOR //模拟器
#elif TARGET_OS_IPHONE      //真机
    
    // 先判断相机权限
    AVAuthorizationStatus avAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (avAuthStatus == ALAuthorizationStatusRestricted || avAuthStatus == ALAuthorizationStatusDenied) {
        [self showSettingSuggetAlert];
    }
    
    // 再判断相册写入权限
    ALAuthorizationStatus alAuthStatus = [ALAssetsLibrary authorizationStatus];
    if (alAuthStatus == ALAuthorizationStatusRestricted || alAuthStatus == ALAuthorizationStatusDenied) {
        // 若是已经拒绝，弹框跳到设置页面
        [self showSettingSuggetAlert];
        
    } else {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate      = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType    = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
#endif
}

#pragma mark - 从手机相册选择
- (void)takeAlbum {

    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
    pickerVC.showSelectBtn     = NO;
    pickerVC.allowCrop         = YES;
    pickerVC.allowPickingImage = YES;
    pickerVC.allowPickingVideo = NO;
    pickerVC.allowPickingGif   = NO;
    
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 0;//30
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    pickerVC.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - 修改头像或者昵称
- (void)changeUserInfo {
    [SVProgressHUD showWithStatus:nil];
    RequestModifyUser *request = [RequestModifyUser new];
    request.nicheng    = self.nickNameStr;
    NSData *avatorData = UIImageJPEGRepresentation(self.avatorImg, 0.5f);
    request.base64Img  = [avatorData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [SCHttpServiceFace serviceWithPostRequest:request onSuccess:^(id content) {
//        POPUPINFO(@"修改成功");
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.tableView reloadData];
    } onFailed:^(id content) {
        return;
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectedImage = [[UIImage alloc]init];
    if (picker.allowsEditing) {
        selectedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    self.avatorImg = selectedImage;

    // 上传修改数据
    [self changeUserInfo];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (photos.count != 0) {
        self.avatorImg = photos[0];
        
        // 上传修改数据
        [self changeUserInfo];
    }
}

- (void)showSettingSuggetAlert {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"权限设置" message:@"当前未有摄像头、麦克风或者相册的访问权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[PermissonManger new] toSettingPage];
    }];
    [vc addAction:cancelAction];
    [vc addAction:settingAction];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //_tableView.frame = CGRectMake(0, self.titleView.height, self.view.width, self.view.height-self.titleView.height);
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.rowHeight = isPad ? kPadCellHeight : kTableCellHeight;
        //_tableView.bounces = NO;
        //_tableView.alwaysBounceVertical = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE*4+44)];
        footer.backgroundColor = CLEAR_COLOR;
        [footer addSubview:self.logoutButton];
        _tableView.tableFooterView = footer;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
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

- (UIImageView *) avatorImgView
{
    if (!_avatorImgView) {
        _avatorImgView = [[UIImageView alloc] init];
        _avatorImgView.image = [UIImage imageNamed:@"userAvator"];
        
        _avatorImgView.layer.cornerRadius  = 5.0f;
        _avatorImgView.layer.masksToBounds = YES;
    }
    return _avatorImgView;
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


