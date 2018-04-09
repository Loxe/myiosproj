//
//  RequestDiscoverUploadNew.h
//  akucun
//
//  Created by deepin do on 2017/12/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestBase.h"


@interface RequestDiscoverUploadNew : HttpRequestPOST

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy)   NSString  *title;
@property (nonatomic, copy)   NSString  *content;
@property (nonatomic, copy)   NSString  *address;
@property (nonatomic, copy)   NSString  *latitude;
@property (nonatomic, copy)   NSString  *longitude;

@property (nonatomic, copy)   NSString  *videoId;
@property (nonatomic, copy)   NSString  *imagesUrl;


@end
