//
//  YYCourseHistoryCell.h
//  pugongying
//
//  Created by wyy on 16/5/5.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCollectionCellModel;

@interface YYCourseHistoryCell : UITableViewCell

@property (nonatomic, strong) YYCourseCollectionCellModel *model;

+ (instancetype) courseHistoryCellWithTableView:(UITableView *)tableView;
@end
