//
//  SCHttpServiceFace.h
//  SCUtility
//
//  Created by Jarry on 17/3/14.
//  Copyright © 2017年 Jarry. All rights reserved.
//

#import "SCHttpRequest.h"

/**
 *  HTTP 网络请求接口封装
 *  使用 AFNetworking
 *  !! 调用 HTTP 请求前 必须先配置服务器主机地址
 */
@interface SCHttpServiceFace : NSObject

/**
 *  服务器主机地址
 */
@property (nonatomic, copy)     NSString    *serverHost;

/**
 *  User Agent
 */
@property (nonatomic, copy)     NSString    *userAgent;

/**
 *  自定义 HTTP 头参数
 */
@property (nonatomic, strong)   NSDictionary *headerParams;

/**
 *  请求超时时间， 默认 15 秒
 */
@property (nonatomic, assign)   NSTimeInterval  timeoutInterval;

/**
 *  是否打印 HTTP 请求/响应 的 Log 信息，默认 YES
 */
@property (nonatomic, assign)   BOOL    logEnabled;

//@property (nonatomic, copy)     idBlock     successBlock;
//@property (nonatomic, copy)     idBlock     failedBlock;

/**
 *	HTTP业务请求 外部调用接口
 *
 *	@param 	request     HttpRequest
 *	@param 	success 	返回成功处理Block
 *	@param 	failed      失败处理Block
 */
+ (void) serviceWithRequest:(SCHttpRequest *)request
                  onSuccess:(idBlock)success
                   onFailed:(idBlock)failed;

/**
 *	HTTP业务请求 外部调用接口
 *
 *	@param 	request     HttpRequest
 *	@param 	success 	返回成功处理Block
 *	@param 	failed      失败处理Block
 *	@param 	errorBlock  错误处理Block
 */
+ (void) serviceWithRequest:(SCHttpRequest *)request
                  onSuccess:(idBlock)success
                   onFailed:(idBlock)failed
                    onError:(idBlock)errorBlock;

/**
 *	HTTP POST请求 外部调用接口
 *
 *	@param 	request     HttpRequestPOST
 *	@param 	success 	返回成功处理Block
 *	@param 	failed      失败处理Block
 */
+ (void) serviceWithPostRequest:(SCHttpRequestPOST *)request
                      onSuccess:(idBlock)success
                       onFailed:(idBlock)failed;

/**
 *	HTTP POST请求 外部调用接口
 *
 *	@param 	request     HttpRequestPOST
 *	@param 	success 	返回成功处理Block
 *	@param 	failed      失败处理Block
 *	@param 	errorBlock  错误处理Block
 */
+ (void) serviceWithPostRequest:(SCHttpRequestPOST *)request
                      onSuccess:(idBlock)success
                       onFailed:(idBlock)failed
                        onError:(idBlock)errorBlock;

/**
 *    HTTP 文件上传请求 外部调用接口
 *
 *    @param     request     HttpRequestPOST (请求对象中包含datas)
 *    @param     success     返回成功处理Block
 *    @param     failed      失败处理Block
 *    @param     errorBlock  错误处理Block
 */
+ (void) serviceWithUploadRequest:(SCHttpRequestPOST *)request
                         progress:(void (^)(NSProgress *))uploadProgress
                        onSuccess:(idBlock)success
                         onFailed:(idBlock)failed
                          onError:(idBlock)errorBlock;

/**
 *	HTTP URL请求 外部调用接口
 *
 *	@param 	url         请求URL
 *	@param 	method      HTTP请求方法
 *	@param 	params      HTTP请求参数
 *	@param 	success 	返回成功处理Block
 *	@param 	errorBlock  错误处理Block
 */
+ (void) serviceWithURL:(NSString *)url
                 method:(NSInteger)method
                 params:(id)params
                  onSuc:(idBlock)success
                onError:(idBlock)errorBlock;

+ (SCHttpServiceFace *) instance;

/**
 *  URL 请求接口
 *
 *  @param url        URL
 *  @param method     HTTP请求方法
 *  @param params     参数
 *  @param success    返回成功处理Block
 *  @param errorBlock 错误处理Block
 */
- (void) serviceWithURL:(NSString *)url
                 method:(NSInteger)method
                 params:(id)params
                  onSuc:(idBlock)success
                onError:(idBlock)errorBlock;

/**
 *  图片上传 接口
 *
 *  @param url        URL
 *  @param imageData  图片数据
 *  @param param      参数
 *  @param success    返回成功处理Block
 *  @param errorBlock 错误处理Block
 */
- (void) serviceWithUploadURL:(NSString *)url
                        image:(NSData *)imageData
                        param:(NSDictionary *)param
                        onSuc:(idBlock)success
                      onError:(idBlock)errorBlock;

/**
 *  图片上传 接口
 *
 *  @param url        URL
 *  @param datasParam 上传文件参数 key:(SCUploadData*)
 *  @param param      参数
 *  @param success    返回成功处理Block
 *  @param errorBlock 错误处理Block
 */
- (void) serviceWithUploadURL:(NSString *)url
                        datas:(NSArray *)datasParam
                        param:(NSDictionary *)param
                     progress:(void (^)(NSProgress *))uploadProgress
                        onSuc:(idBlock)success
                      onError:(idBlock)errorBlock;

/**
 *  文件下载
 *
 *  @param url        URL
 *  @param filePath   文件保存路径
 *  @param success    返回成功处理Block
 *  @param errorBlock 错误处理Block
 */
+ (void) serviceWithDownloadURL:(NSString *)url
                           path:(NSString *)filePath
                          onSuc:(idBlock)success
                        onError:(idBlock)errorBlock;

+ (void) cancelAllRequest;

@end
