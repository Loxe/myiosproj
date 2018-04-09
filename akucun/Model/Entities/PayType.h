//
//  PayType.h
//  akucun
//
//  Created by Jarry on 2017/6/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface PayType : JTModel

@property (nonatomic, assign) NSInteger paytype;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;

//@property (nonatomic, assign) NSInteger flag;

@end
