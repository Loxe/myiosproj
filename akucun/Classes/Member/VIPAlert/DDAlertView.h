//
//  DDAlertView.h
//  akucun
//
//  Created by deepin do on 2018/3/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDAlertActionStyle) {
    DDAlertActionStyleDefault,
    DDAlertActionStyleCancel,
    DDAlertActionStyleDestructive,
};

@interface DDAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(DDAlertActionStyle)style handler:(void (^)(DDAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) DDAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface DDAlertView : UIView

@property (nonatomic, weak, readonly) UIImageView *titleImgView;
@property (nonatomic, weak, readonly) UILabel *titleLable;
@property (nonatomic, weak, readonly) UILabel *messageLabel;

// alertView textfield array
@property (nonatomic, strong, readonly) NSArray *textFieldArray;

// default 280, if 0 don't add width constraint,
@property (nonatomic, assign) CGFloat alertViewWidth;

// contentView space custom
@property (nonatomic, assign) CGFloat contentViewSpace;

// textLabel custom
@property (nonatomic, assign) CGFloat textLabelSpace;
@property (nonatomic, assign) CGFloat textLabelContentViewEdge;

// button custom
@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonSpace;
@property (nonatomic, assign) CGFloat buttonContentViewEdge;
@property (nonatomic, assign) CGFloat buttonContentViewTop;
@property (nonatomic, assign) CGFloat buttonCornerRadius;
@property (nonatomic, strong) UIFont  *buttonFont;
@property (nonatomic, strong) UIColor *buttonDefaultBgColor;
@property (nonatomic, strong) UIColor *buttonCancelBgColor;
@property (nonatomic, strong) UIColor *buttonDestructiveBgColor;

// textField custom
@property (nonatomic, strong) UIColor *textFieldBorderColor;
@property (nonatomic, strong) UIColor *textFieldBackgroudColor;
@property (nonatomic, strong) UIFont  *textFieldFont;
@property (nonatomic, assign) CGFloat textFieldHeight;
@property (nonatomic, assign) CGFloat textFieldEdge;
@property (nonatomic, assign) CGFloat textFieldBorderWidth;
@property (nonatomic, assign) CGFloat textFieldContentViewEdge;

@property (nonatomic, assign) BOOL clickedAutoHide;
@property (nonatomic, assign) BOOL closeBtnHide;

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(DDAlertAction *)action;

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;


@end
