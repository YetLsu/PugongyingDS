//
//  YYCourseTableViewCell.h
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCellModel;

@protocol YYCourseCellModelDelegate <NSObject>

@optional
- (void)courseTableViewCellPlayClickWithModel:(YYCourseCellModel *)model;

@end
@interface YYCourseTableViewCell : UITableViewCell

@property (nonatomic, strong) YYCourseCellModel *model;

@property (nonatomic, weak) id<YYCourseCellModelDelegate> delegate;

+ (instancetype)courseTableViewCellWithTableView:(UITableView *)tableView;
@end
