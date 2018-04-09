//
//  ShareActivity.h
//  akucun
//
//  Created by Jarry on 2017/4/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WXShareItem : NSObject <UIActivityItemSource>

- (instancetype) initWithImage:(UIImage *)image;

- (instancetype) initWithImage:(UIImage *)image path:(NSString *)path;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *path;

@end

@interface ShareActivity : NSObject

+ (void) forwardWithItems:(NSArray *)images
                     text:(NSString *)content
                     data:(NSDictionary *)data
                     type:(NSInteger)type
                   parent:(UIViewController *)parentController
                     view:(UIView *)sourceView
                 finished:(intBlock)finished
                 canceled:(voidBlock)canceled;

+ (void) forwardWithImages:(NSArray *)images
                    parent:(UIViewController *)parentController
                      view:(UIView *)sourceView
                  finished:(intBlock)finished
                  canceled:(voidBlock)canceled;

+ (void) forwardWithImage:(UIImage *)image
                   parent:(UIViewController *)parentController
                     view:(UIView *)sourceView
                 finished:(intBlock)finished
                 canceled:(voidBlock)canceled;

+ (void) forwardWithURL:(NSString *)url
                  title:(NSString *)title
                  image:(NSString *)imageUrl
                 parent:(UIViewController *)parentController
                   view:(UIView *)sourceView
               finished:(intBlock)finished
               canceled:(voidBlock)canceled;

+ (void) forwardVideo:(NSURL *)localUrl
               parent:(UIViewController *)parentController
                 view:(UIView *)sourceView
             finished:(intBlock)finished
             canceled:(voidBlock)canceled;

@end
