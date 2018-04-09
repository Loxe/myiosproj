//
//  BuyViewController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/5.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BuyViewController.h"
#import "PayViewController.h"
#import "AddressViewController.h"
#import "AddrManageController.h"
#import "AddressView.h"
#import "MMAlertView.h"
#import "Gallop.h"
#import "UserManager.h"
#import "TableCellBase.h"
#import "RequestDirectBuy.h"
#import "RequestGetSKU.h"

@interface BuyViewController () <UITableViewDataSource, UITableViewDelegate, LWAsyncDisplayViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) AddressView *addressView;
@property (nonatomic, assign) NSInteger selectedAddr;

@property (nonatomic, strong) LWAsyncDisplayView* productView;
@property (nonatomic, strong) LWTextStorage* skuStorage;
@property (nonatomic, assign) CGRect skuBgRect;

@property (nonatomic, copy) NSString *remark;

@end

@implementation BuyViewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = COLOR_BG_LIGHTGRAY;
    
    self.title = @"立即下单";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    
    CGFloat height = isPad ? kFIELD_HEIGHT_PAD : kFIELD_HEIGHT;
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, kOFFSET_SIZE, kOFFSET_SIZE+kSafeAreaBottomHeight, kOFFSET_SIZE));
        make.height.mas_equalTo(@(height));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.submitButton.mas_top).offset(-kOFFSET_SIZE);
    }];
}

- (void) initViewData
{
    [super initViewData];
    
    //
    UserInfo *userInfo = [UserManager instance].userInfo;
    self.addressView.address = userInfo.defaultAddr;
    [self.addressView updateLayout];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //
    UserInfo *userInfo = [UserManager instance].userInfo;
    NSArray *addrList = userInfo.addrList;
    if (self.selectedAddr >= addrList.count) {
        self.selectedAddr = 0;
    }
    if (self.selectedAddr == 0) {
        self.addressView.address = userInfo.defaultAddr;
    }
    
    if (self.product) {
        [self requestGetSKU:self.product];
    }
        
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

- (void) setProduct:(ProductModel *)product
{
    _product = product;

    self.productView.layout = [self setupLayout];
    [self.tableView reloadData];
    
    [self updateButton];
}

- (void) updateButton
{
    [self.submitButton setNormalTitle:@"提交订单"];
    if ([_product isQuehuo]) {
        [self.submitButton setNormalTitle:@"卖光了"];
        self.submitButton.enabled = NO;
    }
    else if (!self.sku || [_product isQuehuo:self.sku]) {
        self.submitButton.enabled = NO;
    }
    else {
        self.submitButton.enabled = YES;
    }
}

#pragma mark - Actions

- (void) editAddressAction
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (!userInfo.defaultAddr) {
        AddressViewController *controller = [AddressViewController new];
        @weakify(self)
        controller.finishBlock = ^{
            @strongify(self)
            UserInfo *userInfo = [UserManager instance].userInfo;
            self.addressView.address = userInfo.defaultAddr;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    AddrManageController *controller = [AddrManageController new];
    controller.selectIndex = self.selectedAddr;
    @weakify(self)
    controller.finishBlock = ^(id content) {
        @strongify(self)
        UserInfo *userInfo = [UserManager instance].userInfo;
        self.selectedAddr = [userInfo.addrList indexOfObject:content];
        self.addressView.address = content;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) submitAction:(id)sender
{
    UserInfo *userInfo = [UserManager instance].userInfo;
    if (!userInfo.defaultAddr) {
        [SVProgressHUD showInfoWithStatus:@"请添加收货地址！"];
        return;
    }
    
    //
    MMPopupItemHandler block = ^(NSInteger index) {
        if (index == 1) {
            // Request
            [self requestDirectBuy];
            self.submitButton.enabled = NO;
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"去支付", MMItemTypeHighlight, block)];
    
    NSString *detail = FORMAT(@"\n一共 1 件   结算金额 ¥ %.2f 元\n\n", self.product.jiesuanjia/100.0f);
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:detail];
    NSMutableAttributedString *msgAttrStr = [[NSMutableAttributedString alloc] initWithString:@"(单场活动最多可取消 5 件商品 ！)"];
    [msgAttrStr addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(15) range:NSMakeRange(0, msgAttrStr.length)];
    [msgAttrStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(0, msgAttrStr.length)];
    [attrStr appendAttributedString:msgAttrStr];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"立即去支付 ?" attrDetail:attrStr items:items];
    [alertView show];

}

#pragma mark - Request

- (void) requestDirectBuy
{
    [SVProgressHUD showWithStatus:nil];
    
    RequestDirectBuy *request = [RequestDirectBuy new];
    request.liveId = self.product.liveid;
    request.productId = self.product.Id;
    request.skuId = self.sku.Id;
    
    UserInfo *userInfo = [UserManager instance].userInfo;
    Address *addr = [userInfo.addrList objectAtIndex:self.selectedAddr];
    request.addrId = addr.addrid;
    
    if (self.remark) {
        request.remark = self.remark;
    }
    
    [SCHttpServiceFace serviceWithPostRequest:request
                                    onSuccess:^(HttpResponseBase *response)
     {
         //
         [SVProgressHUD dismiss];
         
         NSDictionary *jsonData = response.responseData;
         OrderModel *order = [OrderModel new];
         order.orderid = [jsonData getStringForKey:@"orderid"];
         order.zongjine = [jsonData getIntegerValueForKey:@"total_amount"];
         order.yunfei = [jsonData getIntegerValueForKey:@"total_yunfeijine"];
         order.shangpinjine = [jsonData getIntegerValueForKey:@"total_shangpinjine"];
         order.dikoujine = [jsonData getIntegerValueForKey:@"total_dikoujine"];
         order.shangpinjianshu = 1;
         
         PayViewController *payController = [PayViewController new];
         payController.order = order;
         payController.orderIds = @[order.orderid];
         payController.address = addr;
         @weakify(self)
         payController.finishBlock = ^{
             @strongify(self)
             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
             order.status = 1;
             self.finishBlock(order);
         };
         payController.cancelBlock = ^{
             @strongify(self)
             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
         };
         [self.navigationController pushViewController:payController animated:YES];

     } onFailed:^(id content) {
         self.submitButton.enabled = YES;
//         [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//         if (self.finishBlock) {
//             self.finishBlock(content);
//         }
     }];
}

- (void) requestGetSKU:(ProductModel *)product
{
    RequestGetSKU *request = [RequestGetSKU new];
    request.productId = product.Id;
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseSKUList *response = content;
         self.product = response.product;
     }
                                 onFailed:nil];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 0;
    }
    if (!self.product) {
        return 0;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return [self.productView.layout suggestHeightWithBottomMargin:kOFFSET_SIZE];
    }
    CGFloat height = isPad ? kPadCellHeight : kTableCellHeight;
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.addressView.height;
    }
    if (!self.product) {
        return 0;
    }
    return kPIXEL_WIDTH;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat offset = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.addressView.bottom + offset)];
        header.backgroundColor = CLEAR_COLOR;
        
//        UserInfo *userInfo = [UserManager instance].userInfo;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
        line.backgroundColor = COLOR_SEPERATOR_LIGHT;
        [header addSubview:line];
        
        [header addSubview:self.addressView];
        
        return header;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPIXEL_WIDTH)];
    header.backgroundColor = COLOR_SEPERATOR_LIGHT;
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section > 0 && !self.product) {
        return 0;
    }
    return isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = isPad ? kOFFSET_SIZE_PAD : kOFFSET_SIZE;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    return footer;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = WHITE_COLOR;
        cell.contentView.backgroundColor = CLEAR_COLOR;
        [cell.contentView addSubview:self.productView];
        [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(cell.contentView);
        }];
        return cell;
    }
    
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.showSeperator = NO;
    cell.detailTextLabel.textColor = RED_COLOR;

    cell.textLabel.text = @"添加备注";
    if (self.remark) {
        cell.textLabel.text = @"备注";
        cell.detailTextLabel.text = self.remark;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        @weakify(self)
        MMAlertView *alertView =
        [[MMAlertView alloc] initWithInputTitle:@"添加备注\n"
                                         detail:@""
                                    placeholder:@"请输入备注信息"
                                        handler:^(NSString *text)
         {
             @strongify(self)
             self.remark = text;
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
         }];
        [alertView show];
    }
}

#pragma mark - Lazy Load

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = CLEAR_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.showsVerticalScrollIndicator = NO;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
        footer.backgroundColor = CLEAR_COLOR;
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

- (AddressView *) addressView
{
    if (!_addressView) {
        _addressView  = [[AddressView alloc] initWithFrame:CGRectZero];
        _addressView.backgroundColor = WHITE_COLOR;
        @weakify(self)
        _addressView.actionBlock = ^ {
            @strongify(self)
            [self editAddressAction];
        };
    }
    return _addressView;
}

- (UIButton *) submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _submitButton.frame = CGRectMake(20, kOFFSET_SIZE, SCREEN_WIDTH - 40, isPad ? 50 : kFIELD_HEIGHT);
        _submitButton.clipsToBounds = YES;
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.borderWidth = 0.5f;
        _submitButton.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        
        _submitButton.titleLabel.font = BOLDSYSTEMFONT(16);
        
        [_submitButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        [_submitButton setBackgroundColor:COLOR_SELECTED];
        [_submitButton setNormalTitle:@"提交订单"];
        
        [_submitButton setBackgroundImage:[UIImage imageWithColor:COLOR_SELECTED] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_LIGHT] forState:UIControlStateDisabled];

        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (LWAsyncDisplayView *) productView
{
    if (!_productView) {
        _productView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _productView.displaysAsynchronously = NO;
        _productView.delegate = self;
    }
    return _productView;
}

- (LWLayout *) setupLayout
{
    LWLayout *layout = [[LWLayout alloc] init];
    // 发布的图片模型 imgsStorage
    CGFloat imageWidth = 40.0f;
    NSArray *images = [self.product imagesUrl];
    NSInteger imageCount = [images count];
    NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    NSInteger row = 0;
    NSInteger column = 0;
    for (NSInteger i = 0; i < imageCount; i ++) {
        CGRect imageRect = CGRectMake(kOFFSET_SIZE + (column * (imageWidth + 5.0f)),
                                      kOFFSET_SIZE + (row * (imageWidth + 5.0f)),
                                      imageWidth,
                                      imageWidth);
        
        NSString* imagePositionString = NSStringFromCGRect(imageRect);
        [imagePositionArray addObject:imagePositionString];
        LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
        imageStorage.clipsToBounds = YES;
        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
        imageStorage.tag = i;
        imageStorage.frame = imageRect;
        imageStorage.backgroundColor = RGB(240, 240, 240, 1);
        NSString* URLString = [images objectAtIndex:i];
        imageStorage.contents = [NSURL URLWithString:URLString];
        [imageStorageArray addObject:imageStorage];
        column = column + 1;
        if (imageCount == 4 && column > 1) {
            column = 0;
            row = row + 1;
        }
        else if (column > 2) {
            column = 0;
            row = row + 1;
        }
    }
    
    // 正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    contentTextStorage.maxNumberOfLines = 6;//设置最大行数，超过则折叠
    contentTextStorage.text = [self.product productDesc];
    contentTextStorage.font = [FontUtils smallFont];
    contentTextStorage.textColor = COLOR_TEXT_DARK;
    CGFloat left = kOFFSET_SIZE*2 + 85;
    contentTextStorage.frame = CGRectMake(left,
                                          kOFFSET_SIZE,
                                          SCREEN_WIDTH - left - kOFFSET_SIZE ,
                                          CGFLOAT_MAX);
    
    NSArray *skus = self.product.skus;
    NSInteger skuCount = skus.count;
    NSMutableArray* skuStorageArray = [[NSMutableArray alloc] initWithCapacity:skuCount];
    CGFloat spacing = 8.0f;
    row = 0;
    CGFloat x = kOFFSET_SIZE + spacing;
    CGFloat y = MAX(contentTextStorage.bottom + 8, kOFFSET_SIZE*2 + 85);
    CGRect skuBgRect = CGRectMake(kOFFSET_SIZE, y, SCREEN_WIDTH-kOFFSET_SIZE*2, 60);
    
    CGFloat skuWidth = 0.0f;
    for (NSInteger i = 0; i < skuCount; i ++) {
        if (x + skuWidth > skuBgRect.origin.x + skuBgRect.size.width) { //column > 2
            row = row + 1;
            x = kOFFSET_SIZE + spacing;
        }
        CGFloat y = skuBgRect.origin.y + spacing*2 + (row * (24 + spacing));
        CGRect skuRect = CGRectMake(x, y, skuBgRect.size.width, 24);
        ProductSKU *sku = skus[i];
        sku.isChecked = NO;
        NSString *skuText = FORMAT(@"　 %@ 　", sku.chima);
        
        LWTextStorage* skuStorage = [[LWTextStorage alloc] init];
        skuStorage.textBackgroundColor = COLOR_BG_TEXT_DISABLED;
        skuStorage.frame = skuRect;
        skuStorage.text = skuText;
        skuStorage.font = TNRFONTSIZE(14);
        skuStorage.textColor = COLOR_TEXT_DISABLED;
        skuStorage.linespacing = 10.0f;
        
        if (self.sku && [self.sku.Id isEqualToString:sku.Id]) {
            self.sku = sku;
        }

        if (sku.shuliang > 0) {
            skuStorage.textBackgroundColor = COLOR_BG_TEXT;
            [skuStorage lw_addLinkWithData:sku
                                     range:NSMakeRange(0, skuText.length)
                                 linkColor:COLOR_TEXT_LINK
                            highLightColor:COLOR_BG_TEXT];
            
            if (self.sku && [self.sku.Id isEqualToString:sku.Id]) {
                skuStorage.textBackgroundColor = COLOR_SELECTED;
                skuStorage.textColor = WHITE_COLOR;
                sku.isChecked = YES;
                self.skuStorage = skuStorage;
            }
        }
        
        [skuStorageArray addObject:skuStorage];
        x = (skuStorage.right + spacing) + 18;
        skuWidth = skuStorage.width + spacing;
    }
    skuBgRect.size.height = (row + 1) * (24 + spacing) + spacing*4;
    self.skuBgRect = skuBgRect;
    
    //
    LWTextStorage* priceTextStorage = [[LWTextStorage alloc] init];
    priceTextStorage.font = BOLDSYSTEMFONT(18);
    priceTextStorage.textColor = RED_COLOR;
    priceTextStorage.textAlignment = NSTextAlignmentRight;
    priceTextStorage.frame = CGRectMake(skuBgRect.origin.x,
                                         skuBgRect.origin.y + skuBgRect.size.height + kOFFSET_SIZE,
                                         skuBgRect.size.width,
                                         CGFLOAT_MAX);
    priceTextStorage.text = [self.product jiesuanPrice];
    [priceTextStorage.attributedText addAttributes:@{ NSFontAttributeName:[FontUtils smallFont] } range:NSMakeRange(0, 5)];
    [priceTextStorage updateTextLayout];

    [layout addStorage:contentTextStorage];
    [layout addStorages:imageStorageArray];
    [layout addStorages:skuStorageArray];
    [layout addStorage:priceTextStorage];

    return layout;
}

#pragma mark - LWAsyncDisplayViewDelegate

// 额外的绘制
- (void) extraAsyncDisplayIncontext:(CGContextRef)context
                               size:(CGSize)size
                        isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled
{
    if (!isCancelled()) {
        CGContextSetLineWidth(context, kPIXEL_WIDTH);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        
        CGContextSetFillColorWithColor(context, RGBCOLOR(0xF9, 0xF9, 0xF9).CGColor);
        CGContextFillRect(context, self.skuBgRect);
        CGContextStrokeRect(context, self.skuBgRect);
    }
}

//点击LWTextStorage
- (void) lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
     didCilickedTextStorage:(LWTextStorage *)textStorage
                   linkdata:(id)data
{
    if ([data isKindOfClass:[ProductSKU class]]) {
        ProductSKU *sku = data;
        BOOL checked = sku.isChecked;
        if (!checked) {
            if (self.skuStorage) {
                self.skuStorage.textBackgroundColor = COLOR_BG_TEXT;
                self.skuStorage.textColor = COLOR_TEXT_LINK;
            }
            if (self.sku) {
                self.sku.isChecked = NO;
            }
            textStorage.textBackgroundColor = COLOR_SELECTED;
            textStorage.textColor = WHITE_COLOR;
//            [self enabledBuyButton:YES];
            //
            self.skuStorage = textStorage;
            self.sku = sku;
        }
        else {
            textStorage.textBackgroundColor = COLOR_BG_TEXT;
            textStorage.textColor = COLOR_TEXT_LINK;
            //
            self.skuStorage = nil;
            self.sku = nil;
        }
        
        sku.isChecked = !checked;
        
        [self updateButton];
        
//        [self requestGetSKU:self.product];
    }
}

@end
