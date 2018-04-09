//
//  LiveControl.h
//  akucun
//
//  Created by Jarry on 2017/3/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface LiveControl : JTModel

// 0 为 随机，1 为 周期
@property (nonatomic, assign) NSInteger flag;
// 随机数的大值
@property (nonatomic, assign) NSInteger max;
// 随机数的小值
@property (nonatomic, assign) NSInteger min;
// 周期定时，单位为秒
@property (nonatomic, assign) NSInteger period;

@end
