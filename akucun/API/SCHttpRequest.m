//
//  SCHttpRequest.m
//  SCUtility
//
//  Created by Jarry on 17/3/14.
//  Copyright © 2017年 Jarry. All rights reserved.
//

#import "SCHttpRequest.h"

@implementation SCHttpRequest

- (id) init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    
    return self;
}

- (void) initData
{
    _dataParams = [NSMutableDictionary dictionary];
}

- (NSInteger) httpMethod
{
    return SC_HTTP_GET;
}

- (id) getParams
{
    [self initParamsDictionary];
    
    return self.dataParams;
}

- (void) initParamsDictionary
{
    // add params ...
}

- (SCHttpResponse *) response
{
    return [SCHttpResponse new];
}

- (NSString *) getParamsUri
{
    NSDictionary *params = [self getParams];
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *paramsStr = [NSMutableString string];
    int i = 0;
    for (NSString *key in sortedArray) {
        if (i > 0) {
            [paramsStr appendString:@"&"];
        }
        NSString *value = [params objectForKey:key];
        [paramsStr appendFormat:@"%@=%@", key, value];
        i ++;
    }
    
    return paramsStr;
}

@end

@implementation SCHttpRequestPOST

- (id) init
{
    self = [super init];
    if (self) {
        _jsonBody = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSInteger) httpMethod
{
    return SC_HTTP_POST;
}

- (id) getBody
{
    [self initJsonBody];
    return self.jsonBody;
}

- (void) initJsonBody
{
}

@end

@implementation SCUploadData

@end
