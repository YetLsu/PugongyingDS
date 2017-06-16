//
//  YYCourseCommentCell.h
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYCourseCommentFrame;

@interface YYCourseCommentCell : UITableViewCell

@property (nonatomic, strong)YYCourseCommentFrame *modelFrame;

+ (instancetype)courseCellWithTableView:(UITableView *)tableView;
@end
