//
//  DBManager.h
//  DBExpr4
//
//  Created by 万延 on 16/4/25.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) FMDatabase *db;

@end
