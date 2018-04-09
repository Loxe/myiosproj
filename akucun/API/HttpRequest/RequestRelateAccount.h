//
//  RequestRelateAccount.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestRelateAccount : HttpRequestBase

@property (nonatomic, copy) NSString *mainDaigouid;
//@property (nonatomic, copy) NSString *shadowUserid;
@property (nonatomic, copy) NSString *code;

@end
