//
//  PrintModel.h
//  DBExpr4
//
//  Created by 万延 on 16/4/25.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface PrintModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *organ;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger *pagenum;

- (instancetype)initWithResultSet:(FMResultSet *)resultSet;

@end
