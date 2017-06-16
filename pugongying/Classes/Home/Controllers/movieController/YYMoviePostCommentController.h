//
//  YYMoviePostCommentController.h
//  pugongying
//
//  Created by wyy on 16/4/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCollectionCellModel;

@interface YYMoviePostCommentController : UIViewController
/**
 *  创建课程的评论
 */
- (instancetype) initWithCourseCommentControllerWithModel:(YYCourseCollectionCellModel *)model;
@end
