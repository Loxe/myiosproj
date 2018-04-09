//
//  AKCellLayout.h
//  akucun
//
//  Created by Jarry on 2017/4/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LWLayout.h"

@interface AKCellLayout : LWLayout <NSCopying>

@property (nonatomic,assign) CGFloat cellHeight;

- (void) updateData;

@end
