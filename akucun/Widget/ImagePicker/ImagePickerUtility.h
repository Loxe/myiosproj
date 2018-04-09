//
//  ImagePickerUtility.h
//  Power-IO
//
//  Created by Jarry on 16/8/25.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  拍照 或 照片读取 工具类
 **/
@interface ImagePickerUtility : NSObject

+ (ImagePickerUtility *) instance;

- (void) showActionSheet:(UIViewController *)controller title:(NSString *)title started:(voidBlock)startBlock completion:(idBlock)completion canceled:(voidBlock)canceled;

- (void) startCamera:(UIViewController *)controller block:(idBlock)block;
- (void) showPhotosAlbum:(UIViewController *)controller block:(idBlock)block;

@end
