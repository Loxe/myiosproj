//
//  SCHttpServiceFace.m
//  SCUtility
//
//  Created by Jarry on 17/3/14.
//  Copyright © 2017年 Jarry. All rights reserved.
//

#import "SCHttpServiceFace.h"
#import "AFNetworking.h"

/**
 *  默认超时时间
 */
#define     kHTTPTimeoutDefault   15.0f

typedef void (^HTTPSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^HTTPFailedBlock)(NSURLSessionDataTask *task, NSError *error);

@interface SCHttpServiceFace ()

@end

@implementation SCHttpServiceFace

+ (void) serviceWithRequest:(SCHttpRequest *)request
                  onSuccess:(idBlock)success
                   onFailed:(idBlock)failed
{
    [self serviceWithRequest:request
                   onSuccess:success
                    onFailed:failed
                     onError:nil];
}

+ (void) serviceWithRequest:(SCHttpRequest *)request
                  onSuccess:(idBlock)success
                   onFailed:(idBlock)failed
                    onError:(idBlock)errorBlock
{
    NSString *host = [SCHttpServiceFace instance].serverHost;
    NSAssert(host, @"!! Server host cannot be nil !");
    
    // 接口测试
    if (request.testHost) {
        host = request.testHost;
    }

    NSInteger method = [request httpMethod];
    NSString *url = FORMAT(@"%@/%@", host, request.uriPath);
    id param = [request getParams];
    SCHttpResponse *response = [request response];
    
    [[SCHttpServiceFace instance] serviceWithURL:url
                                          method:method
                                          params:param
                                           onSuc:^(id content)
    {
        // Response JSON Data
        NSDictionary *responseData = content;
        // Check Success
        if ([response checkSuccess:responseData]) {
            
            [response parseResponse:responseData];
            
            //
            if ([SCHttpServiceFace instance].logEnabled) {
                [response showLog];
            }
            
            // Success Block
            if (success) {
                GCD_MAIN(^{
                    success(response);
                });
            }
        }
        // Failed
        else if ([response checkFailed:responseData]) {

//            ERRORLOG(@"!! HTTP Request Error: %@", responseData);

            GCD_MAIN(^{                                                                                                                                                                                           
                
                [response showError:responseData];
                
                if (failed) {
                    failed(responseData);
                }
            });
        }
        // Error
        else {
//            ERRORLOG(@"!! HTTP Request Error: %@", responseData);
            GCD_MAIN(^{

                [response showError:responseData];

                if (errorBlock) {
                    errorBlock(responseData);
                }
            });
        }
    }
                                         onError:^(id content)
    {
        [response showError:content];
        
        if (errorBlock) {
            errorBlock(content);
        }
    }];
}

+ (void) serviceWithPostRequest:(SCHttpRequestPOST *)request
                      onSuccess:(idBlock)success
                       onFailed:(idBlock)failed
{
    [self serviceWithPostRequest:request
                       onSuccess:success
                        onFailed:failed
                         onError:nil];
}

+ (void) serviceWithPostRequest:(SCHttpRequestPOST *)request
                      onSuccess:(idBlock)success
                       onFailed:(idBlock)failed
                        onError:(idBlock)errorBlock
{
    NSString *host = [SCHttpServiceFace instance].serverHost;
    NSAssert(host, @"!! Server host cannot be nil !");

    // 接口测试
    if (request.testHost) {
        host = request.testHost;
    }

    NSMutableString *url = [NSMutableString stringWithString:FORMAT(@"%@/%@", host, request.uriPath)];
    
    NSString *paramsUri = [request getParamsUri];
    if (paramsUri.length > 0) {
        [url appendString:@"?"];
        [url appendString:paramsUri];
    }
    
    id jsonBody = [request getBody];
    SCHttpResponse *response = [request response];

    [[SCHttpServiceFace instance] serviceWithURL:url
                                          method:SC_HTTP_POST
                                          params:jsonBody
                                           onSuc:^(id content)
     {
         // Response JSON Data
         NSDictionary *responseData = content;
         // Check Success
         if ([response checkSuccess:responseData]) {
             
             [response parseResponse:responseData];
             
             //
             if ([SCHttpServiceFace instance].logEnabled) {
                 [response showLog];
             }
             
             // Success Block
             if (success) {
                 GCD_MAIN(^{
                     success(response);
                 });
             }
         }
         // Failed
         else if ([response checkFailed:responseData]) {
             GCD_MAIN(^{
                 
                 [response showError:responseData];
                 
                 if (failed) {
                     failed(responseData);
                 }
             });
         }
         // Error
         else {
             GCD_MAIN(^{
                 
                 [response showError:responseData];
                 
                 if (errorBlock) {
                     errorBlock(responseData);
                 }
             });
         }
     }
                                         onError:^(id content)
     {
         [response showError:content];
         
         if (errorBlock) {
             errorBlock(content);
         }
     }];
}

+ (void) serviceWithURL:(NSString *)url
                 method:(NSInteger)method
                 params:(id)params
                  onSuc:(idBlock)success
                onError:(idBlock)errorBlock
{
    [[SCHttpServiceFace instance] serviceWithURL:url
                                          method:method
                                          params:params
                                           onSuc:success
                                         onError:errorBlock];
}

+ (void) serviceWithUploadRequest:(SCHttpRequestPOST *)request
                         progress:(void (^)(NSProgress *))uploadProgress
                        onSuccess:(idBlock)success
                         onFailed:(idBlock)failed
                          onError:(idBlock)errorBlock
{
    NSString *host = [SCHttpServiceFace instance].serverHost;
    NSAssert(host, @"!! Server host cannot be nil !");
    
    NSMutableString *url = [NSMutableString stringWithString:FORMAT(@"%@/%@", host, request.uriPath)];
    
    NSString *paramsUri = [request getParamsUri];
    if (paramsUri.length > 0) {
        [url appendString:@"?"];
        [url appendString:paramsUri];
    }
    
    id jsonBody = [request getBody];
    SCHttpResponse *response = [request response];
    [[SCHttpServiceFace instance] serviceWithUploadURL:url
                                                 datas:request.datas
                                                 param:jsonBody
                                              progress:^(NSProgress * progress)
     {
        DEBUGLOG(@"HTTP - Upload Progress : %@", progress);
         GCD_MAIN(^{
             if (uploadProgress) {
                 uploadProgress(progress);
             }
         });
     }
                                                 onSuc:^(id content)
     {
         // Response JSON Data
         NSDictionary *responseData = content;
         // Check Success
         if ([response checkSuccess:responseData]) {
             
             [response parseResponse:responseData];
             
             //
             if ([SCHttpServiceFace instance].logEnabled) {
                 [response showLog];
             }
             
             // Success Block
             if (success) {
                 GCD_MAIN(^{
                     success(response);
                 });
             }
         }
         // Failed
         else if ([response checkFailed:responseData]) {
             GCD_MAIN(^{
                 [response showError:responseData];
                 
                 if (failed) {
                     failed(responseData);
                 }
             });
         }
         // Error
         else {
             GCD_MAIN(^{
                 [response showError:responseData];
                 
                 if (errorBlock) {
                     errorBlock(responseData);
                 }
             });
         }
     }
                                         onError:^(id content)
     {
         [response showError:content];
         
         if (errorBlock) {
             errorBlock(content);
         }
     }];
}

#pragma mark -

+ (SCHttpServiceFace *) instance
{
    static dispatch_once_t  onceToken;
    static SCHttpServiceFace * instance;
    dispatch_once(&onceToken, ^{
        instance = [[SCHttpServiceFace alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        //
        self.timeoutInterval = kHTTPTimeoutDefault;
        self.logEnabled = YES;
    }
    return self;
}

- (void) serviceWithURL:(NSString *)url
                 method:(NSInteger)method
                 params:(id)params
                  onSuc:(idBlock)success
                onError:(idBlock)errorBlock
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (method == SC_HTTP_PUT || method == SC_HTTP_POST) {
        session.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else {
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    [session.requestSerializer setTimeoutInterval:self.timeoutInterval];
    [session.requestSerializer setValue:@"application/json"
                     forHTTPHeaderField:@"Accept"];
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/x-json", @"text/json", @"text/plain", @"text/html", nil];
    
    // User-Agent
    if (self.userAgent) {
        [session.requestSerializer setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    }

    // 自定义 Header
    if (self.headerParams) {
        for (NSString *key in self.headerParams) {
            [session.requestSerializer setValue:self.headerParams[key] forHTTPHeaderField:key];
        }
    }
    
    //
    HTTPSuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObject)
    {
        if (!responseObject) {
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
            return;
        }
        
        NSDictionary *jsonData = nil;
        @try {
            jsonData = [responseObject objectFromJSONData];
        } @catch (NSException *exception) {
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
        }
        if (!jsonData) {
            ERRORLOG(@"!! HTTP Response Error: \n%@\n%@", url, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
            return;
        }
        
//        if (self.logEnabled) {
//            NSString *respString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            INFOLOG(@"HTTP Response: \n %@\n%@", url, respString);
//        }

        if (success) {
            success(jsonData);
        }
    };
    
    //
    HTTPFailedBlock failedBlock = ^(NSURLSessionDataTask *task, NSError *error)
    {
        ERRORLOG(@"!! HTTP Error: %@", error);
        
        // error
        if (errorBlock) {
            errorBlock(error);
        }
    };
    
    //
    NSString *methodString = nil;
    if (method == SC_HTTP_PUT) {
        methodString = @"PUT";
        [session PUT:url parameters:params success:successBlock failure:failedBlock];
    }
    else if (method == SC_HTTP_POST) {
        methodString = @"POST";
        [session POST:url parameters:params progress:nil success:successBlock failure:failedBlock];
    }
    else if (method == SC_HTTP_DELETE) {
        methodString = @"DELETE";
        [session DELETE:url parameters:params success:successBlock failure:failedBlock];
    }
    else {
        methodString = @"GET";
        [session GET:url parameters:params progress:nil success:successBlock failure:failedBlock];
    }
    
    if (self.logEnabled) {
        DEBUGLOG(@"HTTP - %@   %@ \n%@", methodString, url, params);
    }
}

- (void) serviceWithUploadURL:(NSString *)url
                        image:(NSData *)imageData
                        param:(NSDictionary *)param
                        onSuc:(idBlock)success
                      onError:(idBlock)errorBlock
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [session.requestSerializer setTimeoutInterval:300];
//    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/x-json", @"text/json", @"text/plain", @"text/html", nil];
    
    // User-Agent
    if (self.userAgent) {
        [session.requestSerializer setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    // 自定义 Header
    if (self.headerParams) {
        for (NSString *key in self.headerParams) {
            [session.requestSerializer setValue:self.headerParams[key] forHTTPHeaderField:key];
        }
    }

    //
    HTTPSuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObject)
    {
        if (!responseObject) {
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
            return;
        }
        NSDictionary *jsonData = nil;
        @try {
            jsonData = [responseObject objectFromJSONData];
        } @catch (NSException *exception) {
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
        }
        if (!jsonData) {
            ERRORLOG(@"!! HTTP Response Error: \n%@\n%@", url, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
            return;
        }
        
        if (self.logEnabled) {
            INFOLOG(@"HTTP Response: \n %@\n%@", url, jsonData);
        }
        
        if (success) {
            success(jsonData);
        }
    };
    
    //
    HTTPFailedBlock failedBlock = ^(NSURLSessionDataTask *task, NSError *error)
    {
        ERRORLOG(@"!! HTTP Error: %@", error);
        
        // error
        if (errorBlock) {
            errorBlock(error);
        }
    };
    
    //
    [session POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
     } progress:nil success:successBlock failure:failedBlock];
    
    if (self.logEnabled) {
        DEBUGLOG(@"HTTP - UPLOAD   %@ \n%@", url, param);
    }
}

- (void) serviceWithUploadURL:(NSString *)url
                        datas:(NSArray *)datasParam
                        param:(NSDictionary *)param
                     progress:(void (^)(NSProgress *))uploadProgress
                        onSuc:(idBlock)success
                      onError:(idBlock)errorBlock
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [session.requestSerializer setTimeoutInterval:300];
    [session.requestSerializer setValue:@"application/json"
                     forHTTPHeaderField:@"Accept"];
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/x-json", @"text/json", @"text/plain", @"text/html", nil];
    
    // User-Agent
    if (self.userAgent) {
        [session.requestSerializer setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    // 自定义 Header
    if (self.headerParams) {
        for (NSString *key in self.headerParams) {
            [session.requestSerializer setValue:self.headerParams[key] forHTTPHeaderField:key];
        }
    }
    
    //
    HTTPSuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObject)
    {
        if (!responseObject) {
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
            return;
        }
        NSDictionary *jsonData = nil;
        @try {
            jsonData = [responseObject objectFromJSONData];
        } @catch (NSException *exception) {
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
        }
        if (!jsonData) {
            ERRORLOG(@"!! HTTP Response Error: \n%@\n%@", url, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            // error
            if (errorBlock) {
                errorBlock(@"Response Data Error !");
            }
            return;
        }
        
        if (self.logEnabled) {
            INFOLOG(@"HTTP Response: \n %@\n%@", url, jsonData);
        }
        
        if (success) {
            success(jsonData);
        }
    };
    
    //
    HTTPFailedBlock failedBlock = ^(NSURLSessionDataTask *task, NSError *error)
    {
        ERRORLOG(@"!! HTTP Error: %@", error);
        
        // error
        if (errorBlock) {
            errorBlock(error);
        }
    };
    
    //
    [session POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         for (SCUploadData *data in datasParam) {
             [formData appendPartWithFileData:data.data name:data.param fileName:data.name mimeType:data.mimeType];
         }
         
     } progress:uploadProgress success:successBlock failure:failedBlock];
    
    if (self.logEnabled) {
        DEBUGLOG(@"HTTP - UPLOAD   %@ \n%@", url, param);
    }
}

+ (void) serviceWithDownloadURL:(NSString *)url
                           path:(NSString *)filePath
                          onSuc:(idBlock)success
                        onError:(idBlock)errorBlock
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *task =
    [session downloadTaskWithRequest:request progress:^(NSProgress * downloadProgress) {
        
        //下载进度
        DEBUGLOG(@"HTTP - Download Progress : %@", downloadProgress);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
        }];
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            ERRORLOG(@"!! HTTP Error: %@", error);
            GCD_MAIN(^{
                if (errorBlock) {
                    errorBlock(error);
                }
            });
        }
        else {
            // 下载完成了
            DEBUGLOG(@"HTTP - Download finished :\n%@", filePath);
            GCD_MAIN(^{
                if (success) {
                    success(filePath);
                }
            });
        }
    }];
    
    DEBUGLOG(@"HTTP - Download   %@", url);
    [task resume];
}

+ (void) cancelAllRequest
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session.operationQueue cancelAllOperations];
}

@end
