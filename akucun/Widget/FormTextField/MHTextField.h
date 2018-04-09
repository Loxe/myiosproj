//
//  MHTextField.h
//
//  Created by Jarry on 4/11/13.
//  Copyright (c) 2013 Zenin-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  MHTextField_TAG_BASE   100

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

@required
- (UIView*) textFieldAtIndex:(NSInteger)index;
- (NSInteger) numberOfTextFields;
@optional
- (void) fieldBeginEditing:(MHTextField*)field index:(NSInteger)index;
- (void) fieldFinishEditing:(MHTextField*)field index:(NSInteger)index;
@end

@interface MHTextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, setter = setDateField:) BOOL isDateField;

@property (nonatomic, setter = setSelectField:) BOOL isSelectField;
@property (nonatomic, strong) UIPickerView *selectPickView;
@property (nonatomic, strong) NSArray   *selectArray;
@property (nonatomic, setter = setSelectIndex:) NSInteger selectIndex;

@property (nonatomic, setter = setEmailField:) BOOL isEmailField;

@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;

@property   (nonatomic, copy)   UIColor     *bgColor;
@property   (nonatomic, copy)   NSString    *doneText, *nextText, *prevText;

- (void) setFieldTag:(NSInteger)index;
- (BOOL) validate;
- (void) validateWarning;
- (void) clearWarning;

//- (NSInteger) selectIndex;

@end
