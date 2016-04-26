//
//  DBManager.m
//  DBExpr4
//
//  Created by 万延 on 16/4/25.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

+ (instancetype)sharedInstance
{
    static DBManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBManager alloc] init];
        NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
        NSString *fileName = [doc stringByAppendingPathComponent:@"student.sqlite"];
        FMDatabase *db = [FMDatabase databaseWithPath:fileName];
        if(![db open])
        {
            NSLog(@"open DB error");
        }
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS print (title varchar(80), author varchar(20), year varchar(5), organ varchar(20), address varchar(20), pagenum int, primary key (title, author));"];
        NSLog(@"%d", result);
        instance.db = db;
    });
    return instance;
}

@end
