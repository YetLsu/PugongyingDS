//
//  YYShowCircleTableViewController.h
//  pugongying
//
//  Created by wyy on 16/5/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowCircleModel;
@interface YYShowCircleTableViewController : UITableViewController

@property (nonatomic, copy) void (^circleCellClickBlock)(YYShowCircleModel *circleModel);
@end
