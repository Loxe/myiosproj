//
//  MeSectionHeaderView.h
//  akucun
//
//  Created by deepin do on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(id nsobject);

@interface MeSectionHeaderView : UIView

@property(nonatomic, strong) NSString *nameString;   // 显示名称
@property(nonatomic, strong) NSString *actionString; // 操作文字

@property(nonatomic, strong) UIButton *actionBtn;    // 响应按钮
@property(nonatomic, strong) UILabel  *nameLabel;    // 显示label
@property(nonatomic, strong) UILabel  *actionLabel;  // 操作label
@property(nonatomic, strong) UIImageView *arrowImgView; // 向右剪头图标

@property(nonatomic, copy) ClickBlock clickBlock;

- (void)setHeaderViewNameTitle:(NSString *)name actionTitle:(NSString *)action;

@end
