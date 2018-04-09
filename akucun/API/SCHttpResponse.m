//
//  SCHttpResponse.m
//  SCUtility
//
//  Created by Jarry on 17/3/14.
//  Copyright © 2017年 Jarry. All rights reserved.
//

#import "SCHttpResponse.h"


#define     HTTP_KEY_DATA           @"data"
#define     HTTP_KEY_STATUS         @"status"

/**
 *  HTTP Response Status
 */
#define     HTTP_STATUS_SUCCESS     @"success"
#define     HTTP_STATUS_ERROR       @"error"
#define     HTTP_STATUS_FAIL        @"fail"

@implementation SCHttpResponse

- (BOOL) checkSuccess:(NSDictionary *)response
{
    NSString *status = [response objectForKey:HTTP_KEY_STATUS];
    return [status isEqualToString:HTTP_STATUS_SUCCESS];
}

- (BOOL) checkFailed:(NSDictionary *)response
{
    NSString *status = [response objectForKey:HTTP_KEY_STATUS];
    return [status isEqualToString:HTTP_STATUS_FAIL];
}

- (NSString *) dataKey
{
    return @"data";
}

- (void) parseResponse:(NSDictionary *)dictionary
{
    self.responseData = [dictionary objectForKey:self.dataKey];
    // parse response data ...
    [self parseDataObj:self.responseData];
}

- (void) parseDataObj:(id)Object
{
    
}

- (void) showLog
{
    if (self.responseData) {
        INFOLOG(@"HTTP Response: \n%@", self.responseData);
    }
}

- (void) showError:(id)error
{
    if (error) {
        ERRORLOG(@"Response Error: \n%@", error);
    }
}

@end
