//
//  DiscoverCellLayout.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AKCellLayout.h"
#import "DiscoverData.h"

@interface DiscoverCellLayout : AKCellLayout

@property (nonatomic,strong) DiscoverData* dataModel;

@property (nonatomic,strong) NSArray* imagePostions;

@property (nonatomic,assign) CGFloat titleTop;
@property (nonatomic,assign) CGFloat imageBottom;

@property (nonatomic,assign) BOOL isOpened;

- (id) initWithModel:(DiscoverData *)model isOpened:(BOOL)opened;

@end
