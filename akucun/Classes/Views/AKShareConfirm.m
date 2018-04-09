//
//  AKShareConfirm.m
//  akucun
//
//  Created by Jarry on 2017/5/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKShareConfirm.h"
#import "IconButton.h"
#import "UserManager.h"
#import "ProductModel.h"

@interface AKShareConfirm ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UIView      *buttonView;

@property (nonatomic, strong) IconButton  *iconButton, *button1, *button2;

@property (nonatomic, strong) NSArray     *actionItems;

@end

@implementation AKShareConfirm

+ (void) showWithConfirmed:(shareBlock)confirmBlock model:(id)model showOption:(BOOL)showOption
{
    MMPopupItemHandler block = ^(NSInteger index) {
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"转发", MMItemTypeHighlight, block)];
    
    AKShareConfirm *alertView = [[AKShareConfirm alloc] initWithTitle:@"商品描述已复制" detail:@"1.  点击“转发”后若无微信和QQ选项，可在“更多”中打开\n2.  商品描述已复制 可以长按“粘贴”" model:model showOption:showOption items:items];
    alertView.confirmBlock = confirmBlock;
    [alertView show];
}

- (instancetype) initWithTitle:(NSString *)title
                        detail:(NSString *)detail
                         model:(id)model
                    showOption:(BOOL)showOption
                         items:(NSArray*)items
{
    self = [super init];
    
    if ( self )
    {
        MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
        
        self.type = MMPopupTypeAlert;
        
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = MM_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(315);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(kOFFSET_SIZE);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, kOFFSET_SIZE, 0, kOFFSET_SIZE));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = BOLDSYSTEMFONT(17);
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        if ( detail.length > 0 )
        {
            self.detailLabel = [UILabel new];
            [self addSubview:self.detailLabel];
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(20);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
            }];
            self.detailLabel.textColor = config.detailColor;
            self.detailLabel.textAlignment = NSTextAlignmentLeft;
            self.detailLabel.font = [FontUtils normalFont];
            self.detailLabel.numberOfLines = 0;
            self.detailLabel.backgroundColor = self.backgroundColor;
            self.detailLabel.text = detail;
            
            lastAttribute = self.detailLabel.mas_bottom;
        }
        
        UserConfig *userConfig = [UserManager instance].userConfig;
        CGFloat bOffset = 10.0f;
        if ([model isKindOfClass:[ProductModel class]] && showOption) {
            IconButton *button1 = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [button1 setTitleFont:SYSTEMFONT(14)];
            [button1 setTitle:@"朋友圈（四张图）" icon:FA_ICONFONT_UNCHECK1];
            [button1 setTextColor:RED_COLOR];
            [button1 setIconColor:RED_COLOR];
            [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button1];
            [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(bOffset);
                make.left.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
                make.width.equalTo(@(300));
                make.height.equalTo(@(30));
            }];
            lastAttribute = button1.mas_bottom;
            self.button1 = button1;
            
            BOOL checked = (userConfig.imageOption==ShareOptionOnlyPictures);
            [self setButton:self.button1 checked:checked];
            
            self.iconButton = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [self.iconButton setTitleFont:SYSTEMFONT(14)];
            [self.iconButton setTitle:@"微信群（合并一张图）" icon:FA_ICONFONT_UNCHECK1];
            [self.iconButton setTextColor:RED_COLOR];
            [self.iconButton setIconColor:RED_COLOR];
            [self.iconButton addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.iconButton];
            [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute);
                make.left.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
                make.width.equalTo(@(300));
                make.height.equalTo(@(30));
            }];
            lastAttribute = self.iconButton.mas_bottom;
            
            bOffset = 0.0f;
            BOOL checked1 = (userConfig.imageOption==ShareOptionMergedPicture);
            [self setButton:self.iconButton checked:checked1];
        }

        if (showOption) {
            IconButton *button2 = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [button2 setTitleFont:SYSTEMFONT(14)];
            [button2 setTitle:@"微信群（五张图）" icon:FA_ICONFONT_UNCHECK1];
            [button2 setTextColor:RED_COLOR];
            [button2 setIconColor:RED_COLOR];
            [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button2];
            [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(bOffset);
                make.left.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
                make.width.equalTo(@(300));
                make.height.equalTo(@(30));
            }];
            lastAttribute = button2.mas_bottom;
            self.button2 = button2;
            
            BOOL checked2 = (userConfig.imageOption==ShareOptionPicturesAndText);
            [self setButton:self.button2 checked:checked2];
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(config.innerMargin);
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
            btn.titleLabel.font = [FontUtils buttonFont];
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
        
        BOOL flag = NO;
        if ([model isKindOfClass:[ProductModel class]]) {
            ProductModel *product = (ProductModel*)model;
            if (product.skus && product.skus.count > 0) {
                flag = YES;
            }
        }
        if (flag && userConfig.priceOption > 0) {
            NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:FORMAT(@"转 发 (+%ld元)", (long)userConfig.priceOption)];
            NSDictionary * attributes = @{ NSFontAttributeName:BOLDSYSTEMFONT(12),NSForegroundColorAttributeName:RED_COLOR };
            [attributeStr setAttributes:attributes range:NSMakeRange(0, attributeStr.length)];
            [attributeStr setAttributes:@{ NSFontAttributeName:[FontUtils buttonFont],NSForegroundColorAttributeName:RED_COLOR } range:NSMakeRange(0, 3)];
            [lastButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
        }
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom);
        }];
    }
    
    return self;
}

- (void) iconButtonAction:(IconButton*)btn
{
    BOOL checked = btn.selected;
    if (checked) {
        return;
    }
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    if (!checked) {
        self.button1.selected = NO;
        [self.button1 setIcon:FA_ICONFONT_UNCHECK1];
        self.button2.selected = NO;
        [self.button2 setIcon:FA_ICONFONT_UNCHECK1];
    }
}

- (void) button1Action:(IconButton*)btn
{
    BOOL checked = btn.selected;
    if (checked) {
        return;
    }
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    if (!checked) {
        self.iconButton.selected = NO;
        [self.iconButton setIcon:FA_ICONFONT_UNCHECK1];
        self.button2.selected = NO;
        [self.button2 setIcon:FA_ICONFONT_UNCHECK1];
    }
}

- (void) button2Action:(IconButton*)btn
{
    BOOL checked = btn.selected;
    if (checked) {
        return;
    }
    btn.selected = !checked;
    [btn setIcon:checked ? FA_ICONFONT_UNCHECK1 : FA_ICONFONT_CHECKED1];
    if (!checked) {
        self.iconButton.selected = NO;
        [self.iconButton setIcon:FA_ICONFONT_UNCHECK1];
        self.button1.selected = NO;
        [self.button1 setIcon:FA_ICONFONT_UNCHECK1];
    }
}

- (void) setButton:(IconButton *)btn checked:(BOOL)checked
{
    btn.selected = checked;
    [btn setIcon:checked ? FA_ICONFONT_CHECKED1 : FA_ICONFONT_UNCHECK1];
}

- (void) actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled )
    {
        return;
    }
    
    [self hide];
    
    if ( item.handler )
    {
        if (btn.tag == 1) {
            self.confirmBlock(self.iconButton.selected, self.button2.selected);
        }
        item.handler(btn.tag);
    }
}

@end
