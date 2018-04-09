//
//  BankNumberFomatter.h
//  akucun
//
//  Created by deepin do on 2017/12/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BankNumberFomatter : NSObject

/** 默认为4，即4个数一组 用空格分隔 */
@property (assign, nonatomic) NSInteger groupSize;

/** 分隔符 默认为空格 */
@property (copy, nonatomic) NSString *separator;

- (void)numberField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


@end
