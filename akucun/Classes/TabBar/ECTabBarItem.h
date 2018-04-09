//
//  ECTabBarItem.h
//  EachingMobile
//
//  Created by Jarry on 15/5/15.
//  Copyright (c) 2015年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZLBadgeImport.h"

@interface ECTabBarItem : UIControl

/**
 * The title displayed by the tab bar item.
 */
@property (nonatomic, copy) NSString *title;

/**
 * Icon Font Text
 */
@property (nonatomic, copy) NSString *iconText;

/**
 * The offset for the rectangle around the tab bar item's title.
 */
@property (nonatomic) UIOffset titlePositionAdjustment;

/**
 * The title attributes dictionary used for tab bar item's unselected state.
 */
@property (copy) NSDictionary *unselectedTitleAttributes;

/**
 * The title attributes dictionary used for tab bar item's selected state.
 */
@property (copy) NSDictionary *selectedTitleAttributes;

/**
 * The offset for the rectangle around the tab bar item's image.
 */
@property (nonatomic) UIOffset imagePositionAdjustment;

@property (nonatomic, assign) NSInteger badgeNumber;

- (void) showBadgeView;
- (void) hideBadgeView;

/**
 * Sets the tab bar item's selected and unselected images.
 */
- (void) setSelectedImage:(NSString *)selectedImage withUnselectedImage:(NSString *)unselectedImage;

@end
