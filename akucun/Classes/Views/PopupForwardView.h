//
//  PopupForwardView.h
//  akucun
//
//  Created by Jarry on 2017/5/14.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "MMPopupView.h"
#import "ProductModel.h"

typedef void (^forwardBlock)(id content, BOOL check1, BOOL check2);

/**
 一键转发商品 弹出框
 */
@interface PopupForwardView : MMPopupView

@property (nonatomic, strong) ProductModel *product;

//@property (nonatomic, copy) MMPopupCompletionBlock cancelBlock;
@property (nonatomic, copy) forwardBlock finishBlock;

@property (nonatomic, copy) voidBlock settingBlock;


- (instancetype) initWithProduct:(ProductModel *)product title:(NSString *)title;

- (void) showNext;

@end
