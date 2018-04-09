//
//  VideoServer.m
//  MeckeeperMerchant
//
//  Created by guoguo on 2017/5/15.
//  Copyright © 2017年 KunHong. All rights reserved.
//

#import "VideoServer.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation VideoServer

+ (void)videoData:(id)asset curr:(NSInteger)current videoData:(VideoChangeDataBlock)videoBlock failure:(VideoChangeDataFailureBlock)failure{
    
    NSString *randomName = [NSString stringWithFormat:@"akucun%ld", (long)current];
    if (iOS8Later) { //如果是iOS 8以上
        PHAsset *myAsset = asset;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        [[PHImageManager defaultManager] requestAVAssetForVideo:myAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSURL *fileRUL = [asset valueForKey:@"URL"];
            
//            NSData *beforeVideoData = [NSData dataWithContentsOfURL:fileRUL];//未压缩的视频流
            
            NSString* filename = [NSString stringWithFormat:@"maimaiVide%ld.mp4", (long)current];
            NSString* pathqq = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathqq]) {
                [[NSFileManager defaultManager] removeItemAtPath:pathqq error:nil];
            }
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            
            AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:fileRUL options:nil];
            
            VideoServer *videoServer = [[VideoServer alloc] init];
            [videoServer convertToMP4:urlAsset videoPath:path succ:^(NSString *path) {
                NSData *beforeV = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoServer compressVideo:[NSURL URLWithString:path] andVideoName:randomName andSave:NO successCompress:^(NSData *resultData) {
                        if (resultData == nil || resultData.length == 0 ) {
                            NSLog(@"失败");
                            videoBlock(beforeV);
                        }else{
                            NSLog(@"成功");
                            videoBlock(resultData);
                            
                        }
                    }];
                });
                
            } fail:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(current);
                });
            }];
            
            
        }];
        
    }else{//如果是iOS 8以下获取视频流
        
        NSString* filename = [NSString stringWithFormat:@"akucun998.mp4"];
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];//视频流路径

        
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:rep.url options:nil];
        
        VideoServer *videoServer = [[VideoServer alloc] init];
        [videoServer convertToMP4:urlAsset videoPath:path succ:^(NSString *path) {
//            NSData *beforeV = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [videoServer compressVideo:[NSURL URLWithString:path] andVideoName:randomName andSave:NO successCompress:^(NSData *resultData) {
                    if (resultData == nil || resultData.length == 0 ) {
                        //iOS 8 以下 压缩失败 直接获取未压缩的视频流
                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                        Byte *buffer = (Byte *)malloc(rep.size);
                        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                        NSData *videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                        videoBlock(videoData);
                        
                    }else{
                        //如果压缩成功  就用压缩的上传服务端，但是注意了   这里如果不用异步的，上传的时候程序挂了
                        
                        //ios 8 以下一定必须加入这个再去请求，否则会挂
                        dispatch_async(dispatch_get_main_queue(),^{
                            videoBlock(resultData);
                            
                        });
                    }
                }];
                
            });
            
        } fail:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(current);
            });
        }];
        
        
    }
}

- (void)convertToMP4:(id)video succ:(VonvertSucc)succ fail:(void (^)(void))fail {
    if ([video isKindOfClass:[PHAsset class]]) {
        PHAsset *myAsset = video;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        [[PHImageManager defaultManager] requestAVAssetForVideo:myAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSURL *fileRUL = [asset valueForKey:@"URL"];
            
            NSString* filename = [NSString stringWithFormat:@"akucun_chat.mp4"];
            NSString* pathqq = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathqq]) {
                [[NSFileManager defaultManager] removeItemAtPath:pathqq error:nil];
            }
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            
            
            AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:fileRUL options:nil];
            
            [self convertToMP4:urlAsset videoPath:path succ:^(NSString *path) {
                succ(path);
            } fail:^{
                fail();
            }];
        }];
    } else if ([video isKindOfClass:[NSString class]]) {
        
        NSURL *fileRUL = [NSURL URLWithString:video];
        NSString* filename = [NSString stringWithFormat:@"akucun_chat.mp4"];
        NSString* pathqq = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathqq]) {
            [[NSFileManager defaultManager] removeItemAtPath:pathqq error:nil];
        }
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:fileRUL options:nil];
        
        [self convertToMP4:urlAsset videoPath:path succ:^(NSString *path) {
            succ(path);
        } fail:^{
            fail();
        }];
        
    }
}

- (void)convertToMP4:(AVURLAsset*)avAsset videoPath:(NSString*)videoPath succ:(VonvertSucc)succ fail:(void (^)(void))fail
{
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        CMTime start = CMTimeMakeWithSeconds(0, avAsset.duration.timescale);
        
        CMTime duration = avAsset.duration;
        
        CMTimeRange range = CMTimeRangeMake(start, duration);
        
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status])
            {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    if (fail)
                    {
                        fail();
                    }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    if (fail)
                    {
                        fail();
                    }
                    break;
                default:
                    if (succ)
                    {
                        succ([exportSession.outputURL absoluteString]);
                    }
                    break;
            }
        }];
    }
}


/**
 *  传入视频原URL，压缩视频
 *  @param path 视频原URL
 *  @param name 视频前缀名字
 *  @param needSave 是否需要保存到本地
 *  @param compressHandle 压缩后的回调
 */
- (void)compressVideoWithSourcePath:(NSURL *)path andVideoSavePrefixName:(NSString *)name ifNeedSaveLocal:(BOOL)needSave CompressHandle:(void (^)(NSData *, BOOL, CGFloat))compressHandle {
    
    // 赋值视频文件名字
    self.videoName = name;
    
    // 先删除旧的同名文件
    [self deleteFileWithName:name];
    
    // 初始化
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil];
    NSArray    *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    AVAssetExportSession *exportSession;
    
    // 根据视频原文件信息，设置压缩分辨率
    if ([presets containsObject:AVAssetExportPresetHighestQuality]) {
        exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    } else if ([presets containsObject:AVAssetExportPresetMediumQuality]) {
        exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
    } else {
    }
    
    // 设置压缩后视频流导出的路径
    exportSession.outputURL = [self compressedURL];
    // 优化网络
    exportSession.shouldOptimizeForNetworkUse = YES;
    // 输出格式
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    // 异步导出
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus compressStatus = [exportSession status];

        // 导出的状态
        if (compressStatus == AVAssetExportSessionStatusCompleted) { // 完成
            // 当前视频文件存储路径
            NSURL *compressedPath = [self compressedURL];

            // 压缩后视频文件大小
            CGFloat compressedSize = [self fileSize:compressedPath];
            
            if (needSave) {
                [self saveVideo:compressedPath];
            }
            NSLog(@"导出成功，状态 %ld, 当前视频大小 %f MB",(long)compressStatus,compressedSize);
            NSData *compressedData = [NSData dataWithContentsOfURL:compressedPath];
            if (compressedData.length > 0) {
                compressHandle(compressedData,YES,compressedSize);
            } else {
                compressHandle(nil,YES,compressedSize);
            }
        } else { // 未完成（Unknown/Waiting/Exporting/Failed/Cancelled）
            NSLog(@"导出失败，状态 %ld",(long)compressStatus);
            compressHandle(nil,NO,0.0);
        }
    }];
    
}

//压缩视频
- (void)compressVideo:(NSURL *)path andVideoName:(NSString *)name andSave:(BOOL)saveState successCompress:(void(^)(NSData *))successCompress  //saveState 是否保存视频到相册
{
    self.videoName = name;
    
    // 先删除旧的同名文件
    [self deleteFileWithName:name];
    
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    AVAssetExportSession *exportSession;
    
//    if (@available(iOS 11.0, *)) {
//        if ([compatiblePresets containsObject:AVAssetExportPresetHEVCHighestQuality]) {
//            NSLog(@"ios 11");
//            exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
//        }
//    } else {
    
    //设置分辨率
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    } else if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
    } else {
    }

    exportSession.outputURL = [self compressedURL];//设置压缩后视频流导出的路径
    exportSession.shouldOptimizeForNetworkUse = true;
    //转换后的格式
    exportSession.outputFileType = AVFileTypeMPEG4;
    //异步导出
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"导出的状态 %ld",(long)[exportSession status]);
        // 如果导出的状态为完成
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"视频压缩成功,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
            if (saveState) {
                [self saveVideo:[self compressedURL]];//保存视频到相册
            }
            //压缩成功视频流回调回去
            successCompress([NSData dataWithContentsOfURL:[self compressedURL]].length > 0?[NSData dataWithContentsOfURL:[self compressedURL]]:nil);
        }else{
            //压缩失败的回调
            NSLog(@"视频压缩失败,大小 %f MB",[self fileSize:[self compressedURL]]);
            successCompress(nil);
        }
    }];
}


/**
 *  通过视频的URL，获得视频缩略图
 *  @param url 视频URL
 *  @return首帧缩略图
 */
#pragma mark 获取视频的首帧缩略图
- (UIImage *)imageWithVideoURL:(NSURL *)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    // 根据asset构造一张图
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
    generator.appliesPreferredTrackTransform = YES;
    // 设置图片的最大size(分辨率)
    generator.maximumSize = CGSizeMake(600, 450);
    NSError *error = nil;
    // 根据时间，获得第N帧的图片
    // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10000) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}


// 专为删除mp4视频
-(void) deleteFileWithName: (NSString *)fileName {
    NSFileManager* fileManager = [NSFileManager defaultManager];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *file = [NSString stringWithFormat:@"%@.mp4",fileName];
    NSString *uniquePath = [path stringByAppendingPathComponent:file];
    //文件名
//    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"%@.mp4",fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.videoName]];
    //    NSLog(@"之前保存的路径 %@",path);
    return [NSURL fileURLWithPath:path];
}

#pragma mark 计算视频大小
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

#pragma mark 保存视频到相册
- (void)saveVideo:(NSURL *)outputFileURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            //NSLog(@"保存视频失败:%@",error);
        } else {
            //NSLog(@"保存视频到相册成功");
        }
    }];
}


@end
