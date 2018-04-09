//
//  CommentView.m
//  akucun
//
//  Created by Jarry on 2017/4/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CommentView.h"
#import "IQKeyboardManager.h"

@interface CommentView () <UITextViewDelegate>

@property (nonatomic, assign) CGFloat editingBarOffsetY;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation CommentView

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews
{
    self.backgroundColor = COLOR_BG_HEADER;
    
    [self addSubview:self.editView];
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-8);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
    }];
    
    self.editingBarHeight = self.height;
    self.editingBarOffsetY = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:)    name:UITextViewTextDidChangeNotification object:nil];
}

- (void) show
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.alpha = 1.0f;
    [self.editView becomeFirstResponder];
}

- (void) hide
{
    [self.editView endEditing:YES];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    }];
}

#pragma mark - Actions

- (void) sendContent
{
    NSString *text = self.editView.text;
    self.editView.text = @"";
    [self.editView checkShouldHidePlaceholder];
    [self updateInputBarHeight];
    [self.editView resignFirstResponder];
    if (self.sendBlock) {
        self.sendBlock(self.object, text);
    }
}

#pragma mark -

- (void) updateLayout
{
//    CGFloat top = self.containerView.height-self.editingBarOffsetY-self.editingBarHeight;
//    if (self.top == top) {
//        return;
//    }
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.frame = CGRectMake(0, top, SCREEN_WIDTH, self.editingBarHeight);
//    }];
    if (self.alpha == 0 || self.hidden) {
        return;
    }

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-self.editingBarOffsetY);
        make.width.equalTo(self.containerView.mas_width);
        make.height.equalTo(@(self.editingBarHeight));
    }];
    //
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-8);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.containerView setNeedsUpdateConstraints];
    [UIView animateKeyframesWithDuration:0.25
                                   delay:0
                                 options:7 << 16
                              animations:^
     {
         [self.containerView layoutIfNeeded];
     } completion:nil];
}

- (CGFloat) minimumInputbarHeight
{
    return self.intrinsicContentSize.height;
}

- (CGFloat) deltaInputbarHeight
{
    return self.intrinsicContentSize.height - self.editView.font.lineHeight;
}

- (CGFloat) barHeightForLines:(NSUInteger)numberOfLines
{
    CGFloat height = [self deltaInputbarHeight];
    
    height += roundf(self.editView.font.lineHeight * numberOfLines);
    
    return height;
}

#pragma mark - 编辑框

- (void) textDidUpdate:(NSNotification *)notification
{
    [self updateInputBarHeight];
}

- (void) updateInputBarHeight
{
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != self.editingBarHeight) {
        self.editingBarHeight = inputbarHeight;
        [self updateLayout];
    }
}

- (CGFloat) appropriateInputbarHeight
{
    CGFloat height = 0;
    CGFloat minimumHeight = [self minimumInputbarHeight];
    CGFloat newSizeHeight = [self.editView measureHeight];
    CGFloat maxHeight     = self.editView.maxHeight;
    
    self.editView.scrollEnabled = (newSizeHeight >= maxHeight);
    
    if (newSizeHeight < minimumHeight) {
        height = minimumHeight;
    } else if (newSizeHeight < self.editView.maxHeight) {
        height = newSizeHeight;
    } else {
        height = self.editView.maxHeight;
    }
    
    return roundf(height);
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendContent];
    }
    return YES;
}

- (void) textViewDidChange:(PlaceholderTextView *)textView
{
    [textView checkShouldHidePlaceholder];
}

#pragma mark - Keyboard Notification

- (void) keyboardWillShow:(NSNotification *)notification
{
    if (![self.editView isFirstResponder]) {
        return;
    }
    
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.editingBarOffsetY = keyboardBounds.size.height - self.offsetHeight;
    
    [self updateLayout];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    if (![self.editView isFirstResponder]) {
        return;
    }
    self.editingBarOffsetY = - (self.offsetHeight + kEDIT_BAR_HEIGHT);
    
    [self updateLayout];
}

#pragma mark - Setter & Getter

- (void) setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    self.editView.placeholder = placeHolder;
}

- (GrowingTextView *) editView
{
    if (!_editView) {
        _editView = [[GrowingTextView alloc] initWithPlaceholder:@"说点什么"];
        _editView.placeholderFont = SYSTEMFONT(15);
//        _editView.maxNumberOfLines = 1;
        _editView.returnKeyType = UIReturnKeySend;
        _editView.backgroundColor = WHITE_COLOR;
        _editView.layer.masksToBounds = YES;
        _editView.layer.cornerRadius = 5.0;
        _editView.layer.borderWidth = 1.0f;
        _editView.layer.borderColor = RGBCOLOR(0xC8, 0xC8, 0xCD).CGColor;
        _editView.delegate = self;
    }
    return _editView;
}


@end
