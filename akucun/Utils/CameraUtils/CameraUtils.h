//
//  CameraUtils.h
//  akucun
//
//  Created by Jarry on 2017/8/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@import Photos;

@interface CameraUtils : NSObject

+ (BOOL)isCameraDenied;

+ (BOOL)isCameraNotDetermined;

+ (BOOL)isPhotoAlbumDenied;

+ (BOOL)isPhotoAlbumNotDetermined;

@end
