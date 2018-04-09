//
//  ImagePickerUtility.m
//  Power-IO
//
//  Created by Jarry on 16/8/25.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import "ImagePickerUtility.h"
#import "MMSheetView.h"

@interface ImagePickerUtility () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property   (nonatomic, assign)     UIViewController    *parentController;
@property   (nonatomic, copy)       idBlock         completion;
@property   (nonatomic, copy)       voidBlock       canceled;

@end

@implementation ImagePickerUtility

+ (ImagePickerUtility *) instance
{
    static dispatch_once_t  onceToken;
    static ImagePickerUtility * instance;
    dispatch_once(&onceToken, ^{
        instance = [[ImagePickerUtility alloc] init];
    });
    return instance;
}

- (void) showActionSheet:(UIViewController *)controller title:(NSString *)title started:(voidBlock)startBlock completion:(idBlock)completion canceled:(voidBlock)canceled
{
    self.parentController = controller;
    self.completion = completion;
    self.canceled = canceled;
    
    MMPopupItem *itemCamera = MMItemMake(@"拍 照", MMItemTypeNormal, ^(NSInteger index)
    {
        [self startCamera:self.parentController block:nil];
        if (startBlock) {
            startBlock();
        }
    });
    MMPopupItem *itemPhoto = MMItemMake(@"相册选择", MMItemTypeNormal, ^(NSInteger index)
    {
        [self showPhotosAlbum:self.parentController block:nil];
        if (startBlock) {
            startBlock();
        }
    });
    
    NSMutableArray *items = [NSMutableArray new];
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [items addObject:itemCamera];
    }
    else {
        [items addObject:itemCamera];
        [items addObject:itemPhoto];
    }
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:title items:items];
    [sheetView show];;
    
    /*
    UIActionSheet *actionSheet = nil;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照",nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照",@"相册选择", nil];
    }
    
    [actionSheet showInView:controller.view];*/
}

- (void) startCamera:(UIViewController *)controller block:(idBlock)block
{
    if (block) {
        self.completion = block;
    }
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
        imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imageController.delegate = self;
        imageController.allowsEditing = YES;
        [controller presentViewController:imageController animated:YES completion:nil];
    }
}

- (void) showPhotosAlbum:(UIViewController *)controller block:(idBlock)block
{
    if (block) {
        self.completion = block;
    }
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imageController.delegate = self;
    imageController.allowsEditing = YES;
    [controller presentViewController:imageController animated:YES completion:nil];
}

- (void) dealloc
{
    self.completion = nil;
    self.canceled = nil;
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (image) {
            if (self.completion) {
                self.completion(image);
            }
        }
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.canceled) {
        self.canceled();
    }
}

@end
