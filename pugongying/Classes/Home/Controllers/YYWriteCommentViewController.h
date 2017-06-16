//
//  YYWriteCommentViewController.h
//  pugongying
//
//  Created by wyy on 16/3/14.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYInformationModel, YYCourseCollectionCellModel;

@interface YYWriteCommentViewController : UIViewController
/**
 *  创建资讯的评论
 */
- (instancetype) initWithInformationCommentControllerWithModel:(YYInformationModel *)model;
/**
 *  创建课程的评论
 */
- (instancetype) initWithCourseCommentControllerWithModel:(YYCourseCollectionCellModel *)model;
/**
 *  创建意见反馈的控制器
 */
- (instancetype)initWithOpinion;
@end
