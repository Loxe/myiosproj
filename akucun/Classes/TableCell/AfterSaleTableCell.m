//
//  AfterSaleTableCell.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AfterSaleTableCell.h"
#import "TopNumButton.h"
#import "TextButton.h"

@interface AfterSaleTableCell ()

@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) TextButton *detailButton;

@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation AfterSaleTableCell

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
    self.textLabel.font = [FontUtils normalFont];
    
    self.textLabel.text = @"退款/售后";

    CGSize size = [@"我的订单" boundingRectWithSize:CGSizeMake(320, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[FontUtils normalFont]} context:nil].size;
    self.headerHeight = size.height + kOFFSET_SIZE*0.6f + 4;

    _iconLabel = [[UILabel alloc] init];
    _iconLabel.textColor = LIGHTGRAY_COLOR;
    _iconLabel.font = FA_ICONFONTSIZE(22);
    _iconLabel.text = FA_ICONFONT_RIGHT;
    [_iconLabel sizeToFit];
    [self.contentView addSubview:_iconLabel];
    [self.contentView addSubview:self.detailButton];
    
    TopNumButton *button1 = [self buttonWithTitle:@"平台缺货" index:0];
    [self.contentView addSubview:button1];
    TopNumButton *button2 = [self buttonWithTitle:@"用户取消" index:1];
    [self.contentView addSubview:button2];
    TopNumButton *button3 = [self buttonWithTitle:@"退货中" index:2];
    [self.contentView addSubview:button3];
    TopNumButton *button4 = [self buttonWithTitle:@"已退货" index:3];
    [self.contentView addSubview:button4];
    TopNumButton *button5 = [self buttonWithTitle:@"售后申请" index:4];
    [self.contentView addSubview:button5];

    return self;
}

- (void) setOrderCount1:(NSInteger)count1
                 count2:(NSInteger)count2
                 count3:(NSInteger)count3
                 count4:(NSInteger)count4
                 count5:(NSInteger)count5
{
    TopNumButton *button1 = [self viewWithTag:1];
    [button1 setNumber:count1];
    TopNumButton *button2 = [self viewWithTag:2];
    [button2 setNumber:count2];
    TopNumButton *button3 = [self viewWithTag:3];
    [button3 setNumber:count3];
    TopNumButton *button4 = [self viewWithTag:4];
    [button4 setNumber:count4];
    TopNumButton *button5 = [self viewWithTag:5];
    [button5 setNumber:count5];
}

- (void) buttonAction:(UIButton *)btn
{
    int type = (int) btn.tag;
    if (type == 5) {
        type = ASaleTypeList+1;
    }
    
    if (self.selectBlock) {
        self.selectBlock(type);
    }
}

- (void) detailAction:(UIButton *)btn
{
    if (self.selectBlock) {
        self.selectBlock(ASaleTypeList+1);
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.top = (self.headerHeight-self.textLabel.height)/2.0f;
    self.textLabel.left = kOFFSET_SIZE;
    self.detailTextLabel.right = SCREEN_WIDTH-kOFFSET_SIZE*2;
    
    self.iconLabel.centerY = self.textLabel.centerY;
    self.iconLabel.right = SCREEN_WIDTH-(isPad ? kOFFSET_SIZE*1.3:kOFFSET_SIZE);
    
    self.detailButton.right = SCREEN_WIDTH-kOFFSET_SIZE*2;
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [COLOR_BG_HEADER set];
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, rect.size.width, self.headerHeight));
}

- (TopNumButton *) buttonWithTitle:(NSString *)title index:(NSInteger)index
{
    CGFloat width = (SCREEN_WIDTH)/5.0f;
    TopNumButton *iconButton = [[TopNumButton alloc] initWithFrame:CGRectMake(width * index, self.headerHeight + kOFFSET_SIZE, width, 60)];
//    iconButton.backgroundColor = RED_COLOR;
    
    [iconButton setTitle:title number:0];
    
    iconButton.tag = 1 + index;
    
    [iconButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return iconButton;
}

- (TextButton *) detailButton
{
    if (!_detailButton) {
        _detailButton = [TextButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = CGRectMake(0, 0, 100, self.headerHeight);
        
        [_detailButton setTitleFont:[FontUtils smallFont]];
        [_detailButton setTitleAlignment:NSTextAlignmentRight];
        
        [_detailButton setTitle:@"售后申请记录" forState:UIControlStateNormal];
        
        [_detailButton setNormalColor:COLOR_TEXT_NORMAL highlighted:COLOR_TEXT_DARK selected:nil];
        
        [_detailButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

@end
