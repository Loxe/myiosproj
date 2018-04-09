//
//  SCHttpResponse.h
//  SCUtility
//
//  Created by Jarry on 17/3/14.
//  Copyright © 2017年 Jarry. All rights reserved.
//

#import "JSONKit.h"

/**
 *  HTTP接口返回数据解析
 */
@interface SCHttpResponse : NSObject

@property (nonatomic, strong)   id  responseData;

@property (nonatomic, copy)     NSString *dataKey;


- (BOOL) checkSuccess:(NSDictionary *)response;

- (BOOL) checkFailed:(NSDictionary *)response;

- (void) parseResponse:(NSDictionary *)dictionary;

- (void) parseDataObj:(id)Object;

- (void) showLog;

- (void) showError:(id)error;

@end
