//
//  HttpRequestBase.h
//  J1ST-Installer
//
//  Created by Jarry on 17/3/15.
//  Copyright © 2017年 Zenin-tech. All rights reserved.
//

#import "SCHttpRequest.h"
#import "HttpDefines.h"
#import "HttpResponseBase.h"

@interface HttpRequestBase : SCHttpRequest

@property (nonatomic, copy)   NSString  *actionId;

- (void) setParam:(NSString *)value forKey:(NSString *)key;

@end

@interface HttpRequestPOST : SCHttpRequestPOST

@property (nonatomic, copy)   NSString  *actionId;

- (void) setParam:(NSString *)value forKey:(NSString *)key;

@end
