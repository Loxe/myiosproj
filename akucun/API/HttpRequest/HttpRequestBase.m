//
//  HttpRequestBase.m
//  J1ST-Installer
//
//  Created by Jarry on 17/3/15.
//  Copyright © 2017年 Zenin-tech. All rights reserved.
//

#import "HttpRequestBase.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserManager.h"

@implementation HttpRequestBase

- (SCHttpResponse *) response
{
    return [HttpResponseBase new];
}

- (void) initParamsDictionary
{
    // App ID
    [self.dataParams setParamValue:kAPI_AppID forKey:HTTP_KEY_APPID];
    // Nonce Str
    NSString *nonceStr = [HttpRequestBase randomString];
    [self.dataParams setParamValue:nonceStr forKey:HTTP_KEY_NONCESTR];
    // Timestamp
    [self.dataParams setParamValue:[NSDate timeIntervalString] forKey:HTTP_KEY_TIMESTAMP];

    if (self.actionId) {
        [self.dataParams setParamValue:self.actionId forKey:HTTP_KEY_ACTION];
    }
    
    // User ID & Token
    NSString *token = [UserManager token];
    if (token && token.length > 0) {
        [self.dataParams setParamValue:token forKey:@"token"];
    }
    NSString *userId = [UserManager userId];
    if (userId && userId.length > 0) {
        [self.dataParams setParamValue:userId forKey:@"userid"];
    }
    // 新增 subuserid
    NSString *subuserId = [UserManager subuserId];
    if (subuserId && subuserId.length > 0) {
        [self.dataParams setParamValue:subuserId forKey:@"subuserid"];
    }
    
    // 设备唯一ID
    NSString *did = [ServerManager instance].deviceId;
    [self.dataParams setParamValue:did forKey:@"did"];
}

- (NSDictionary *) getParams
{
    [self initParamsDictionary];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.dataParams];
    // sig
    NSString *sig = [HttpRequestBase sigString:self.dataParams path:self.uriPath];
    [params setParamValue:sig forKey:HTTP_KEY_SIG];
    
    return params;
}

- (void) setParam:(NSString *)value forKey:(NSString *)key
{
    [self.dataParams setParamValue:value forKey:key];
//    [self.dataParams setParamValue:[value urlEncodedString] forKey:key];
}

+ (NSString *) sigString:(NSDictionary *)params path:(NSString *)path
{
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
    
    NSString *host = [SCHttpServiceFace instance].serverHost;
    NSMutableString *url = [NSMutableString stringWithString:FORMAT(@"%@/%@", host, path)];
    if (paramsStr.length > 0) {
        [url appendFormat:@"?%@", paramsStr];
    }
    
    NSString *sigStr = FORMAT(@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                              HTTP_KEY_APPID, kAPI_AppID,
                              HTTP_KEY_NONCESTR, params[HTTP_KEY_NONCESTR],
                              HTTP_KEY_TIMESTAMP, params[HTTP_KEY_TIMESTAMP],
                              HTTP_KEY_SECRET, kAPI_AppSecret,
                              HTTP_KEY_URL, url);
    
    NSString *SHA1 = [HttpRequestBase SHA1String:sigStr];
    DEBUGLOG(@"\nurl: %@&sig=%@", url, SHA1);

    return SHA1;
}

+ (NSString *) randomString
{
    int NUMBER_OF_CHARS = 8;
    char data[NUMBER_OF_CHARS];
    for (int x = 0; x < NUMBER_OF_CHARS; data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

+ (NSString *) SHA1String:(NSString *)input
{
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end

@implementation HttpRequestPOST

- (SCHttpResponse *) response
{
    return [HttpResponseBase new];
}

- (void) initParamsDictionary
{
    // App ID
    [self.dataParams setParamValue:kAPI_AppID forKey:HTTP_KEY_APPID];
    // Nonce Str
    NSString *nonceStr = [HttpRequestBase randomString];
    [self.dataParams setParamValue:nonceStr forKey:HTTP_KEY_NONCESTR];
    // Timestamp
    [self.dataParams setParamValue:[NSDate timeIntervalString] forKey:HTTP_KEY_TIMESTAMP];
    
    if (self.actionId) {
        [self.dataParams setParamValue:self.actionId forKey:HTTP_KEY_ACTION];
    }
    
    // User ID & Token
    NSString *token = [UserManager token];
    if (token && token.length > 0) {
        [self.dataParams setParamValue:token forKey:@"token"];
    }
    NSString *userId = [UserManager userId];
    if (userId && userId.length > 0) {
        [self.dataParams setParamValue:userId forKey:@"userid"];
    }
    // 新增 subuserid
    NSString *subuserId = [UserManager subuserId];
    if (subuserId && subuserId.length > 0) {
        [self.dataParams setParamValue:subuserId forKey:@"subuserid"];
    }
    
    // 设备唯一ID
    NSString *did = [ServerManager instance].deviceId;
    [self.dataParams setParamValue:did forKey:@"did"];
}

- (NSDictionary *) getParams
{
    [self initParamsDictionary];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.dataParams];
    // sig
    NSString *sig = [HttpRequestBase sigString:self.dataParams path:self.uriPath];
    [params setParamValue:sig forKey:HTTP_KEY_SIG];
    
    return params;
}

- (void) initJsonBody
{
}

- (void) setParam:(NSString *)value forKey:(NSString *)key
{
    [self.dataParams setParamValue:value forKey:key];
    //    [self.dataParams setParamValue:[value urlEncodedString] forKey:key];
}

@end
