//
//  PopupPickerView.h
//  Power-IO
//
//  Created by Jarry on 16/8/25.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import "MMPopupView.h"

@interface PopupPickerView : MMPopupView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *selectedItem;

@property (nonatomic, copy) idBlock   confirmBlock;

- (void)showWithConfirmBlock:(idBlock)block;

@end
