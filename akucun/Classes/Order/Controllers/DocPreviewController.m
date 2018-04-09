//
//  DocPreviewController.m
//  akucun
//
//  Created by Jarry on 2017/5/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "DocPreviewController.h"
#import <QuickLook/QuickLook.h>

@interface DocPreviewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) QLPreviewController *previewController;

@end

@implementation DocPreviewController

- (void) setupContent
{
    [super setupContent];
    self.view.backgroundColor = RGBCOLOR(0xF0, 0xF0, 0xF0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"对账单预览";
    
//    self.url = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"xlsx"];

    _previewController = [[QLPreviewController alloc] init];
    _previewController.dataSource = self;
    _previewController.delegate = self;
    _previewController.view.frame = self.view.frame;
//    [self addChildViewController:self.previewController];
    [self.view addSubview:self.previewController.view];
    
    [_previewController didMoveToParentViewController:self];
}

#pragma mark - QLPreviewControllerDataSource, QLPreviewControllerDelegate

- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>) previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    if (self.url && self.url.length > 0) {
//        return [NSURL fileURLWithPath:self.url];
        return [NSURL URLWithString:self.url];
    }
    
    return nil;
}

@end
