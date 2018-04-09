//
//  RequestDiscoverUpload.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDiscoverUpload.h"
#import "UserManager.h"

@implementation RequestDiscoverUpload

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_UPLOAD;
}

- (void) initJsonBody
{
    //
    [self.jsonBody setParamValue:[UserManager instance].userId forKey:@"userid"];
    
    [self.jsonBody setParamIntegerValue:self.type forKey:@"type"];
    [self.jsonBody setParamValue:self.title forKey:@"title"];
    [self.jsonBody setParamValue:self.content forKey:@"description"];
    [self.jsonBody setParamValue:self.address forKey:@"address"];

    if (self.type == DISCOVER_TYPE_IMAGE && self.imagesData) {
        int index = 0;
        NSMutableArray *datas = [NSMutableArray array];
        for (NSData *image in self.imagesData) {
            index ++;
            SCUploadData *data = [SCUploadData new];
            data.name = FORMAT(@"%.0f.jpg", [NSDate timeIntervalValue]*1000);
            data.mimeType = @"image/jpg";
            data.param = FORMAT(@"images%02d", index) ;
            data.data = image;
            [datas addObject:data];
        }
        self.datas = datas;
    }
    else if (self.type == DISCOVER_TYPE_VIDEO && self.videoData) {
        
        NSMutableArray *datas = [NSMutableArray array];
        SCUploadData *data = [SCUploadData new];
        data.name = FORMAT(@"%.0f.mp4", [NSDate timeIntervalValue]*1000);
        data.mimeType = @"video/mp4";
        data.param = @"video";
        data.data = self.videoData;
        [datas addObject:data];
        
        if (self.imagesData) {
            SCUploadData *data = [SCUploadData new];
            data.name = FORMAT(@"%.0f.jpg", [NSDate timeIntervalValue]*1000);
            data.mimeType = @"image/jpg";
            data.param = @"images01";
            data.data = self.imagesData[0];
            [datas addObject:data];
        }
        self.datas = datas;
    }    
}

@end
