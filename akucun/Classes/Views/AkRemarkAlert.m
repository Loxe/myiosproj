//
//  AkRemarkAlert.m
//  akucun
//
//  Created by Jarry on 2017/8/23.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AkRemarkAlert.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"

@interface AkRemarkAlert ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIView      *buttonView;

@property (nonatomic, strong) NSArray     *actionItems;

@property (nonatomic, copy) MMPopupInputHandler inputHandler;

@end

@implementation AkRemarkAlert

- (instancetype) initWithInputTitle:(NSString*)title
                             detail:(NSString*)detail
                            content:(NSString*)content
                        placeholder:(NSString*)inputPlaceholder
                            handler:(MMPopupInputHandler)inputHandler
{
    NSArray *items =@[
                      MMItemMake(@"不下单", MMItemTypeNormal, nil),
                      MMItemMake(@"下单", MMItemTypeHighlight, nil)
                      ];
    return [self initWithTitle:title detail:detail content:content items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler];
}

- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                      content:(NSString*)content
                        items:(NSArray *)items
             inputPlaceholder:(NSString *)inputPlaceholder
                 inputHandler:(MMPopupInputHandler)inputHandler
{
    self = [super init];
    
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
        
        self.type = MMPopupTypeAlert;
        self.withKeyboard = (inputHandler!=nil);
        
        self.inputHandler = inputHandler;
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = MM_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(config.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:config.titleFontSize];
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        if ( self.inputHandler )
        {
            self.inputView = [UITextField new];
            [self addSubview:self.inputView];
            [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(20);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(40);
            }];
            self.inputView.backgroundColor = self.backgroundColor;
            self.inputView.layer.borderWidth = MM_SPLIT_WIDTH;
            self.inputView.layer.borderColor = LIGHTGRAY_COLOR.CGColor;
            self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            self.inputView.leftViewMode = UITextFieldViewModeAlways;
            self.inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.inputView.placeholder = inputPlaceholder;
            self.inputView.font = [FontUtils normalFont];
//            self.inputView.keyboardType = keyboardType;
            
            lastAttribute = self.inputView.mas_bottom;
        }
        
        if ( detail.length > 0 )
        {
            self.detailLabel = [UILabel new];
            [self addSubview:self.detailLabel];
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(15);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            }];
            self.detailLabel.textColor = LIGHTGRAY_COLOR;
            self.detailLabel.textAlignment = NSTextAlignmentLeft;
            self.detailLabel.font = [FontUtils smallFont];
            self.detailLabel.numberOfLines = 0;
            self.detailLabel.backgroundColor = self.backgroundColor;
            self.detailLabel.text = detail;
            
            lastAttribute = self.detailLabel.mas_bottom;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(20);
            make.left.right.equalTo(self);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i )
        {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if ( items.count <= 2 )
                {
                    make.top.bottom.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton )
                    {
                        firstButton = btn;
                        make.left.equalTo(self.buttonView.mas_left).offset(-MM_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.left.equalTo(lastButton.mas_right).offset(-MM_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                }
                else
                {
                    make.left.right.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton )
                    {
                        firstButton = btn;
                        make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                    }
                    else
                    {
                        make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.titleLabel.font = (item==items.lastObject)?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if ( items.count <= 2 )
            {
                make.right.equalTo(self.buttonView.mas_right).offset(MM_SPLIT_WIDTH);
            }
            else
            {
                make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
            }
            
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.buttonView.mas_bottom);
            
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled )
    {
        return;
    }
    
    [self hide];
    
    if ( self.inputHandler && (btn.tag>0) )
    {
        self.inputHandler(self.inputView.text);
    }
    else
    {
        if ( item.handler )
        {
            item.handler(btn.tag);
        }
    }
}

- (void)notifyTextChange:(NSNotification *)n
{
    if ( n.object != self.inputView )
    {
        return;
    }
/*
    UITextField *textField = self.inputView;
    
    NSString *toBeString = textField.text;
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxInputLength) {
            textField.text = [toBeString mm_truncateByCharLength:self.maxInputLength];
        }
    }
 */
}

- (void)showKeyboard
{
    [self.inputView becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.inputView resignFirstResponder];
}

@end
