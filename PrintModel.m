//
//  PrintModel.m
//  DBExpr4
//
//  Created by 万延 on 16/4/25.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "PrintModel.h"
#import "FMDB.h"

@implementation PrintModel

- (instancetype)initWithResultSet:(FMResultSet *)resultSet
{
    if(self = [super init])
    {
        self.title = [resultSet objectForColumnName:@"title"];
        self.author = [resultSet objectForColumnName:@"author"];
        self.year = [resultSet objectForColumnName:@"year"];
        self.organ = [resultSet objectForColumnName:@"organ"];
        self.address = [resultSet objectForColumnName:@"address"];
        self.pagenum = [resultSet intForColumn:@"pagenum"];
    }
    
    return self;
}

@end
