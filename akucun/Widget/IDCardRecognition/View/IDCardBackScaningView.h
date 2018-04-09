//
//  IDCardBackScaningView.h
//  IDCardRecognition
//
//  Created by deepin do on 2017/12/21.
//  Copyright © 2017年 zhongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCardBackScaningView : UIView

@property (nonatomic,assign) CGRect facePathRect;

@property(nonatomic, strong) CAShapeLayer *IDCardScanningWindowLayer;

- (void)stopTimer;

@end
