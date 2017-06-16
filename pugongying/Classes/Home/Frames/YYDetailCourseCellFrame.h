//
//  YYDetailCourseCellFrame.h
//  pugongying
//
//  Created by wyy on 16/5/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCourseCollectionCellModel, YYTeacherModel;


@interface YYDetailCourseCellFrame : NSObject
/**
 *  讲师模型
 */
@property (nonatomic, strong) YYTeacherModel *teacherModel;
/**
 *  课程模型,请先设置讲师模型
 */
@property (nonatomic, strong) YYCourseCollectionCellModel *courseModel;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat rowHeight;
/**
 *  讲师上面标题的ViewF
 */
@property (nonatomic, assign) CGRect teacherTitleViewF;
/**
 讲师头像F
 */
@property (nonatomic, assign) CGRect iconImageViewF;
/**
 讲师名字F
 */
@property (nonatomic, assign) CGRect nameLabelF;
/**
 讲师介绍F
 */
@property (nonatomic, assign) CGRect introduceLabelF;
/**
 *  中间灰色的ViewF
 */
@property (nonatomic, assign) CGRect grayViewF;
/**
 *  课程上面标题的ViewF
 */
@property (nonatomic, assign) CGRect courseTitleViewF;

/**
 *  课程详情的高度
 */
@property (nonatomic, assign) CGFloat courseIntroH;
@end
