//
//  OptionsPickerView.m
//  J1ST-Installer
//
//  Created by Jarry on 17/4/13.
//  Copyright © 2017年 Zenin-tech. All rights reserved.
//

#import "OptionsPickerView.h"
#import "TextButton.h"

#define kOptionsTopHeight       (44.0f)
#define kOptionsTabHeight       (30.0f)
#define kOptionsButtonHeight    (kTableCellHeight + 10)

#define kOptionsHeightMax  (kOptionsTopHeight + kOptionsTabHeight + kTableCellHeight * 5 + kOptionsButtonHeight)

@interface OptionTableCell : UITableViewCell

@property (nonatomic, strong) OptionItem *item;

@end

@interface OptionsPickerView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *topTabView;

@property (nonatomic, strong) NSMutableArray * topTabItems;

@property (nonatomic, strong) NSMutableArray * tableViews;

@property (nonatomic, weak) UIView * underLine;
@property (nonatomic, weak) UIScrollView * contentView;

@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *otherButton;

@property (nonatomic, strong) UIButton *handerView;

@property (nonatomic, strong) NSMutableArray *optionTitles;

@end

@implementation OptionsPickerView

+ (void) showWithTitle:(NSString *)title
                option:(NSArray *)option
              selected:(NSString *)item
              competed:(idBlock)completeBolck
{
    OptionsPickerView *pickerView = [[OptionsPickerView alloc] init];
    pickerView.title = title;
    pickerView.seletedItems = [NSMutableArray arrayWithObject:item];
    pickerView.optionsArray = @[ @{ @"title" : option } ];
    
    [pickerView showWithComplete:completeBolck];
}

+ (void) showWithTitle:(NSString *)title
               options:(NSArray *)options
              selected:(NSArray *)items
              competed:(idBlock)completeBolck
{
    OptionsPickerView *pickerView = [[OptionsPickerView alloc] init];
    pickerView.title = title;
    pickerView.seletedItems = [NSMutableArray arrayWithArray:items];
    pickerView.optionsArray = options;
    
    [pickerView showWithComplete:completeBolck];
}

+ (void) dismissAll
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *handleView = [window viewWithTag:100];
    if (handleView) {
        [handleView removeFromSuperview];
        handleView = nil;
    }
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = LIGHTGRAY_COLOR;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kOptionsHeightMax);
    
    self.okTitle = @"确 定";
    
    [self setupViews];
    
    return self;
}

- (void) setupViews
{
    UIView * separateLine = [self separateLine];
    [self addSubview: separateLine];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, kOptionsTopHeight)];
    topView.backgroundColor = WHITE_COLOR;
    [topView addSubview:self.titleLabel];
    separateLine = [self separateLine];
    separateLine.top = topView.height - separateLine.height;
    [topView addSubview:separateLine];
    [self addSubview:topView];
    
    self.topTabView.top = topView.bottom;
    [self addSubview:self.topTabView];

    UIScrollView * contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topTabView.top-1, self.width, self.height - kOptionsTopHeight - kOptionsTabHeight)];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.backgroundColor = WHITE_COLOR;
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    [self addSubview:contentView];
    
    _contentView = contentView;
    
    [self addSubview:self.okButton];
    
    _optionTitles = [NSMutableArray array];
    _topTabItems = [NSMutableArray array];
    _tableViews = [NSMutableArray array];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void) setOkTitle:(NSString *)okTitle
{
    _okTitle = okTitle;
    
    [self.okButton setNormalTitle:okTitle];
}

- (void) setOptionsArray:(NSArray *)optionsArray
{
    if (!optionsArray) {
        return;
    }
    
    NSInteger count = optionsArray.count;
    
    if (!_seletedItems) {
        _seletedItems = [NSMutableArray arrayWithCapacity:count];
    }
    
    NSInteger maxCount = 0;
    NSMutableArray *options = [NSMutableArray array];
    NSInteger index = 0;
    for (NSDictionary *optionDic in optionsArray) {
        
        NSArray *array = nil;
        for (NSString *key in optionDic) {
            array = optionDic[key];
            [self.optionTitles addObject:key];
        }
        
        maxCount = MAX(maxCount, array.count);
        NSString *selectItem = nil;
        if (index < self.seletedItems.count) {
            selectItem = [self.seletedItems objectAtIndex:index];
        }
        else {
            [self.seletedItems addObject:@""];
        }
        NSMutableArray *items = [NSMutableArray array];
        
        for (int i = 0; i < array.count; i++) {
            NSString *text = array[i];
            OptionItem *item = [OptionItem new];
            item.text = text;
            item.isSelected = (selectItem && [item.text isEqualToString:selectItem]);
            [items addObject:item];
        }
        [options addObject:items];
        index ++;
    }
    _optionsArray = options;
    
    CGFloat buttonsHeight = kOptionsButtonHeight;
    if (self.otherTitle) {
        buttonsHeight = kOptionsButtonHeight + kTableCellHeight;
    }
    self.contentView.height = (maxCount > 5) ? (kTableCellHeight * 5) : kTableCellHeight * maxCount;
    if (count > 1) {
        self.contentView.top = self.topTabView.bottom - 1 / [UIScreen mainScreen].scale;
        self.height = self.contentView.height + kOptionsTopHeight + kOptionsTabHeight + buttonsHeight;
        self.topTabView.hidden = NO;
    }
    else {
        self.contentView.top = kOptionsTopHeight;
        self.height = self.contentView.height + kOptionsTopHeight + buttonsHeight;
        self.topTabView.hidden = YES;
    }
    
    self.okButton.bottom = self.height;
    self.okButton.enabled = ([self checkSelected] < 0);
    if (self.otherTitle) {
        self.otherButton.bottom = self.okButton.top;
        [self addSubview:self.otherButton];
    }
    
    CGFloat btnX = kOFFSET_SIZE*2;
    for (int i = 0; i < count; i ++) {
        //
        UITableView *tableView = [self tableViewWithIndex:i];
        NSIndexPath *indexPath = [self selectedOptionIndexAt:i];
        if (indexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
        [self.tableViews addObject:tableView];
        [self.contentView addSubview:tableView];
        //
        UIButton *button = [self tabButtonWithTitle:self.optionTitles[i] index:i];
        button.left = btnX;
        [self.topTabView insertSubview:button atIndex:0];
        btnX += button.width + kOFFSET_SIZE*2;
        [self.topTabItems addObject:button];
    }
    
    [self.topTabView bringSubviewToFront:self.underLine];
    
    self.contentView.contentSize = CGSizeMake(SCREEN_WIDTH * count, 0);
}

#pragma mark - Public

- (void) showWithComplete:(idBlock)completeBolck
{
    self.completeBolck = completeBolck;
    [self show];
}

- (void) show
{
    [OptionsPickerView dismissAll];
    
    if (!_handerView) {
        _handerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handerView setFrame:[UIScreen mainScreen].bounds];
        [_handerView setBackgroundColor:[BLACK_COLOR colorWithAlphaComponent:0.2f]];
        [_handerView addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_handerView addSubview:self];
        _handerView.tag = 100;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    [self selectButtonIndex:0];
    
    _handerView.alpha = 0.f;
    CGPoint center = self.center;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         _handerView.alpha = 1.f;
         self.center = CGPointMake(center.x, SCREEN_HEIGHT-self.height/2);
     }
                     completion:^(BOOL finished)
     {
         

     }];
}

- (void) dismiss
{
    CGPoint center = self.center;
    [UIView animateWithDuration:0.3f animations:^{
        self.center = CGPointMake(center.x, SCREEN_HEIGHT+self.height/2);
        _handerView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        _handerView = nil;
    }];
}

#pragma mark - Actions

- (void) cancelAction
{
    [self dismiss];
}

- (void) completeAction
{
//    NSInteger unselected = [self checkSelected];
//    if (unselected >= 0) {
//        NSString *title = self.optionTitles[unselected];
//        [SVProgressHUD showInfoWithStatus:FORMAT(@"请选择参数 [ %@ ]", title)];
//        return;
//    }
    
    [self dismiss];

    if (self.completeBolck) {
        if (self.optionsArray.count == 1) {
            self.completeBolck(self.seletedItems[0]);
            return;
        }
        self.completeBolck(self.seletedItems);
    }
}

- (void) otherAction
{
    [self dismiss];

}

- (NSInteger) checkSelected
{
    NSInteger index = -1;
    for (int i = 0; i < self.seletedItems.count; i++) {
        NSString *item = self.seletedItems[i];
        if (item.length == 0) {
            return i;
        }
    }
    return index;
}

- (IBAction) tabAction:(id)sender
{
    UIButton *button = sender;
    
    [self selectButtonIndex:button.tag];
}

- (void) selectButtonIndex:(NSInteger)index
{
    if (self.topTabView.hidden || self.topTabItems.count == 0) {
        return;
    }
    
    UIButton *button = self.topTabItems[index];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.underLine.left = button.left;
        self.underLine.width = button.width;
        
        self.contentView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
    } completion:^(BOOL finished) {
        UITableView *tableView = self.tableViews[index];
        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
}

- (NSIndexPath *) selectedOptionIndexAt:(NSInteger)index
{
    NSArray *options = self.optionsArray[index];
    NSInteger i = 0;
    for (OptionItem *item in options) {
        if (item.isSelected) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
        i ++;
    }
    return nil;
}

#pragma mark - TableViewDatasouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tag = tableView.tag;
    NSArray *options = self.optionsArray[tag];
    return options ? options.count : 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionTableCell * cell = [[OptionTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *options = self.optionsArray[tableView.tag];
    OptionItem *item = options[indexPath.row];
    cell.item = item;

    if (item.isSelected) {
        UIButton *button = self.topTabItems[tableView.tag];
        [button setNormalColor:COLOR_TEXT_DARK];
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *options = self.optionsArray[tableView.tag];
    OptionItem *item = options[indexPath.row];
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self.seletedItems replaceObjectAtIndex:tableView.tag withObject:item.text];
    self.okButton.enabled = ([self checkSelected] < 0);

    //
    NSInteger count = self.optionsArray.count;
    NSInteger index = tableView.tag;
    if (count > 0 && index < count-1) {
        [self selectButtonIndex:(index+1)];
    }
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *options = self.optionsArray[tableView.tag];
    OptionItem *item = options[indexPath.row];
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - getter

- (UILabel *) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, kOptionsTopHeight)];
        _titleLabel.font = SYSTEMFONT(16);
        _titleLabel.textColor = COLOR_TEXT_NORMAL;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请选择";
    }
    return _titleLabel;
}

- (UIView *) topTabView
{
    if (!_topTabView) {
        _topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kOptionsTabHeight)];
        _topTabView.backgroundColor = WHITE_COLOR;
        
        UIView * separateLine = [self separateLine];
        separateLine.top = _topTabView.height - separateLine.height;
        [_topTabView addSubview:separateLine];
        
        UIView * underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 2)];
        underLine.backgroundColor = COLOR_APP_RED;
        underLine.top = _topTabView.height - underLine.height;
        [_topTabView addSubview:underLine];
        _underLine = underLine;
    }
    return _topTabView;
}

//分割线
- (UIView *) separateLine
{
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = COLOR_SEPERATOR_LINE;
    return separateLine;
}

- (UITableView *) tableViewWithIndex:(NSInteger)index
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(index * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.contentView.height)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.contentInset = UIEdgeInsetsMake(0, 0, kOptionsTopHeight, 0);
    tableView.rowHeight = kTableCellHeight;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.alwaysBounceVertical = NO;
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.tag = index;

    return tableView;
}

- (UIButton *) tabButtonWithTitle:(NSString *)title index:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = WHITE_COLOR;
    button.frame = CGRectMake(0, 0, 60, kOptionsTabHeight);
    button.titleLabel.font = SYSTEMFONT(15);
    [button setNormalColor:COLOR_TEXT_LIGHT highlighted:COLOR_APP_RED selected:nil];
    [button setNormalTitle:title];
    [button sizeToFit];

    button.tag = index;
    [button addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (UIButton *) okButton
{
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.backgroundColor = WHITE_COLOR;
        _okButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTableCellHeight);
        _okButton.titleLabel.font = SYSTEMFONT(16);
        [_okButton setNormalColor:COLOR_APP_BLUE highlighted:COLOR_APP_RED selected:nil];
        [_okButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        [_okButton setNormalTitle:self.okTitle];
        
        [_okButton addSubview:[self separateLine]];
        
        [_okButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIButton *) otherButton
{
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherButton.backgroundColor = WHITE_COLOR;
        _otherButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTableCellHeight);
        _otherButton.titleLabel.font = SYSTEMFONT(16);
        [_otherButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_APP_RED selected:nil];
        [_otherButton setNormalTitleColor:nil disableColor:COLOR_TEXT_LIGHT];
        [_otherButton setNormalTitle:self.otherTitle];
        
        [_otherButton addSubview:[self separateLine]];
        
        [_otherButton addTarget:self action:@selector(otherAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}

//- (NSMutableArray *)tableViews{
//    
//    if (_tableViews == nil) {
//        _tableViews = [NSMutableArray array];
//    }
//    return _tableViews;
//}
@end

@implementation OptionItem

@end

@implementation OptionTableCell

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
    self.textLabel.font = SYSTEMFONT(15);
    
    self.detailTextLabel.backgroundColor = CLEAR_COLOR;
    self.detailTextLabel.textColor = COLOR_APP_RED;
    self.detailTextLabel.font = FA_ICONFONTSIZE(16);
    
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1 / [UIScreen mainScreen].scale)];
    seperatorLine.bottom = kTableCellHeight;
    seperatorLine.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    [self.contentView addSubview:seperatorLine];
    
    return self;
}

- (void) setItem:(OptionItem *)item
{
    _item = item;
    
    self.textLabel.text = item.text;
    self.textLabel.textColor = item.isSelected ? COLOR_APP_RED : COLOR_TEXT_DARK;
    self.detailTextLabel.text = item.isSelected ? FA_ICONFONT_CHECKED : @"";
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundColor = highlighted ? RGBCOLOR(0xF0, 0xF0, 0xF0) : WHITE_COLOR;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.left = kOFFSET_SIZE*2;
    self.detailTextLabel.right = SCREEN_WIDTH-kOFFSET_SIZE*2;
}

@end
