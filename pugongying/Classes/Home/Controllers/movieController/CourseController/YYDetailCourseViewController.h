//
//  YYDetailCourseViewController.h
//  pugongying
//
//  Created by wyy on 16/5/17.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCollectionCellModel;

@interface YYDetailCourseViewController : UIViewController

@property (nonatomic, weak) UITableView *detailTableView;

- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)courseModel andStyle:(UITableViewStyle)style andFrame:(CGRect)detailTableViewFrame;
@end
