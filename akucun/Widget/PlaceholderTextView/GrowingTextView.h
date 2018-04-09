//
//  GrowingTextView.h
//  iosapp
//
//  Created by Jarry on 11/17/14.
//  Copyright (c) 2014 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface GrowingTextView : PlaceholderTextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, readonly) CGFloat maxHeight;

- (instancetype) initWithPlaceholder:(NSString *)placeholder;

- (CGFloat) measureHeight;


@end
