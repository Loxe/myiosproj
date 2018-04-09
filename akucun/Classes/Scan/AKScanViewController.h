//
//  AKScanViewController.h
//  akucun
//
//  Created by Jarry Z on 2018/3/31.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    /// 默认样式，都可以
    AKScanningTypeDefault,
    /// 条码式
    AKScanningTypeBarCode,
    //
    AKScanningTypeQRCode
    
} AKScanningType;


@interface AKScanViewController : BaseViewController

// 扫描控制器类型
@property (nonatomic, assign) AKScanningType scanningType;

// 扫描回调
@property (nonatomic, copy) void(^scanResultBlock)(NSString *codeString);

@end
