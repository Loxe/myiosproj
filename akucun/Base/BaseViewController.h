//
//  BaseViewController.h
//  akucun
//
//  Created by Jarry on 17/3/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextButton.h"
#import "UserGuideManager.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *titleView;
//
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TextButton *leftButton, *rightButton;

@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, assign) BOOL showTitleLine;

@property (nonatomic, assign) BOOL hideStatusBar;

@property (nonatomic, assign) BOOL isPresented;

/**
 当前 View Controller 是否可见
 */
- (BOOL) isVisible;

- (void) setupContent;

- (void) initViewData;

- (void) updateData;

- (IBAction) leftButtonAction:(id)sender;

- (IBAction) rightButtonAction:(id)sender;

//- (void) switchTitleText:(NSString *)title toRight:(BOOL)flag;

- (void) confirmWithIcon:(NSString *)icon title:(NSString *)title block:(voidBlock)block canceled:(voidBlock)canceled;

- (void) confirmWithTitle:(NSString *)title block:(voidBlock)block canceled:(voidBlock)canceled;

- (void) confirmWithTitle:(NSString *)title detail:(NSString *)detail block:(voidBlock)block canceled:(voidBlock)canceled;

- (void) confirmWithTitle:(NSString *)title detail:(NSString *)detail btnText:(NSString *)btnText block:(voidBlock)block canceled:(voidBlock)canceled;

- (void) confirmWithTitle:(NSString *)title detail:(NSString *)detail btnText:(NSString *)btnText cancelText:(NSString *)cancelText block:(voidBlock)block canceled:(voidBlock)canceled;

- (void) alertWithIcon:(NSString *)icon detail:(NSString *)detail block:(voidBlock)block;

- (void) alertWithTitle:(NSString *)title detail:(NSString *)detail block:(voidBlock)block;

- (void) alertWithTitle:(NSString *)title btnText:(NSString *)btnText detail:(NSString *)detail block:(voidBlock)block;

@end
