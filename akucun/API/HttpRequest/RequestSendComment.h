//
//  RequestSendComment.h
//  akucun
//
//  Created by Jarry on 2017/4/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestSendComment : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, copy)   NSString  *content;

@end
