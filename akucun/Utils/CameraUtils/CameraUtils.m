//
//  CameraUtils.m
//  akucun
//
//  Created by Jarry on 2017/8/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CameraUtils.h"

@implementation CameraUtils

+ (BOOL)isCameraDenied
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isCameraNotDetermined
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumDenied
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumNotDetermined
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}

@end
