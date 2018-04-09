//
//  RequestUserUpdate.h
//  akucun
//
//  Created by Jarry on 2017/4/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestUserUpdate : HttpRequestPOST

@property (nonatomic, copy)   NSString  *name;

//@property (nonatomic, copy)   NSString  *mobile;

@property (nonatomic, copy)   NSString  *weixinhao;


@end
