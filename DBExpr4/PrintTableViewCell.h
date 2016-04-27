//
//  PrintTableViewCell.h
//  DBExpr4
//
//  Created by 万延 on 16/4/27.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintModel.h"

@interface PrintTableViewCell : UITableViewCell

- (void)loadModel:(PrintModel *)model;

@property (nonatomic, strong) PrintModel *model;

@end
