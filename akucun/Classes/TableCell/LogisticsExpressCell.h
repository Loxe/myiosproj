//
//  LogisticsExpressCell.h
//  akucun
//
//  Created by deepin do on 2017/12/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CopyBlock)(id nsobject);

@interface LogisticsExpressCell : UITableViewCell

@property(nonatomic, copy) NSString *wuliuhao;
@property(nonatomic, copy) NSString *wuliugongsi;

// 复制单号
@property(nonatomic, strong) UIButton *copyBtn;

// 复制单号回调
@property(nonatomic, copy) CopyBlock copyBlock;

// 快递单号-标题
@property(nonatomic, strong) UILabel *expressNumberTitle;

// 快递单号
@property(nonatomic, strong) UILabel *expressNumberLabel;

// 快递公司-标题
@property(nonatomic, strong) UILabel *expressCompanyTitle;

// 快递公司
@property(nonatomic, strong) UILabel *expressCompanyLabel;


@end
