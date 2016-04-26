//
//  DetailViewController.h
//  DBExpr4
//
//  Created by 万延 on 16/4/26.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintModel.h"

@protocol DetailViewControllerDelegate;
@class FMResultSet;

typedef NS_ENUM(NSUInteger, DetailType){
    DetailTypeNone,
    DetailTypeEdit,
    DetailTypeAdd,
    DetailTypeQuery
};

@interface DetailViewController : UIViewController

- (instancetype)initWithModel:(PrintModel *)model type:(DetailType)type;

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;

@end

@protocol DetailViewControllerDelegate <NSObject>

- (void)successDeal:(DetailType)detailType;
- (void)successQuery:(FMResultSet *)resultSet;

@end
