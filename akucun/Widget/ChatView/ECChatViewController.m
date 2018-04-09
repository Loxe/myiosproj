//
//  ECChatViewController.m
//  akucun
//
//  Created by Jarry on 2017/9/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ECChatViewController.h"

@interface ECChatViewController () <ECChatBoxDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;

@end

@implementation ECChatViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.chatBox];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 

- (void) keyboardWillHide:(NSNotification *)notification
{
    self.keyboardFrame = CGRectZero;
    self.chatBox.status = ECChatBoxStatusNothing;
    
//    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
//        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
//    }
}

- (void) keyboardFrameWillChange:(NSNotification *)notification
{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_chatBox.status == ECChatBoxStatusShowKeyboard && self.keyboardFrame.size.height <= CHAT_TEXTVIEW_HEIGHT) {
        return;
    }
//    else if ((_chatBox.status == ICChatBoxStatusShowFace || _chatBox.status == ICChatBoxStatusShowMore) && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
//        return;
//    }
    
    self.chatBox.status = ECChatBoxStatusShowKeyboard; // 状态改变
    if (_delegate && [_delegate respondsToSelector:@selector(chatViewController:didChangeHeight:)]) {
        [_delegate chatViewController:self didChangeHeight:self.keyboardFrame.size.height + CHAT_BAR_HEIGHT];
    }
}

- (BOOL) resignFirstResponder
{
    if (self.chatBox.status != ECChatBoxStatusNothing) {
        [self.chatBox resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(chatViewController:didChangeHeight:)]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_delegate chatViewController:self didChangeHeight:CHAT_BAR_HEIGHT+kSafeAreaBottomHeight];
            } completion:^(BOOL finished) {
                // 状态改变
                self.chatBox.status = ECChatBoxStatusNothing;
            }];
        }
    }
    return [super resignFirstResponder];
}

#pragma mark - ECChatBoxDelegate

- (void) chatBox:(ECChatBox *)chatBox sendTextMessage:(NSString *)textMessage
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatViewController:sendTextMessage:)]) {
        [_delegate chatViewController:self sendTextMessage:textMessage];
    }
    [self resignFirstResponder];
}

- (void) chatBox:(ECChatBox *)chatBox changeHeight:(CGFloat)height
{
//    self.chatBoxFaceView.y = height;
//    self.chatBoxMoreView.y = height;
    if (_delegate && [_delegate respondsToSelector:@selector(chatViewController:didChangeHeight:)]) {
//        float h = (self.chatBox.status == ECChatBoxStatusShowFace ? HEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height ) + height;
        float h = self.keyboardFrame.size.height + height;
        [_delegate chatViewController:self didChangeHeight:h];
    }
}

#pragma mark - Getter and Setter

- (ECChatBox *) chatBox
{
    if (_chatBox == nil) {
        _chatBox = [[ECChatBox alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CHAT_BAR_HEIGHT+kSafeAreaBottomHeight)];
        _chatBox.delegate = self;
    }
    return _chatBox;
}

@end
