//
//  TextButton.h
//  J1ST-System
//
//  Created by Jarry on 16/11/25.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextButton : UIButton

@property (nonatomic, assign) BOOL showImage;
@property (nonatomic, assign) CGFloat imageSize;

- (void) setTitleFont:(UIFont *)font;

- (void) setTitleAlignment:(NSTextAlignment)textAlignment;

@end
