//
//  YYDetailCourseCell.h
//  pugongying
//
//  Created by wyy on 16/5/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYDetailCourseCellFrame;

@interface YYDetailCourseCell : UITableViewCell

@property (nonatomic, strong) YYDetailCourseCellFrame *modelFrame;

+ (instancetype)detailCourseCellWithTableView:(UITableView *)tableView;
@end
