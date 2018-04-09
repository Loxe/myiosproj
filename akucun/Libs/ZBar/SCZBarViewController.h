//
//  SCZBarViewController.h
//  Sucang
//
//  Created by Jarry on 16/12/13.
//  Copyright © 2016年 Sucang. All rights reserved.
//

#import "ZBarSDK.h"
#import "ScanOverlayView.h"

@protocol SCZBarDelegate <NSObject>

- (void) scanDidFinished:(NSString *)scanResult;

@optional
- (void) scanDidCanceled;

@end

@interface SCZBarViewController : ZBarReaderViewController

//@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL qrcodeEnabled;
@property (nonatomic, assign) BOOL barcodeEnabled;

@property (nonatomic, weak) id <SCZBarDelegate> scanDelegate;

- (instancetype) initWithTitle:(NSString *)title;

@end
