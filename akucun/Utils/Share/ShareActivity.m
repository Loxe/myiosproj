//
//  ShareActivity.m
//  akucun
//
//  Created by Jarry on 2017/4/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ShareActivity.h"
#import "SDImageCache.h"
#import "UIImage+akucun.h"
#import "UserManager.h"

NSString *filePath = @"";

@implementation ShareActivity

+ (void) forwardWithItems:(NSArray *)images
                     text:(NSString *)content
                     data:(NSDictionary *)data
                     type:(NSInteger)type
                   parent:(UIViewController *)parentController
                     view:(UIView *)sourceView
                 finished:(intBlock)finished
                 canceled:(voidBlock)canceled
{
    [SVProgressHUD showWithStatus:nil];
    
    NSMutableArray *imageObjs = [NSMutableArray array];

    NSMutableArray *items = [NSMutableArray array];
    int index = 0;
    for (NSString *url in images) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
        if (!image) {
            [SVProgressHUD showInfoWithStatus:@"商品图片未取到"];
            if (canceled) {
                canceled();
            }
            return;
        }
        
        [imageObjs addObject:image];
        
        if (type != ShareOptionMergedPicture) {
            NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:url];
            WXShareItem *item = [[WXShareItem alloc] initWithImage:image path:path];
            [items addObject:item];
        }
        
        index ++;
    }
   
    if (type != ShareOptionOnlyPictures && content) {
        UIImage *image = nil;
        if (type == ShareOptionPicturesAndText) {
            image = [self imageFromText:content width:320 font:BOLDSYSTEMFONT(16)];
        }
        else if (type == ShareOptionMergedPicture) {
            image = [self imageFromText:content data:data images:imageObjs];
        }
        /*
        UIImage *textImage = [self imageFromText:content];
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/textImage.jpg"];
        [UIImagePNGRepresentation(textImage) writeToFile:path atomically:YES];
         */
        
        if (image) {
            
            NSString *path = [NSHomeDirectory() stringByAppendingString:FORMAT(@"/Documents/%.0f.jpg", [NSDate timeIntervalValue]*1000)];
            filePath = path;
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if ([fileManager fileExistsAtPath:path]) {
//                BOOL success = [fileManager removeItemAtPath:path error:nil];
//                DEBUGLOG(@"delete file : %d", success);
//            }
            [UIImageJPEGRepresentation(image,0.5f) writeToFile:path atomically:YES];
            WXShareItem *imgItem = [[WXShareItem alloc] initWithImage:image path:path];
            [items insertObject:imgItem atIndex:0];
        }
    }
    
    [self forwardItems:items parent:parentController view:sourceView flag:NO finished:finished canceled:canceled];
}

+ (void) forwardWithImages:(NSArray *)images
                    parent:(UIViewController *)parentController
                      view:(UIView *)sourceView
                  finished:(intBlock)finished
                  canceled:(voidBlock)canceled
{
    [SVProgressHUD showWithStatus:nil];
    NSMutableArray *imageObjs = [NSMutableArray array];
    NSMutableArray *items = [NSMutableArray array];
    int index = 0;
    for (NSString *url in images) {
        NSString *imageUrl = url;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        if (!image) {
            imageUrl = FORMAT(@"%@?x-oss-process=image/resize,w_1000,limit_0", url);
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        }
        if (!image) {
            imageUrl = FORMAT(@"%@?x-oss-process=image/resize,w_600,limit_0", url);
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        }
        if (!image) {
            [SVProgressHUD showInfoWithStatus:@"图片未取到"];
            if (canceled) {
                canceled();
            }
            return;
        }
        
        [imageObjs addObject:image];
        
        NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:imageUrl];
        WXShareItem *item = [[WXShareItem alloc] initWithImage:image path:path];
        [items addObject:item];
        
        index ++;
    }
    
    [self forwardItems:items parent:parentController view:sourceView flag:NO finished:finished canceled:canceled];
}

+ (void) forwardWithImage:(UIImage *)image
                   parent:(UIViewController *)parentController
                     view:(UIView *)sourceView
                 finished:(intBlock)finished
                 canceled:(voidBlock)canceled
{
    NSMutableArray *items = [NSMutableArray array];
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/image.jpg"];
    [UIImageJPEGRepresentation(image,1.0f) writeToFile:path atomically:YES];
    
    WXShareItem *imageItem = [[WXShareItem alloc] initWithImage:image path:path];
    [items addObject:imageItem];
    
    [self forwardItems:items parent:parentController view:sourceView flag:NO finished:finished canceled:canceled];
}

+ (void) forwardWithURL:(NSString *)url
                  title:(NSString *)title
                  image:(NSString *)imageUrl
                 parent:(UIViewController *)parentController
                   view:(UIView *)sourceView
               finished:(intBlock)finished
               canceled:(voidBlock)canceled
{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (!image) {
        [SVProgressHUD showInfoWithStatus:@"图片未取到"];
        if (canceled) {
            canceled();
        }
        return;
    }
    NSURL *urlToShare = [NSURL URLWithString:url];
    NSArray *items = @[image, title, urlToShare];
    
    [self forwardItems:items parent:parentController view:sourceView flag:NO finished:finished canceled:canceled];
}

+ (void) forwardItems:(NSArray *)items
               parent:(UIViewController *)parentController
                 view:(UIView *)sourceView
                 flag:(BOOL)flag
             finished:(intBlock)finished
             canceled:(voidBlock)canceled
{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[ UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeAirDrop];
    
    activityVC.completionWithItemsHandler = ^ (UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
    {
//        INFOLOG(@"type == %@\n items == %@\n error == %@", activityType, returnedItems, activityError);
        if (completed) {
            if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
                if (finished) {
                    finished(0);
                }
            }
            else if ([activityType isEqualToString:@"com.tencent.mqq.ShareExtension"]) {
                if (finished) {
                    finished(1);
                }
            }
            else if ([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
                if (finished) {
                    finished(100);
                }
            }
            else {
                if (finished) {
                    finished(2);
                }
            }
        }
        else {
            INFOLOG(@"== Canceled == ");
            if (canceled) {
                canceled();
            }
        }
        if (flag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_SHOW object:nil];
        }
        //
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            BOOL success = [fileManager removeItemAtPath:filePath error:nil];
            DEBUGLOG(@"delete file : %d [%@]", success, filePath);
        }
    };
    
    if (isPad) {
        if (sourceView) {
            activityVC.popoverPresentationController.sourceView = sourceView;
            activityVC.popoverPresentationController.sourceRect = sourceView.bounds;
            activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        }
        else {
            activityVC.popoverPresentationController.sourceView = parentController.view;
            activityVC.popoverPresentationController.sourceRect = parentController.view.bounds;
            activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        }
    }
    [parentController presentViewController:activityVC animated:YES completion:^{
        [SVProgressHUD dismiss];
//        if (flag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORWARD_HIDE object:nil];
//        }
    }];
}

+ (void) forwardVideo:(NSURL *)localUrl
               parent:(UIViewController *)parentController
                 view:(UIView *)sourceView
             finished:(intBlock)finished
             canceled:(voidBlock)canceled
{
    [self forwardItems:@[localUrl] parent:parentController view:sourceView flag:NO finished:finished canceled:canceled];
}

+ (UIImage *) imageFromText:(NSString *)content width:(CGFloat)width font:(UIFont *)font
{
    //
    CGFloat offset = 20.0f;
    CGSize sizeText = [content boundingRectWithSize:CGSizeMake(width-offset*2, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:COLOR_TEXT_DARK}context:nil].size;

    CGSize size = CGSizeMake(sizeText.width+offset, sizeText.height+offset);
    
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [RGBCOLOR(0xF0, 0xF0, 0xF0) set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
//    CGContextSetRGBFillColor(ctx, 200, 200, 200, 1.0f);
//    CGContextSetRGBStrokeColor(ctx, 255, 0, 0, 1.0f);
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    CGRect rect = CGRectMake((size.width-sizeText.width)/2, (size.height-sizeText.height)/2, sizeText.width, sizeText.height);
    
    //绘制文字
    [content drawInRect:rect
         withAttributes:@{ NSFontAttributeName:font,NSForegroundColorAttributeName:COLOR_TEXT_DARK,NSParagraphStyleAttributeName:paragraphStyle}];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *) imageFromText:(NSString *)content data:(NSDictionary *)data images:(NSArray *)images
{
    UIImage *image1 = images[0];
    UIImage *image2 = images[3];
    UIImage *image3 = images[1];
    UIImage *image4 = images[2];
    CGFloat imageWidth =  image1.size.width;
    CGFloat imageHeight = image1.size.height;
    
    CGFloat height = 800*imageHeight/imageWidth;
//    CGFloat height2 = 800*image2.size.height/image2.size.width;
//    if (height < height2) {
//        height = height2;
//    }
    imageHeight = height;
    imageWidth = 800;

    CGFloat offset = kOFFSET_SIZE;
    CGFloat sWidth = (imageWidth - offset) * 0.5f;
//    CGFloat sHeight = sWidth * imageHeight / imageWidth;
    
    CGFloat imageHeight3 = sWidth * image3.size.height / image3.size.width;
    CGFloat imageHeight4 = sWidth * image4.size.height / image4.size.width;
    CGFloat sHeight = MAX(imageHeight3, imageHeight4);
    
    CGRect rect1 = CGRectMake(offset, offset, imageWidth, imageHeight);
    CGFloat factor = image1.size.height / image1.size.width;
    if (factor > 1) {
        CGFloat imageWidth1 = imageHeight / factor;
        rect1 = CGRectMake(offset, offset, imageWidth1, imageHeight);
    }
    else {
        CGFloat imageHeight1 = imageWidth * factor;
        rect1 = CGRectMake(offset, offset, imageWidth, imageHeight1);
    }

    factor = image2.size.height / image2.size.width;
    CGRect rect2 = CGRectZero;
    if (factor > 1) {
        CGFloat imageWidth2 = imageHeight / factor;
        rect2 = CGRectMake(imageWidth+offset*2, offset, imageWidth2, imageHeight);
    }
    else {
        CGFloat imageHeight2 = imageWidth * factor;
        rect2 = CGRectMake(imageWidth+offset*2, offset, imageWidth, imageHeight2);
    }

    CGRect rect3 = CGRectMake(imageWidth+offset*2, imageHeight+offset*2, sWidth, imageHeight3);

    CGRect rect4 = CGRectMake(imageWidth+offset*3+sWidth, imageHeight+offset*2, sWidth, imageHeight4);
    
    //
//    UIImage *textImage = nil;
    UIFont *font = BOLDSYSTEMFONT(40);
    CGRect rect = CGRectMake(offset, imageHeight+offset*2, imageWidth, sHeight);
    CGSize sizeText = [content boundingRectWithSize:CGSizeMake(rect.size.width-offset*2, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:COLOR_TEXT_DARK}context:nil].size;
    CGFloat textY = (rect.size.height-sizeText.height)/2-40;
    if (textY < offset) {
        textY = offset;
    }
    CGRect textRect = CGRectMake(rect.origin.x + offset, rect.origin.y+textY, rect.size.width - offset*2, sizeText.height);
    if (sizeText.height > sHeight-40) {
        font = BOLDSYSTEMFONT(30);
        textRect.origin.y = rect.origin.y+offset;
//        textImage = [self imageFromText:content width:imageWidth font:font];
    }
    
    CGSize size = CGSizeMake(imageWidth*2 + offset*3, imageHeight + sHeight + offset*3);
    UIGraphicsBeginImageContext(size);
    
    [WHITE_COLOR set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));

    //绘制图片
    [image1 drawInRect:rect1];
    [image2 drawInRect:rect2];
    [image3 drawInRect:rect3];
    [image4 drawInRect:rect4];
    
    //边框
    [COLOR_SEPERATOR_LINE set];
    UIRectFrame(CGRectMake(offset, offset, imageWidth, imageHeight));
    UIRectFrame(CGRectMake(imageWidth+offset*2, offset, imageWidth, imageHeight));
    UIRectFrame(CGRectMake(imageWidth+offset*2, imageHeight+offset*2, sWidth, sHeight));
    UIRectFrame(CGRectMake(imageWidth+offset*3+sWidth, imageHeight+offset*2, sWidth, sHeight));
    UIRectFrame(rect);
    
    //绘制文字
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [content drawInRect:textRect
         withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:COLOR_TEXT_DARK,NSParagraphStyleAttributeName:paragraphStyle}];
//    if (textImage) {
//        [RGBCOLOR(0xF0, 0xF0, 0xF0) set];
//        UIRectFill(rect);
//        CGFloat tHeight = imageWidth * textImage.size.height/textImage.size.width;
//        CGRect tRect = CGRectMake(rect.origin.x, rect.origin.y+(rect.size.height-tHeight)/2, imageWidth, tHeight);
//        [textImage drawInRect:tRect];
//    }
//    else {
//    }
    
    if (data) {
        NSInteger price = [data getIntegerValueForKey:@"price"];
        NSInteger diaopai = [data getIntegerValueForKey:@"diaopai"];
        NSString *priceStr = kIntergerToString(price);

        [COLOR_SEPERATOR_LIGHT setFill];
        CGRect priceRect = CGRectMake(offset+1, size.height-offset-81, rect.size.width-2, 80);
        UIRectFill(priceRect);
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:FORMAT(@"活动价  ¥ %@   ", priceStr)];
        NSDictionary * attributes = @{ NSFontAttributeName:BOLDSYSTEMFONT(60),NSForegroundColorAttributeName:RED_COLOR,NSParagraphStyleAttributeName:paragraphStyle };
        [attributeStr setAttributes:attributes range:NSMakeRange(0, attributeStr.length)];
        [attributeStr setAttributes:@{ NSFontAttributeName:BOLDSYSTEMFONT(40),NSForegroundColorAttributeName:RED_COLOR,NSParagraphStyleAttributeName:paragraphStyle }
                              range:NSMakeRange(0,6)];
        
        if (diaopai > 0) {
            NSMutableAttributedString * diaopaiAttr = [[NSMutableAttributedString alloc] initWithString:FORMAT(@"¥%ld ", (long)diaopai)];
            [diaopaiAttr addAttributes:@{ NSForegroundColorAttributeName : LIGHTGRAY_COLOR, NSFontAttributeName : SYSTEMFONT(40),  NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid|NSUnderlineStyleSingle), NSBaselineOffsetAttributeName :  @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName : LIGHTGRAY_COLOR } range:NSMakeRange(0, diaopaiAttr.length)];
            [attributeStr appendAttributedString:diaopaiAttr];
        }
        
        [attributeStr drawInRect:CGRectInset(priceRect, offset, 5)];
    }
    
    CGImageRef mergedImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage, CGRectMake(0, 0, size.width, size.height));
    UIGraphicsEndImageContext();
    
    if (!mergedImg) {
        return nil;
    }
    return [UIImage imageWithCGImage:mergedImg];
}

@end

@implementation WXShareItem

- (instancetype) initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (instancetype) initWithImage:(UIImage *)image path:(NSString *)path
{
    self = [super init];
    if (self) {
        self.image = image;
        self.path = path;
    }
    return self;
}

#pragma mark - UIActivityItemSource

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return self.image;
}

- (id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType
{
    if (self.path) {
        return [NSURL fileURLWithPath:self.path];
    }
    return self.image;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(UIActivityType)activityType
{
    return @"Subjects";
}

@end
