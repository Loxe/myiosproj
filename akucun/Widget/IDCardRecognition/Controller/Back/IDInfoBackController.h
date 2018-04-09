//
//  IDInfoBackController.h
//  IDCardRecognition
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 zhongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDInfo;

@interface IDInfoBackController : UIViewController

// 身份证信息
@property (nonatomic,strong) IDInfo *IDInfo;

// 身份证图像
@property (nonatomic,strong) UIImage *IDImage;

@end
