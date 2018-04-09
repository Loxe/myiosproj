//
//  RewardSectionHeaderView.h
//  akucun
//
//  Created by deepin do on 2018/1/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextButton.h"

typedef void(^ClickBlock)(id nsobject);

@interface RewardSectionHeaderView : UIView

@property(nonatomic, strong) NSString *nameString;   // 显示名称
@property(nonatomic, strong) NSString *actionString; // 操作文字

@property(nonatomic, strong) UILabel  *nameLabel;    // 显示label
@property(nonatomic, strong) TextButton *actionBtn;    // 响应按钮

@property(nonatomic, copy) ClickBlock clickBlock;

@property(nonatomic, strong) UIView  *separateLine;

- (void)initWithTitle:(NSString *)name count:(NSInteger)count actionTitle:(NSString *)action;

@end
