//
//  TopBarView.m
//  akucun
//
//  Created by Jarry on 2017/6/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TopBarView.h"

@interface TopBarView ()

@property (nonatomic, weak) UIView *underLine;

@property (nonatomic, strong) NSMutableArray *buttonsArray;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIFont *font, *selectFont;

@end

@implementation TopBarView

- (instancetype) initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = WHITE_COLOR;
    
    _selectedIndex = -1;
    
    if (isIPhone6Plus || isPad) {
        self.font = SYSTEMFONT(15);
        self.selectFont = BOLDSYSTEMFONT(15);
    }
    else if (isIPhone5) {
        self.font = SYSTEMFONT(13);
        self.selectFont = BOLDSYSTEMFONT(13);
    }
    else {
        self.font = SYSTEMFONT(14);
        self.selectFont = BOLDSYSTEMFONT(14);
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.height - 1.0f, self.width, 1.0f)];
    lineView.backgroundColor = COLOR_SEPERATOR_LIGHT;
    [self addSubview:lineView];
    
    [self setupContent:titles];
    
    return self;
}

- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex < 0 || selectedIndex >= self.titles.count ) {
        return;
    }
    
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    if (_selectedIndex >= 0) {
        UIButton *lastBtn = self.buttonsArray[_selectedIndex];
        if (lastBtn) {
            lastBtn.selected = NO;
            lastBtn.titleLabel.font = self.font;
        }
    }
    
    _selectedIndex = selectedIndex;
    
    UIButton *button = self.buttonsArray[selectedIndex];
    button.selected = YES;
    
    NSString *title = self.titles[selectedIndex];
    CGSize size = [title boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.selectFont} context:nil].size;
    
    CGFloat width = self.width / self.titles.count;
    CGFloat left = width * selectedIndex + (width - size.width) / 2.0f - 2;
    [UIView animateWithDuration:0.2f animations:^{
        button.titleLabel.font = self.selectFont;
        self.underLine.alpha = 1.0f;
        self.underLine.left =  left;
        self.underLine.width = size.width;
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.selectBlock) {
        self.selectBlock((int)selectedIndex);
    }
}

- (void) setupContent:(NSArray *)titles
{
    self.titles = titles;

    self.buttonsArray = [NSMutableArray array];
    
    NSInteger count = titles.count;
    CGFloat width = self.width / count;
    for (int i = 0; i < count; i ++) {
        //
        UIButton *button = [self tabButtonWithTitle:titles[i] index:i];
        button.left = width * i;
        button.width = width-4;
        [self addSubview:button];
        [self.buttonsArray addObject:button];
    }

    UIView * underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 3)];
    underLine.backgroundColor = COLOR_SELECTED;
    underLine.top = self.height - underLine.height;
    underLine.alpha = 0.0f;
    [self addSubview:underLine];
    _underLine = underLine;
}

- (IBAction) tabAction:(id)sender
{
    UIButton *button = sender;
    self.selectedIndex = button.tag;
}

- (UIButton *) tabButtonWithTitle:(NSString *)title index:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = CLEAR_COLOR;
    CGFloat width = self.width / 5.0f;
    button.frame = CGRectMake(width * index, 0, width, self.height);
    
    button.titleLabel.font = self.font;
//    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_SELECTED selected:COLOR_SELECTED];
    [button setNormalTitle:title];
    
    button.tag = index;
    [button addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
