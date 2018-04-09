//
//  OptionsPickerView.h
//  J1ST-Installer
//
//  Created by Jarry on 17/4/13.
//  Copyright © 2017年 Zenin-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionItem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL  isSelected;

@end

@interface OptionsPickerView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *optionsArray;
@property (nonatomic, strong) NSMutableArray *seletedItems;

@property (nonatomic, copy) NSString *otherTitle;
@property (nonatomic, copy) NSString *okTitle;

@property (nonatomic, copy) idBlock completeBolck;

@property (nonatomic, copy) idBlock otherBlock;

+ (void) showWithTitle:(NSString *)title
                option:(NSArray *)option
              selected:(NSString *)item
              competed:(idBlock)completeBolck;

+ (void) showWithTitle:(NSString *)title
               options:(NSArray *)options
              selected:(NSArray *)items
              competed:(idBlock)completeBolck;

+ (void) dismissAll;


- (void) showWithComplete:(idBlock)completeBolck;

- (void) dismiss;

- (void) completeAction;

- (void) otherAction;

@end
