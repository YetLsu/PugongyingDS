//
//  YYCourseCollectionCellModel.h
//  pugongying
//
//  Created by wyy on 16/2/25.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  一门课程的类
 */
@interface YYCourseCollectionCellModel : NSObject
/**
 *  该课程的ID
 */
@property (nonatomic, copy) NSString *courseID;
/**
 *  课程分类
 */
@property (nonatomic, copy) NSString *categoryID;
/**
 *  课程老师ID
 */
@property (nonatomic, copy) NSString *courseTeacherID;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *courseTitle;
/**
 *  课程介绍详情
 */
@property (nonatomic, copy) NSString *courseIntroduce;
/**
 *  分块四个四个显示时的图片
 */
@property (nonatomic, copy) NSString *courseimgurl;
/**
 *  课程信息中顶部的图
 */
@property (nonatomic, copy) NSString *courseShowimgurl;
/**
 *  列表展示图地址
 */
@property (nonatomic, copy) NSString *courseListimgurl;
/**
 *  标签关键词
 */
@property (nonatomic, copy) NSString *courseTags;
/**
 *  学习特色
 */
@property (nonatomic, copy) NSString *coursefFeature;
/**
 *  适合人群
 */
@property (nonatomic, copy) NSString *courseCrowd;
/**
 *  课程节数
 */
@property (nonatomic, copy) NSString *courseSeriesNum;
/**
 *  收藏数
 */
@property (nonatomic, copy) NSString *courseCollectionNum;
/**
 *  评论数
 */
@property (nonatomic, copy) NSString *courseCommentNum;
/**
 *  课程评分
 */
@property (nonatomic, copy) NSString *courseScore;
/**
 *  上次观看课程时的时间
 */
@property (nonatomic, copy) NSString *couseSeeTime;
/**
 *  收藏该课程的用户ID
 */
@property (nonatomic, copy) NSString *userID;


- (instancetype)initWithcourseID:(NSString *)courseID categoryID:(NSString *)categoryID teacherID:(NSString *)teacherID title:(NSString *)title introduce:(NSString *)introduce courseimgurl:(NSString *)courseimgurl showImgurl:(NSString *)showImgurl listImgurl:(NSString *)listImgurl tags:(NSString *)tags feature:(NSString *)feature crowd:(NSString *)crowd seriesNum:(NSString *)seriesNum collectionNum:(NSString *)collectionNum commentNum:(NSString *)commentNum score:(NSString *)score;
@end
