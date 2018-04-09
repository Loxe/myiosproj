//
//  TipMessageView.m
//  akucun
//
//  Created by Jarry on 2017/7/1.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "TipMessageView.h"
#import "TextButton.h"

@interface TipMessageView ()

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation TipMessageView

- (instancetype) initWithFrame:(CGRect)frame message:(NSString *)message
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = COLOR_SELECTED;
    
    self.width = SCREEN_WIDTH;
    
    [self addSubview:self.messageLabel];
    [self addSubview:self.closeButton];
    
    [self setMessage:message];

    return self;
}

- (void) setMessage:(NSString *)message
{
    self.messageLabel.text = message;
    [self.messageLabel sizeToFit];
    
    [self updateLayout];
}

- (void) show
{
    self.alpha = 1.0f;
    [self updateLayout];
}

- (void) hide
{
    self.alpha = 0.0f;
    self.height = 0.0f;
}

- (IBAction) closeAction:(id)sender
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void) updateLayout
{
    self.messageLabel.top = kOFFSET_SIZE*0.5;
    self.messageLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
//    self.closeButton.top = self.messageLabel.top;
    self.closeButton.right = self.width;
    
    self.viewHeight = self.messageLabel.bottom + kOFFSET_SIZE*0.5;
    self.height = self.viewHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *) messageLabel
{
    if (!_messageLabel) {
        _messageLabel  = [[UILabel alloc] init];
        _messageLabel.backgroundColor = CLEAR_COLOR;
        _messageLabel.left = kOFFSET_SIZE;
        _messageLabel.width = SCREEN_WIDTH - kOFFSET_SIZE*2;
        _messageLabel.textColor = WHITE_COLOR;
        _messageLabel.font = [FontUtils smallFont];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *) closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, 35, 30);
        _closeButton.alpha = 0.8f;
        
        CGSize size =
        [@"注意" boundingRectWithSize:CGSizeMake(320, 30)
                           options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:[FontUtils smallFont]}
                           context:nil].size;
        _closeButton.height = size.height + kOFFSET_SIZE;
        
//        [_closeButton.titleLabel setFont:ICON_FONT(16)];
//        _closeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_closeButton setNormalTitle:kIconClose];
//        [_closeButton setNormalColor:WHITE_COLOR highlighted:COLOR_TEXT_LIGHT selected:nil];
        
//        _closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeButton setNormalImage:@"icon_close" hilighted:nil selectedImage:nil];
        
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
