//
//  RequestCancelComment.m
//  akucun
//
//  Created by Jarry on 2017/4/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestCancelComment.h"

@implementation RequestCancelComment

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_COMMENT_CANCEL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"productid"];
    [self.dataParams setParamValue:self.commentId forKey:@"commentid"];
}

@end
