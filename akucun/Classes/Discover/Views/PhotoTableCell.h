//
//  PhotoTableCell.h
//  akucun
//
//  Created by deepin do on 2017/11/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentViewController.h"

@interface PhotoTableCell : UITableViewCell

@property(nonatomic, strong) UICollectionView *pictureCollectionView;

@property(nonatomic, assign) PhotoSelectType selectType;

@property(nonatomic, strong) NSMutableArray *selectedArray;

@end
