//
//  RequestDiscoverUploadNew.m
//  akucun
//
//  Created by deepin do on 2017/12/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDiscoverUploadNew.h"
#import "UserManager.h"

@implementation RequestDiscoverUploadNew

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_UPNew;
}

- (void) initJsonBody
{
    //Basic 
    [self.jsonBody setParamValue:[UserManager instance].userId forKey:@"userid"];
    
    [self.jsonBody setParamIntegerValue:self.type forKey:@"type"];
    [self.jsonBody setParamValue:self.title forKey:@"title"];
    [self.jsonBody setParamValue:self.content forKey:@"content"];
    [self.jsonBody setParamValue:self.address forKey:@"address"];
    [self.jsonBody setParamValue:self.videoId forKey:@"videoId"];
    [self.jsonBody setParamValue:self.imagesUrl forKey:@"imagesUrl"];
    [self.jsonBody setParamValue:self.longitude forKey:@"longitude"];
    [self.jsonBody setParamValue:self.latitude forKey:@"latitude"];
//    if (self.type == DISCOVER_TYPE_IMAGE && self.imagesData) {
//    }
//    else if (self.type == DISCOVER_TYPE_VIDEO && self.videoData) {
//    }
}


@end
