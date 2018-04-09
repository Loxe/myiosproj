//
//  NoticeView.h
//  akucun
//
//  Created by Jarry on 2017/4/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeView : UIView

@property (nonatomic, copy) NSString *notice;

- (void) updateNotice:(NSString *)notice
              content:(NSString *)content;

- (void) updateMessage:(NSString *)message;

@end
