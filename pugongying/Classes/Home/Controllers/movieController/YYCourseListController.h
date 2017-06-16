//
//  YYCourseListController.h
//  pugongying
//
//  Created by wyy on 16/4/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCategoryModel;

@interface YYCourseListController : UITableViewController
/**
 *  分类课程列表创建方法
 */
- (instancetype)initWithCourseCategoryModel:(YYCourseCategoryModel *)categoryModel andTableViewStyle:(UITableViewStyle)style;
/**
 *  课程搜索列表创建方法
 */
- (instancetype)initWithSearchListWithArray:(NSArray *)modelsArray;

@end
