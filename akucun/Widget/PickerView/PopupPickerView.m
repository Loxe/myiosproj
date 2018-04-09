//
//  PopupPickerView.m
//  Power-IO
//
//  Created by Jarry on 16/8/25.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import "PopupPickerView.h"

@interface PopupPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation PopupPickerView

- (void)showWithConfirmBlock:(idBlock)block
{
    if (block) {
        self.confirmBlock = block;
    }
    
    [self showWithBlock:^(MMPopupView *view, BOOL finished) {
        if (self.dataArray.count == 0) {
            return;
        }
        NSArray *array = self.dataArray[0];
        NSInteger index = [array indexOfObject:self.selectedItem];
        if (index >= 0 && index < array.count) {
            [self.pickerView selectRow:index inComponent:0 animated:YES];
        }
    }];
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:COLOR_APP_RED forState:UIControlStateNormal];
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionConfirm)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:COLOR_APP_RED forState:UIControlStateNormal];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5f, SCREEN_WIDTH, 0.5f)];
        line.backgroundColor = MMHexColor(0xE0E0E0FF);
        [self addSubview:line];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    
    return self;
}

- (void)actionHide
{
    [self hide];
}

- (void)actionConfirm
{
    [self hide];

    if (self.confirmBlock) {
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        self.confirmBlock(self.dataArray[0][row]);
    }
}

- (void) setSelectedItem:(NSString *)selectedItem
{
    _selectedItem = selectedItem;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dataArray count];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.dataArray objectAtIndex:component] count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.dataArray objectAtIndex:component] objectAtIndex:row];
}

- (UIPickerView *) pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = WHITE_COLOR;
//        _pickerView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

@end
