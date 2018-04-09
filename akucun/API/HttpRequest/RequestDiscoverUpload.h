//
//  RequestDiscoverUpload.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "DiscoverData.h"

@interface RequestDiscoverUpload : HttpRequestPOST

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy)   NSString  *title;
@property (nonatomic, copy)   NSString  *content;
@property (nonatomic, copy)   NSString  *address;

//
@property (nonatomic, strong) NSArray *imagesData;

@property (nonatomic, strong) NSData *videoData;

@end
