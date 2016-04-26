//
//  DetailViewController.h
//  DBExpr4
//
//  Created by 万延 on 16/4/26.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintModel.h"

typedef NS_ENUM(NSUInteger, DetailType){
    DetailTypeNone,
    DetailTypeEdit,
    DetailTypeAdd
};

@interface DetailViewController : UIViewController

- (instancetype)initWithModel:(PrintModel *)model type:(DetailType)type;

@end
