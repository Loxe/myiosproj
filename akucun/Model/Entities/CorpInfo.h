//
//  CorpInfo.h
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface CorpInfo : JTModel

@property (nonatomic, copy) NSString *corpname;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *corplogo;
@property (nonatomic, copy) NSString *descriptioninfo;

@property (nonatomic, copy) NSString *corpattach;

- (NSArray *) imagesUrl;

@end
