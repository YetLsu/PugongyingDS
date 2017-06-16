//
//  YYCourseListTableViewCell.h
//  pugongying
//
//  Created by wyy on 16/4/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCollectionCellModel;

@interface YYCourseListTableViewCell : UITableViewCell

@property (nonatomic, strong) YYCourseCollectionCellModel *model;

+ (instancetype)courseListTableViewCellWithTableView:(UITableView *)tableView;
@end
