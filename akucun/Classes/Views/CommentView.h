//
//  CommentView.h
//  akucun
//
//  Created by Jarry on 2017/4/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"
//#import "ProductModel.h"

@interface CommentView : UIView

@property (nonatomic, assign) CGFloat offsetHeight;

@property (nonatomic, assign) CGFloat editingBarHeight;

@property (nonatomic, strong) GrowingTextView *editView;

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy) idRangeBlock sendBlock;

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) id object;

- (void) show;

- (void) hide;

@end
