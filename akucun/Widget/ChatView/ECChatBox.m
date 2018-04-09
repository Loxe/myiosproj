//
//  ECChatBox.m
//  akucun
//
//  Created by Jarry on 2017/9/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECChatBox.h"

@interface ECChatBox () <UITextViewDelegate>

/** 顶部边线 */
@property (nonatomic, strong) UIView *topLine;
/** 左边 键盘按钮 */
@property (nonatomic, strong) UIButton *leftButton;
/** 右边 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** 输入框 */
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ECChatBox

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:RGBCOLOR(0xF0, 0xF0, 0xF0)];
        [self addSubview:self.topLine];
        [self addSubview:self.leftButton];
        [self addSubview:self.textView];
        [self addSubview:self.sendButton];
//        [self addSubview:self.moreButton];
//        [self addSubview:self.talkButton];
        self.status = ECChatBoxStatusNothing; // 起始状态
        [self addNotification];
    }
    return self;
}

// 监听通知
- (void) addNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:GXEmotionDidSelectNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:GXEmotionDidDeleteNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:GXEmotionDidSendNotification object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - Actions

//
- (void) leftButtonAction:(UIButton *)sender
{
    /*
    ECChatBoxStatus lastStatus = self.status;
    if (lastStatus == ICChatBoxStatusShowVoice) {//正在显示talkButton，改为键盘状态
        self.status = ICChatBoxStatusShowKeyboard;
        [self.talkButton setHidden:YES];
        [self.textView setHidden:NO];
        [self.textView becomeFirstResponder];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    } else {    // 变成talkButton的状态
        self.status = ICChatBoxStatusShowVoice;
        [self.textView resignFirstResponder];
        [self.textView setHidden:YES];
        [self.talkButton setHidden:NO];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
    }*/
    
//    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
//        [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
//    }
}

- (void) sendAction:(UIButton *)sender
{
    if (self.textView.text.length == 0) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
        [_delegate chatBox:self sendTextMessage:self.textView.text];
    }
    [self.textView setText:@""];
    self.sendButton.imageView.tintColor = COLOR_TEXT_LIGHT;
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    self.status = ECChatBoxStatusShowKeyboard;
}

- (void) textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 100) { // 限制5000字内
        textView.text = [textView.text substringToIndex:100];
    }
    
    if (textView.text.length > 0) {
        self.sendButton.imageView.tintColor = COLOR_SELECTED;
    }
    else {
        self.sendButton.imageView.tintColor = COLOR_TEXT_LIGHT;
    }
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        if (self.textView.text.length > 0) {     // send Text
            if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
                [_delegate chatBox:self sendTextMessage:self.textView.text];
            }
            [self.textView setText:@""];
            self.sendButton.imageView.tintColor = COLOR_TEXT_LIGHT;
        }
        return NO;
    }
    return YES;
}

#pragma mark - Getter and Setter

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kPIXEL_WIDTH)];
        [_topLine setBackgroundColor:COLOR_TEXT_LIGHT];
    }
    return _topLine;
}

- (UIButton *) leftButton
{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CHAT_BAR_HEIGHT, CHAT_BAR_HEIGHT)];
        
        UIImage *image = [IMAGENAMED(@"chat_icon_keyboard") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_leftButton setImage:image forState:UIControlStateNormal];
        _leftButton.imageView.tintColor = COLOR_TEXT_NORMAL;

        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UITextView *) textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(CHAT_BAR_HEIGHT, 6, self.width-CHAT_BAR_HEIGHT*2, CHAT_TEXTVIEW_HEIGHT)];
        [_textView setFont:[FontUtils normalFont]];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4.0f];
        [_textView.layer setBorderWidth:kPIXEL_WIDTH];
        [_textView.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setDelegate:self];
    }
    return _textView;
}

- (UIButton *) sendButton
{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - CHAT_BAR_HEIGHT, 0, CHAT_BAR_HEIGHT, CHAT_BAR_HEIGHT)];
        
        UIImage *image = [IMAGENAMED(@"chat_icon_send") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_sendButton setImage:image forState:UIControlStateNormal];
        _sendButton.imageView.tintColor = COLOR_TEXT_LIGHT;
        
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
