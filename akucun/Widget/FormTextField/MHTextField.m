//
//  MHTextField.m
//
//  Created by Jarry on 4/11/13.
//  Copyright (c) 2013 Zenin-tech. All rights reserved.
//

#import "MHTextField.h"

#define kTimeFormatString   @"HH:mm"

@interface MHTextField() <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UITextField *_textField;
    BOOL _disabled;
}

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) BOOL hasScrollView;
@property (nonatomic) BOOL invalid;

@property (nonatomic, setter = setToolbarCommand:) BOOL isToolBarCommand;
@property (nonatomic, setter = setDoneCommand:) BOOL isDoneCommand;

@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property (nonatomic , strong) UIBarButtonItem *nextBarButton;
@property (nonatomic , strong) UIBarButtonItem *doneBarButton;

//@property (nonatomic, strong) NSMutableArray *textFields;

@end

@implementation MHTextField

@synthesize required;
@synthesize scrollView;
@synthesize toolbar;
@synthesize keyboardIsShown;
@synthesize keyboardSize;
@synthesize invalid;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        [self setup];
    }
    
    return self;
}

- (id) init
{
    self = [super init];
    
    if (self){
        [self setup];
    }
    
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void) setup
{
    if (isIOS7) {
        [self setTintColor:[UIColor blackColor]];
    }
    
    self.bgColor = WHITE_COLOR;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    if (!self.textFieldDelegate) {
        return;
    }
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
    // set style
    [toolbar setBarStyle:UIBarStyleDefault];
    
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"上一个" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonIsClicked:)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonIsClicked:)];
    
    toolbar.items = @[flexBarButton, self.doneBarButton];
    
//    self.textFields = [[NSMutableArray alloc]init];
//    
//    [self markTextFieldsWithTagInView:self.superview];
}

- (void) setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void) setDoneText:(NSString *)doneText
{
    _doneText = doneText;
    self.doneBarButton.title = doneText;
}

- (void) setNextText:(NSString *)nextText
{
    _nextText = nextText;
    self.nextBarButton.title = nextText;
}

- (void) setPrevText:(NSString *)prevText
{
    _prevText = prevText;
    self.previousBarButton.title = prevText;
}

- (void) setFieldTag:(NSInteger)index
{
    self.tag = MHTextField_TAG_BASE + index;
}

- (void) setSelectField:(BOOL)isSelectField
{
    _isSelectField = isSelectField;
}

- (void) setTextFieldDelegate:(id<MHTextFieldDelegate>)textFieldDelegate
{
    _textFieldDelegate = textFieldDelegate;
    
    if (self.textFieldDelegate && [self.textFieldDelegate numberOfTextFields] > 1) {
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *barButtonItems = @[self.previousBarButton, self.nextBarButton, flexBarButton, self.doneBarButton];
        toolbar.items = barButtonItems;
    }
}

//- (void)markTextFieldsWithTagInView:(UIView*)view
//{
//    int index = 0;
//    if ([self.textFields count] == 0){
//        for(UIView *subView in view.subviews){
//            if ([subView isKindOfClass:[MHTextField class]]){
//                MHTextField *textField = (MHTextField*)subView;
//                textField.tag = index;
//                [self.textFields addObject:textField];
//                index++;
//            }
//        }
//    }
//}

- (void) doneButtonIsClicked:(id)sender
{
    [self setDoneCommand:YES];
    [self resignFirstResponder];
    [self setToolbarCommand:YES];
}

- (void) nextButtonIsClicked:(id)sender
{
    if (self.isSelectField) {
        [self resignFirstResponder];
        return;
    }
    
    NSInteger tagIndex = self.tag;
    if (self.textFieldDelegate) {
        UIView *textField = [self.textFieldDelegate textFieldAtIndex:tagIndex+1];
        if (textField == nil) {
            return;
        }
        [self becomeActive:textField];
    }
}

- (void) previousButtonIsClicked:(id)sender
{
    if (self.isSelectField) {
        [self resignFirstResponder];
        return;
    }
    
    NSInteger tagIndex = self.tag;
    if (self.textFieldDelegate) {
        UIView *textField = [self.textFieldDelegate textFieldAtIndex:tagIndex-1];
        if (textField == nil) {
            return;
        }
        [self becomeActive:textField];
    }
}

- (void)becomeActive:(UIView*)textField
{
    [self setToolbarCommand:YES];
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}

- (void)setBarButtonNeedsDisplayAtTag:(NSInteger)tag
{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;
    
    previousBarButtonEnabled = (tag > MHTextField_TAG_BASE);
    
    if (self.textFieldDelegate) {
        NSInteger num = [self.textFieldDelegate numberOfTextFields];
        nexBarButtonEnabled = (tag < MHTextField_TAG_BASE+num-1);
    }
    
    self.previousBarButton.enabled = previousBarButtonEnabled;
    self.nextBarButton.enabled = nexBarButtonEnabled;
}

- (void) selectInputView:(UITextField *)textField
{
    if (_isDateField){
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (![textField.text isEqualToString:@""]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:kTimeFormatString];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_ch"]];
//            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        [textField setInputView:datePicker];
    }
    else if (_isSelectField) {
        UIPickerView *pickView = [[UIPickerView alloc] init];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.showsSelectionIndicator = YES;
        pickView.backgroundColor = WHITE_COLOR;
        self.selectPickView = pickView;
        [textField setInputView:self.selectPickView];
        [self.selectPickView selectRow:self.selectIndex inComponent:0 animated:YES];
    }
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    
    NSDate *selectedDate = datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kTimeFormatString];
    
    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
    
    //[self validate];
}

- (void)scrollToField
{
    CGRect textFieldRect = _textField.frame;
    
    CGRect aRect = self.window.bounds;
    
    aRect.origin.y = -scrollView.contentOffset.y;
    aRect.size.height -= keyboardSize.height + self.toolbar.frame.size.height + 22;
    
    CGPoint textRectBoundary = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height*2);
   
    if (!CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y > 0) {
        CGPoint scrollPoint = CGPointMake(0.0, self.superview.frame.origin.y + _textField.frame.origin.y + _textField.frame.size.height - aRect.size.height);
        
        if (scrollPoint.y < 0) scrollPoint.y = 0;
        
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (BOOL) validate
{
    if (required && [self.text isEqualToString:@""]){
        [self validateWarning];
        return NO;
    }
    else if (_isEmailField && self.text.length > 0){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text]){
            [self validateWarning];
            return NO;
        }
    }
    
    [self clearWarning];
    
    return YES;
}

- (void) validateWarning
{
    self.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.4];
    self.textColor = WHITE_COLOR;
}

- (void) clearWarning
{
    self.backgroundColor = self.bgColor;
    self.textColor = COLOR_TEXT_DARK;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled) {
        [self setBackgroundColor:RGBCOLOR(0xF8, 0xF8, 0xF8)];
        [self setTextColor:GRAY_COLOR];
    }
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *) notification
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(fieldBeginEditing:index:)]) {
        [self.textFieldDelegate fieldBeginEditing:self index:self.tag];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self clearWarning];
    
    UITextField *textField = (UITextField*)[notification object];
    _textField = textField;
    
    [self setBarButtonNeedsDisplayAtTag:textField.tag];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView*)self.superview;
        self.hasScrollView = YES;
    }
    else {
        self.hasScrollView = NO;
    }
    
    [self selectInputView:textField];
    [self setInputAccessoryView:toolbar];
    
    [self setDoneCommand:NO];
    [self setToolbarCommand:NO];
}

- (void)textFieldDidEndEditing:(NSNotification *) notification
{
    UITextField *textField = (UITextField*)[notification object];

    if (_isSelectField) {
        NSInteger index = [self.selectPickView selectedRowInComponent:0];
        [textField setText:[self.selectArray objectAtIndex:index]];
    }
    
    [self validate];
    
    _textField = nil;
    
    if (_isDateField && [textField.text isEqualToString:@""] && _isDoneCommand){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:kTimeFormatString];
        
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(fieldFinishEditing:index:)]) {
        [self.textFieldDelegate fieldFinishEditing:self index:self.tag];
    }
}

-(void) keyboardDidShow:(NSNotification *) notification
{
    if (_textField == nil) return;
    if (keyboardIsShown) return;
    if (![_textField isKindOfClass:[MHTextField class]]) return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    
    if (self.hasScrollView) {
        [self scrollToField];
    }
    
    self.keyboardIsShown = YES;
}

-(void) keyboardWillHide:(NSNotification *) notification
{
    NSTimeInterval duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
    
    keyboardIsShown = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:self];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.selectArray.count;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.selectArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectIndex = row;
}

//- (NSInteger) selectIndex
//{
//    if (self.selectPickView) {
//        return [self.selectPickView selectedRowInComponent:0];
//    }
//    return -1;
//}

@end
