//
//  ASaleCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "ASaleService.h"

@interface ASaleCellLayout : AKCellLayout

@property (nonatomic, strong) ASaleService *model;

@property (nonatomic,assign) CGFloat linePosition1;
@property (nonatomic,assign) CGFloat linePosition2;
@property (nonatomic,assign) CGFloat imageTop;

- (id) initWithModel:(ASaleService *)model;

@end
