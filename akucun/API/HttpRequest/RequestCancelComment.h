//
//  RequestCancelComment.h
//  akucun
//
//  Created by Jarry on 2017/4/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestCancelComment : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, copy)   NSString  *commentId;

@end
