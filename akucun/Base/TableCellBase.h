//
//  TableCellBase.h
//  J1ST-System
//
//  Created by Jarry on 16/11/30.
//  Copyright © 2016年 Zenin-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCellBase : UITableViewCell

@property (nonatomic, assign) BOOL showSeperator;

@property (nonatomic, assign) BOOL selectionDisabled;

@property (nonatomic, assign) BOOL isSubcellStyle;

@property (nonatomic, strong) UIView *seperatorLine;

@end
