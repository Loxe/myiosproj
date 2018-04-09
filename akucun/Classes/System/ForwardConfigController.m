//
//  ForwardConfigController.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ForwardConfigController.h"
#import "TableCellBase.h"
#import "UserManager.h"
#import "OptionsPopupView.h"
#import "MMAlertView.h"

@interface ForwardConfigController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger imageOption;
@property (nonatomic, assign) NSInteger skuOption;
@property (nonatomic, assign) NSInteger priceOption;

@end

@implementation ForwardConfigController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    
    self.title = @"转发配置选项";
    
    [self.view addSubview:self.tableView];
    
    //
    UserConfig *userConfig = [UserManager instance].userConfig;
    self.imageOption = userConfig.imageOption;
    self.skuOption = userConfig.skuOption;
    self.priceOption = userConfig.priceOption;
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
    return 1;
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
    return kOFFSET_SIZE * 1.5 + 20;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE * 1.5 + 20)];
    footer.backgroundColor = CLEAR_COLOR;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, SCREEN_WIDTH, 0.5f)];
    line.backgroundColor = COLOR_SEPERATOR_LINE;
    [footer addSubview:line];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.left = kOFFSET_SIZE;
    tipLabel.top = kOFFSET_SIZE*0.5;
    tipLabel.font = [FontUtils smallFont];
    tipLabel.textColor = COLOR_TEXT_NORMAL;
    [footer addSubview:tipLabel];

    if (section == 0) {
        tipLabel.text = [UserConfig imageOptionDesp:self.imageOption];
        [tipLabel sizeToFit];
    }
    else if (section == 1) {
        tipLabel.text = [UserConfig skuOptionDesp:self.skuOption];
        [tipLabel sizeToFit];
    }
    else if (section == 2) {
        tipLabel.text = [UserConfig priceOptionDesp:self.priceOption];
        [tipLabel sizeToFit];
    }
    return footer;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCellBase *cell = [[TableCellBase alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.showSeperator = NO;
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = COLOR_SELECTED;
        cell.textLabel.text = @"转发图片默认选项";
        cell.detailTextLabel.text = [UserConfig imageOptionText:self.imageOption];
    }
    else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"是否转发缺货尺码";
        cell.detailTextLabel.text = [UserConfig skuOptionText:self.skuOption];
        cell.detailTextLabel.textColor = COLOR_SELECTED;
        if (self.skuOption < 0) {
            cell.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
        }
    }
    else if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"转发商品加价";
        cell.detailTextLabel.text = [UserConfig priceOptionText:self.priceOption];
        cell.detailTextLabel.textColor = COLOR_SELECTED;
        if (self.priceOption == 0) {
            cell.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @weakify(self)
    if (indexPath.section == 0) {
        NSArray *options = [UserConfig imageOptions];
        OptionsPopupView *optionsView = [[OptionsPopupView alloc] initWithTitle:@"转发图片选项" options:options selected:[UserConfig imageOptionIndex:self.imageOption]];
        optionsView.offset = kOFFSET_SIZE;
        optionsView.completeBolck = ^(int index, id content) {
            @strongify(self)
            //
            self.imageOption = index+1;
            if (index == 0) {
                self.imageOption = ShareOptionOnlyPictures;
            }
            else if (index == 1) {
                self.imageOption = ShareOptionMergedPicture;
            }
            else if (index == 2) {
                self.imageOption = ShareOptionPicturesAndText;
            }
            
            UserConfig *userConfig = [UserManager instance].userConfig;
            userConfig.imageOption = self.imageOption;
            [UserManager instance].userConfig = userConfig;
            
            [self.tableView reloadData];
        };
        [optionsView show];
    }
    else if (indexPath.section == 1) {
        NSArray *options = [UserConfig skuOptions];
        OptionsPopupView *optionsView = [[OptionsPopupView alloc] initWithTitle:@"是否转发缺货尺码 ？" options:options selected:(self.skuOption+1)];
        optionsView.completeBolck = ^(int index, id content) {
            @strongify(self)
            //
            self.skuOption = index-1;
            
            UserConfig *userConfig = [UserManager instance].userConfig;
            userConfig.skuOption = self.skuOption;
            [UserManager instance].userConfig = userConfig;
            
            [self.tableView reloadData];
        };
        [optionsView show];
    }
    else if (indexPath.section == 2) {
        NSArray *options = [UserConfig priceOptions];
        OptionsPopupView *optionsView = [[OptionsPopupView alloc] initWithTitle:@"转发商品是否加价 ？" options:options selected:-1];
        optionsView.completeBolck = ^(int index, id content) {
            @strongify(self)
            //
            if (index > 2) {
                MMAlertView *alertView =
                [[MMAlertView alloc] initWithInputTitle:@"自定义加价金额"
                                                 detail:@""
                                            placeholder:@"请输入加价金额(元)"
                                               keyboard:UIKeyboardTypeNumberPad
                                                handler:^(NSString *text)
                 {
                     self.priceOption = [text integerValue];
                     UserConfig *userConfig = [UserManager instance].userConfig;
                     userConfig.priceOption = self.priceOption;
                     [UserManager instance].userConfig = userConfig;
                     [self.tableView reloadData];
                 }];
                [alertView show];
                return;
            }
            else if (index == 0) {
                self.priceOption = 0;
            }
            else if (index == 1) {
                self.priceOption = 5;
            }
            else if (index == 2) {
                self.priceOption = 10;
            }
            UserConfig *userConfig = [UserManager instance].userConfig;
            userConfig.priceOption = self.priceOption;
            [UserManager instance].userConfig = userConfig;
            [self.tableView reloadData];
        };
        [optionsView show];
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
        _tableView.rowHeight = isPad ? kPadCellHeight : kTableCellHeight;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOFFSET_SIZE)];
        footer.backgroundColor = CLEAR_COLOR;
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

@end
