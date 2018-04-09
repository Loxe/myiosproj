//
//  YuemxCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "AccountRecord.h"

@interface YuemxCellLayout : AKCellLayout

@property (nonatomic,strong) AccountRecord* record;

- (id) initWithModel:(AccountRecord*)record;

@end
