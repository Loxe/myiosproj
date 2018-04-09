//
//  SCHttpRequest.h
//  SCUtility
//
//  Created by Jarry on 17/3/14.
//  Copyright © 2017年 Jarry. All rights reserved.
//

#import "SCHttpResponse.h"

/**
 *  HTTP Method
 */
#define     SC_HTTP_GET             1
#define     SC_HTTP_PUT             2
#define     SC_HTTP_POST            3
#define     SC_HTTP_DELETE          4

/**
 *  HTTP 接口请求封装
 */
@interface SCHttpRequest : NSObject

@property (nonatomic, strong) NSMutableDictionary *dataParams;
@property (nonatomic, copy)   NSString    *uriPath;
@property (nonatomic, assign) NSInteger   httpMethod;

// 单独接口测试
@property (nonatomic, copy)   NSString    *testHost;

@property (nonatomic, strong) SCHttpResponse *response;

- (void) initData;

- (void) initParamsDictionary;

- (id) getParams;

- (NSString *) getParamsUri;

@end

/**
 *  HTTP接口请求参数封装
 *  POST Json数据
 */
@interface SCHttpRequestPOST : SCHttpRequest

@property (nonatomic, strong) NSMutableDictionary *jsonBody;

@property (nonatomic, strong) NSArray *datas;


- (void) initJsonBody;

- (id) getBody;


@end

@interface SCUploadData : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy)   NSString *param;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *mimeType;

@end
