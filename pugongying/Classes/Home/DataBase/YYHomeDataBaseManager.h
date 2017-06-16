//
//  YYHomeDataBaseManager.h
//  pugongying
//
//  Created by wyy on 16/3/25.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYTeacherModel, YYCourseCommentModel;

@interface YYHomeDataBaseManager : NSObject
+ (instancetype)shareHomeDataBaseManager;
/*----------------------***资讯***------------------------------*/
/**
 *  添加资讯列表
 */
- (void)addNews:(NSArray *)newsArray andNewsTableName:(NSString *)tableName;
/**
 *  获取所有资讯
 */
- (NSArray *)newsListFromTableName:(NSString *)tableName;
/**
 *  删除所有资讯
 */
- (void)removeAllNewsAtTableName:(NSString *)tableName;
/**
 *  根据资讯ID删除一个资讯
 */
- (void)removeNewsWithID:(NSString *)newsIntID andTableName:(NSString *)tableName;
/*----------------------***创业故事***------------------------------*/
/**
 *  添加创业故事列表
 */
- (void)addStorys:(NSArray *)storysArray;
/**
 *  获取所有创业故事
 */
- (NSArray *)storysList;
/**
 *  删除所有创业故事
 */
- (void)removeAllStorys;
/*----------------------***课程***------------------------------*/
/**
 *  添加课程列表
 */
- (void)addCourses:(NSArray *)coursesArray toCourseTable:(NSString *)courseTable;
/**
 *  获取所有课程
 */
- (NSArray *)coursesListFromCourseTable:(NSString *)courseTable;
/**
 *  删除所有课程
 */
- (void)removeAllCoursesAtCourseTable:(NSString *)courseTable;
/**
 *  根据课程ID删除一个课程
 */
- (void)removeCourseWithID:(NSString *)courseID andCourseTable:(NSString *)courseTable;

/***------------------------课程表-----------------------------***/
/**
 *  添加课程列表
 */
- (void)addCourseCatalogueModelsArray:(NSArray *)catalogueArray toTableView:(NSString *)catalogueTable;
/**
 *  获取所有课件列表
 */
- (NSArray *)courseCatalogueListWithCourseID:(NSString *)courseSelectID andCatalogueTable:(NSString *)catalogueTable;
/**
 *  删除某门课程的课件
 */
- (void)removeAllCatalogueWithCourseID:(NSString *)courseDeleteID andCatalogueTable:(NSString *)catalogueTable;

/***----------------------------课程收藏表---------------------------***/
/**
 *  添加课程收藏
 */
- (void)addCourseID:(NSString *)collectCourseID andUserID:(NSString *)collectUserID;
/**
 *  查询课程是否收藏,yes是收藏
 */
- (BOOL)selectCollectWithCourseID:(NSString *)collectCourseID andUserID:(NSString *)collectUserID;
/**
 *  删除一个课程收藏
 */
- (void)removeCollectWithCourseID:(NSString *)collectCourseID andUserID:(NSString *)collectUserID;
/***------------------------讲师表-----------------------------***/
/**
 *  添加一个讲师
 */
- (void)addTeacherModel:(YYTeacherModel *)teacherModel;
/**
 *  获取一个讲师模型
 */
- (YYTeacherModel *)teacherModelWithTeacherID:(NSString *)teacherSelectID;
/***------------------------课程评论表-----------------------------***/
/**
 *  添加课程评论列表
 */
- (void)addCourseCommentModelsArray:(NSArray <YYCourseCommentModel *>*)array;
@end
