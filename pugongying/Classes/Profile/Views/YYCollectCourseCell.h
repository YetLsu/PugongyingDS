//
//  YYCollectCourseCell.h
//  pugongying
//
//  Created by wyy on 16/3/11.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYCollectCourseFrame, YYCollectCourseCell;

@protocol YYCollectCourseCellDelegate <NSObject>

@optional

- (void)cancelCollectCourseBtnClickWithFrame:(YYCollectCourseFrame *)courseFrame;
- (void)seeCourseBtnClickWithFrame:(YYCollectCourseFrame *)courseFrame;
@end

@interface YYCollectCourseCell : UITableViewCell

@property (nonatomic, strong) YYCollectCourseFrame *collectFrame;

@property (nonatomic, weak) id<YYCollectCourseCellDelegate> delegate;
+ (instancetype)collectCourseCellWithTableView:(UITableView *)tableView;
@end
