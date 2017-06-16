//
//  YYCollectCourseFrame.h
//  pugongying
//
//  Created by wyy on 16/3/11.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCourseCollectionCellModel;

@interface YYCollectCourseFrame : NSObject

@property (nonatomic, strong) YYCourseCollectionCellModel *model;

/**
 *  单元格高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  课程图片Frame
 */
@property (nonatomic, assign) CGRect courseIconF;
/**
 *  课程标题LabelFrame
 */
@property (nonatomic, assign) CGRect courseTitleF;
/**
 *  课程分类LabelFrame
 */
@property (nonatomic, assign) CGRect courseSortF;
/**
 *  课程播放量LabelFrame
 */
@property (nonatomic, assign) CGRect coursePlayNumberF;
/**
 *  取消收藏课程ButtonFrame
 */
@property (nonatomic, assign) CGRect courseCancelCollectF;
/**
 *  查看课程ButtonFrame
 */
@property (nonatomic, assign) CGRect courseLookF;
@end
