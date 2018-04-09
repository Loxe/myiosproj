//
//  MenuView.h
//  akucun
//
//  Created by Jarry on 2017/3/31.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface MenuView : UIView

@property (nonatomic,strong) UIButton* forwardButton;
@property (nonatomic,strong) UIButton* commentButton;
@property (nonatomic,strong) ProductModel* product;

@property (nonatomic,assign) BOOL show;

- (void) clickedMenu;
- (void) menuShow;
- (void) menuHide:(BOOL)animated;

@end
