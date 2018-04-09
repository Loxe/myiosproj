//
//  SCActionSheet.h
//  akucun
//
//  Created by Jarry on 2017/6/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCActionSheet : NSObject

// Action的title数组
@property (nonatomic, strong) NSArray * actionTitles;

@property (nonatomic, copy) intBlock finished;

// 自定义构造方法
- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message items:(NSArray *)items;

// 跳转展示方法
- (void) showWithController:(UIViewController *)controller finished:(intBlock)finished;


@end
