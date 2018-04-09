//
//  Logistics.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface Logistics : JTModel

@property (nonatomic, copy) NSString *fahuoshijian;
@property (nonatomic, copy) NSString *lianxidianhua;
@property (nonatomic, copy) NSString *shouhuodizhi;
@property (nonatomic, copy) NSString *shouhuoren;
@property (nonatomic, copy) NSString *wuliugongsi;
@property (nonatomic, copy) NSString *wuliuhao;

- (NSString *) displayMobile;

@end
