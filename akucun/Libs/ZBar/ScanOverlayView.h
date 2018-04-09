//
//  ScanOverlayView.h
//  EachingMobile
//
//  Created by Jarry on 15/7/2.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanOverlayDelegate <NSObject>

@optional

- (void) scanViewDidCanceled;

- (void) scanViewFlashlamp:(BOOL)lampOn;

@end

@interface ScanOverlayView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descript;

@property (nonatomic, weak) id <ScanOverlayDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UIImageView *lineView;

- (id) initWithFrame:(CGRect)frame title:(NSString *)title;

- (CGRect) scanRect;

- (void) startAnimation;
- (void) cancelAnimation;

@end

@interface FlashlampButton : UIButton

@end
