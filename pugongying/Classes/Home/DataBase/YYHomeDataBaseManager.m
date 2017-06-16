//
//  YYHomeDataBaseManager.m
//  pugongying
//
//  Created by wyy on 16/3/25.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYHomeDataBaseManager.h"
/**
 *  资讯
 */
#import "YYInformationModel.h"
/**
 *  创业故事（'人物刊','企业刊 '）
 */
#import "YYMagazineModel.h"
/**
 *  课程
 */
#import "YYCourseCollectionCellModel.h"
/**
 *  课件模型
 */
#import "YYCourseCellModel.h"
/**
 *  讲师模型
 */
#import "YYTeacherModel.h"
/**
 *  课程评论模型
 */
#import "YYCourseCommentModel.h"

@interface YYHomeDataBaseManager (){
    
}

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation YYHomeDataBaseManager

- (FMDatabaseQueue *)queue{
    if (!_queue) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachePath stringByAppendingPathComponent:@"home.sqlite"];
        YYLog(@"数据库路径:%@",path);
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _queue;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static YYHomeDataBaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        
    });
    return manager;
}
+ (instancetype)shareHomeDataBaseManager{
    return [[self alloc] init];
}
- (instancetype) init{
    if (self = [super init]) {
        //创建资讯表单
        [self createNewsTableWithTableName:newsTable];
        [self createNewsTableWithTableName:newsRecommendTable];
        [self createNewsTableWithTableName:newsCollectTable];
        //创建创业故事表
        [self createStoryTable];
        //创建课程表
        [self createCoursesTableWithCorseTable:coursesCollectionTable];
        [self createCoursesTableWithCorseTable:coursesHistoryTable];
        [self createCoursesTableWithCorseTable:coursesAllListTable];
        [self createCoursesTableWithCorseTable:coursesCollectTable];
        [self createCoursesTableWithCorseTable:coursesRecommendTable];
        //创建课件表
        [self createCatalogueTableWithTableName:catalogueTable];
        //创建课程收藏表
        [self createcollectCourseYesTable];
        //创建讲师表
        [self createteacherTable];
    }
    return self;
}
#pragma mark 资讯
/*----------------------***资讯表单***------------------------------*/
/*----------------------***资讯表存储字段***------------------------------*/

NSString *newsTable                   = @"t_newsTable";                    //资讯表名
NSString *newsRecommendTable          = @"t_newsRecommendTable";           //资讯推荐表名
NSString *newsCollectTable            = @"t_newsCollectTable";             //资讯收藏表名

NSString *userNewsID                  = @"userNewsID";                     //资讯用户id
NSString *newsID                      = @"newsID";                         //资讯id
NSString *newsCategoryID              = @"newsCategoryID";                 //分类id
NSString *newsTitle                   = @"newsTitle";                      //标题
NSString *newsIntroduce               = @"newsIntroduce";                  //简介
NSString *newsShowImgUrl              = @"newsShowImgUrl";                 //展示图地址
NSString *newsWebUrl                  = @"newsWebUrl";                     //网页链接
NSString *newsCommentNum              = @"newsCommentNum";                 //评论数
NSString *newsCollectionNum           = @"newsCollectionNum";              //收藏数
NSString *newsSharenum                = @"newsSharenum";                   //分享数
NSString *newsCreateTime              = @"newsCreateTime";                 //创建时间
NSString *newsRecommend               = @"newsRecommend";                  //是否推荐，0不推荐，1推荐
/**
 *  创建资讯表单
 */
- (void)createNewsTableWithTableName:(NSString *)tableName{
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT,%@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text)", tableName, userNewsID, newsID, newsCategoryID, newsTitle, newsIntroduce, newsShowImgUrl, newsWebUrl, newsCommentNum, newsCollectionNum, newsSharenum, newsCreateTime,newsRecommend];
        
        if (![db executeUpdate:sqlStr]) {
            YYLog(@"不能创建资讯表%@",[db lastErrorMessage]);
        }
    }];

}
/**
 *  添加资讯列表
 */
- (void)addNews:(NSArray *)newsArray andNewsTableName:(NSString *)tableName{
    
    [newsArray enumerateObjectsUsingBlock:^(YYInformationModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", tableName, userNewsID, newsID, newsCategoryID, newsTitle, newsIntroduce, newsShowImgUrl, newsWebUrl, newsCommentNum, newsCollectionNum, newsSharenum, newsCreateTime, newsRecommend];
            
            if (![db executeUpdate:insertSql,model.userID, model.newsID, model.categoryid, model.title, model.intro, model.showimgurl, model.weburl, model.commentnum, model.collectionnum, model.sharenum, model.createTime,model.recommend]) {
                YYLog(@"插入资讯数据失败%@",[db lastErrorMessage]);
            }
        }];
    }];
}
/**
 *  获取所有资讯
 */
- (NSArray *)newsListFromTableName:(NSString *)tableName{
    NSMutableArray *array = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        if ([db hadError]) {
            YYLog(@"获取资讯数据失败%@", [db lastErrorMessage]);
        }
        else{
            while ([resultSet next]) {
  
                NSString *newsID1                      = [resultSet stringForColumn:newsID];                       //资讯id
                NSString *newsCategoryID1              = [resultSet stringForColumn:newsCategoryID];               //分类id
                NSString *newsTitle1                   = [resultSet stringForColumn:newsTitle];                    //标题
                NSString *newsIntroduce1               = [resultSet stringForColumn:newsIntroduce];                //简介
                NSString *newsShowImgUrl1              = [resultSet stringForColumn:newsShowImgUrl];               //展示图地址
                NSString *newsWebUrl1                  = [resultSet stringForColumn:newsWebUrl];                   //网页链接
                NSString *newsCommentNum1              = [resultSet stringForColumn:newsCommentNum];               //评论数
                NSString *newsCollectionNum1           = [resultSet stringForColumn:newsCollectionNum];            //收藏数
                NSString *newsSharenum1                = [resultSet stringForColumn:newsSharenum];                 //分享数
                NSString *newsCreateTime1              = [resultSet stringForColumn:newsCreateTime];               //创建时间
                NSString *newsRecommend1               = [resultSet stringForColumn:newsRecommend];       //是否推荐，0不推荐，1推荐
                NSString *userID1                      = [resultSet stringForColumn:userNewsID];
                
                YYInformationModel *model = [[YYInformationModel alloc] initWithID:newsID1 categoryid:newsCategoryID1 title:newsTitle1 intro:newsIntroduce1 showimgurl:newsShowImgUrl1 weburl:newsWebUrl1 commentnum:newsCommentNum1 collectionnum:newsCollectionNum1 sharenum:newsSharenum1 createTime:newsCreateTime1 recommend:newsRecommend1];
                
                model.userID = userID1;
                [array addObject:model];
            }
        }
    }];
    
    return array;
}
/**
 *  删除所有资讯
 */
- (void)removeAllNewsAtTableName:(NSString *)tableName{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *cleanSql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        
        NSString *sequenceSql = [NSString stringWithFormat:@"UPDATE sqlite_sequence set seq=0 where name='%@'",tableName];
        [db executeUpdate:sequenceSql];
    
        if (![db executeUpdate:cleanSql]) {
            YYLog(@"删除所有资讯失败:%@",[db lastErrorMessage]);
        }
    }];
}
/**
 *  根据资讯ID删除一个资讯
 */
- (void)removeNewsWithID:(NSString *)newsIntID andTableName:(NSString *)tableName{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       NSString *removeSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@",tableName, newsID, newsIntID];
        
        if (![db executeUpdate:removeSql]) {
            YYLog(@"删除单个资讯失败:%@",[db lastErrorMessage]);
        }
        
    }];
}
#pragma mark 创业故事
/*----------------------***创业故事***------------------------------*/
/*----------------------***创业故事表存储字段***------------------------------*/
NSString *magazineTable                     = @"t_magazineTable";               //创业故事表名

NSString *magazineID                        = @"magazineID";                    //期刊ID
NSString *magazineCategory                  = @"magazineCategory";              //分类（'人物刊','企业刊 '）
NSString *magazineTitle                     = @"magazineTitle";                 //标题
NSString *magazineIntro                     = @"magazineIntro";                 //简介
NSString *magazineShowimgurl                = @"magazineShowimgurl";            //展示图地址
NSString *magazineWebUrl                    = @"magazineWebUrl";                //网页链接
NSString *magazineVisitNum                  = @"magazineVisitNum";              //访问人次数
NSString *magazineShareNum                  = @"magazineShareNum";              //分享数


/**
 *  创建创业故事表
 */
- (void)createStoryTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text)",magazineTable, magazineID, magazineCategory, magazineTitle, magazineIntro, magazineShowimgurl, magazineWebUrl, magazineVisitNum, magazineShareNum];
        if (![db executeUpdate:createSql]) {
            YYLog(@"不能创建创业故事表%@",[db lastErrorMessage]);
        }
    }];
}
/**
 *  添加创业故事列表
 */
- (void)addStorys:(NSArray *)storysArray{
    for (YYMagazineModel *model in storysArray) {
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",magazineTable, magazineID, magazineCategory, magazineTitle, magazineIntro, magazineShowimgurl, magazineWebUrl, magazineVisitNum, magazineShareNum];
            if (![db executeUpdate:insertSql, model.magazineID, model.magazineCategory, model.magazineTitle, model.magazineIntro, model.magazineShowimgurl, model.magazineWebUrl, model.magazineVisitNum, model.magazineShareNum]) {
                YYLog(@"插入创业故事数据失败%@",[db lastErrorMessage]);
            }
        }];
    }
}
/**
 *  获取所有创业故事
 */
- (NSArray *)storysList{
    NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@", magazineTable];
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        
        if ([db hadError]) {
            YYLog(@"获取创业故事数据失败%@", [db lastErrorMessage]);
        }
        else{
            while ([resultSet next]) {
                
                NSString *magazineID1           = [resultSet stringForColumn:magazineID];           //期刊ID
                NSString *magazineCategory1     = [resultSet stringForColumn:magazineCategory];     //分类（'人物刊','企业刊 '）
                NSString *magazineTitle1        = [resultSet stringForColumn:magazineTitle];        //标题
                NSString *magazineIntro1        = [resultSet stringForColumn:magazineIntro];        //简介
                NSString *magazineShowimgurl1   = [resultSet stringForColumn:magazineShowimgurl];   //展示图地址
                NSString *magazineWebUrl1       = [resultSet stringForColumn:magazineWebUrl];       //网页链接
                NSString *magazineVisitNum1     = [resultSet stringForColumn:magazineVisitNum];     //访问人次数
                NSString *magazineShareNum1     = [resultSet stringForColumn:magazineShareNum];     //分享数
                
                YYMagazineModel *model = [[YYMagazineModel alloc] initWithID:magazineID1 category:magazineCategory1 title:magazineTitle1 intro:magazineIntro1 showimgurl:magazineShowimgurl1 weburl:magazineWebUrl1 visitnum:magazineVisitNum1 sharenum:magazineShareNum1];
                [array addObject:model];
            }
        }
    }];
    return array;
}
/**
 *  删除所有创业故事
 */
- (void)removeAllStorys{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *cleanSql = [NSString stringWithFormat:@"DELETE FROM %@", magazineTable];
        
        [db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='t_storyTable'"];
        if (![db executeUpdate:cleanSql]) {
            YYLog(@"删除所有创业故事失败:%@",[db lastErrorMessage]);
        }
    }];
}

#pragma mark 课程表
/*----------------------***课程***------------------------------*/
/*----------------------***课程表存储字段***------------------------------*/
NSString *coursesCollectionTable                 = @"t_coursesCollectionTable";                 //课程视频展示界面表名
NSString *coursesHistoryTable                    = @"coursesHistoryTable";                      //课程历史列表
NSString *coursesAllListTable                    = @"coursesAllListTable";                      //课程所有列表
NSString *coursesCollectTable                    = @"t_coursesCollectTable";                    //课程收藏列表
NSString *coursesRecommendTable                  = @"t_coursesRecommendTable";                  //课程推荐列表

NSString *userCourseID                 = @"userCourseID";                   //课程时用户ID
NSString *courseID                     = @"courseID";                       //该课程的ID
NSString *categoryID                   = @"categoryID";                     //课程分类ID
NSString *courseTeacherID              = @"courseTeacherID";                //课程老师ID
NSString *courseTitle                  = @"courseTitle";                    //课程名字
NSString *courseIntroduce              = @"courseIntroduce";                //课程介绍详情
NSString *courseImg                    = @"courseImg";                      //分块四个四个显示时的图片
NSString *courseShowImg                = @"courseShowImg";                  //课程信息中顶部的图
NSString *courseListImg                = @"courseListImg";                  //列表展示图地址
NSString *courseTags                   = @"courseTags";                     //标签关键词
NSString *coursefFeature               = @"coursefFeature";                 //学习特色
NSString *courseCrowd                  = @"courseCrowd";                    //适合人群
NSString *courseSeriesNum              = @"courseSeriesNum";                //课程节数
NSString *courseCollectionNum          = @"courseCollectionNum";            //课程收藏数量
NSString *courseCommentNum             = @"courseCommentNum";               //课程评论数量
NSString *courseScore                  = @"courseScore";                    //课程评分
NSString *couseSeeTime                 = @"couseSeeTime";                   //上次观看的时间

/**
 *  创建课程表
 */
- (void)createCoursesTableWithCorseTable:(NSString *)courseTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text)", courseTable, userCourseID, courseID, categoryID, courseTeacherID, courseTitle, courseIntroduce, courseImg, courseShowImg, courseListImg, courseTags, coursefFeature, courseCrowd, courseSeriesNum, courseCollectionNum, courseCommentNum, courseScore, couseSeeTime];
        
        if (![db executeUpdate:createSql]) {
            YYLog(@"不能创建课程表%@",[db lastErrorMessage]);
        }
    }];
}
/**
 *  添加课程列表
 */
- (void)addCourses:(NSArray *)coursesArray toCourseTable:(NSString *)courseTable{
    
    
    for (YYCourseCollectionCellModel *model in coursesArray) {
        //先查询该课程是否存在
        YYCourseCollectionCellModel *tempModel = [self selectCourseWithID:model.courseID withCourseTable:courseTable];
        if (tempModel) {
            [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %@ WHERE %@ = %@",courseTable, couseSeeTime, model.couseSeeTime, courseID, model.courseID];
                if (![db executeUpdate:updateSql]) {
                    YYLog(@"修改数据失败%@", [db lastErrorMessage]);
                }
            }];
            continue;
        }
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@ ,%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", courseTable, userCourseID, courseID, categoryID, courseTeacherID, courseTitle, courseIntroduce, courseImg, courseShowImg, courseListImg, courseTags, coursefFeature, courseCrowd, courseSeriesNum, courseCollectionNum, courseCommentNum, courseScore,couseSeeTime];
            
            if (![db executeUpdate:insertSql, model.userID, model.courseID, model.categoryID, model.courseTeacherID, model.courseTitle, model.courseIntroduce, model.courseimgurl, model.courseShowimgurl, model.courseListimgurl, model.courseTags, model.coursefFeature, model.courseCrowd, model.courseSeriesNum, model.courseCollectionNum, model.courseCommentNum, model.courseScore, model.couseSeeTime]) {
                YYLog(@"插入课程数据失败%@",[db lastErrorMessage]);
            }
            
        }];
    }
}
/**
 *  获取所有课程
 */
- (NSArray *)coursesListFromCourseTable:(NSString *)courseTable{

    NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = nil;
        if ([courseTable isEqualToString:coursesHistoryTable]) {
            selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ order by couseSeeTime desc", courseTable];
        }
        else{
            selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ order by id asc", courseTable];
        }
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        
        if ([db hadError]) {
            YYLog(@"获取课程数据失败%@", [db lastErrorMessage]);
        }
        else{
            while ([resultSet next]) {
                YYCourseCollectionCellModel *model = [self analysisDataToModelWIthResultSet:resultSet];
                [array addObject:model];
            }
        }
    }];
    
    return array;
}
/**
 *  删除所有课程
 */
- (void)removeAllCoursesAtCourseTable:(NSString *)courseTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *cleanSql = [NSString stringWithFormat:@"DELETE FROM %@", courseTable];
        
        //清空序号
        NSString *sequenceSql = [NSString stringWithFormat:@"UPDATE sqlite_sequence set seq=0 where name='%@'",courseTable];
        [db executeUpdate:sequenceSql];
//        [db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='t_coursesTable'"];
        if (![db executeUpdate:cleanSql]) {
            YYLog(@"删除所有课程数据失败:%@",[db lastErrorMessage]);
        }
    }];
}
/**
 *  根据课程ID删除一个课程
 */
- (void)removeCourseWithID:(NSString *)courseDeleteID andCourseTable:(NSString *)courseTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *removeSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@",courseTable, courseID, courseDeleteID];
        
        if (![db executeUpdate:removeSql]) {
            YYLog(@"删除单个课程失败:%@",[db lastErrorMessage]);
        }
        
    }];
}

/**
 *  根据课程ID查询一个课程
 */
- (YYCourseCollectionCellModel *)selectCourseWithID:(NSString *)courseSelectID withCourseTable:(NSString *)courseTable{
    
    NSMutableArray *array = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@", courseTable, courseID, courseSelectID];
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        
        if ([db hadError]) {
            YYLog(@"获取课程数据失败%@", [db lastErrorMessage]);
        }
        else{
            while ([resultSet next]) {
                YYCourseCollectionCellModel *model = [self analysisDataToModelWIthResultSet:resultSet];
                [array addObject:model];
            }
        }
    }];
    if (array.count == 0) {
        return nil;
    }
    return [array firstObject];
}
/**
 *  解析获取到的课程转换成模型
 */
- (YYCourseCollectionCellModel *)analysisDataToModelWIthResultSet:(FMResultSet *)resultSet{
    NSString *courseID1                     = [resultSet stringForColumn:courseID];            //该课程的ID
    NSString *categoryID1                   = [resultSet stringForColumn:categoryID];          //课程分类ID
    NSString *courseTeacherID11             = [resultSet stringForColumn:courseTeacherID];     //课程老师ID
    NSString *courseTitle1                  = [resultSet stringForColumn:courseTitle];         //课程名字
    NSString *courseIntroduce1              = [resultSet stringForColumn:courseIntroduce];     //课程介绍详情
    NSString *courseImg1                    = [resultSet stringForColumn:courseImg];      //分块四个四个显示时的图片
    NSString *courseShowImg1                = [resultSet stringForColumn:courseShowImg];    //课程信息中顶部的图
    NSString *courseListImg1                = [resultSet stringForColumn:courseListImg];       //列表展示图地址
    NSString *courseTags1                   = [resultSet stringForColumn:courseTags];          //标签关键词
    NSString *coursefFeature1               = [resultSet stringForColumn:coursefFeature];      //学习特色
    NSString *courseCrowd1                  = [resultSet stringForColumn:courseCrowd];         //适合人群
    NSString *courseSeriesNum1              = [resultSet stringForColumn:courseSeriesNum];     //课程节数
    NSString *courseCollectionNum1          = [resultSet stringForColumn:courseCollectionNum]; //课程收藏数量
    NSString *courseCommentNum1             = [resultSet stringForColumn:courseCommentNum];    //课程评论数量
    NSString *courseScore1                  = [resultSet stringForColumn:courseScore];         //课程评分
    NSString *couseSeeTime1                 = [resultSet stringForColumn:couseSeeTime];        //上次观看的时间
    NSString *userID1                       = [resultSet stringForColumn:userCourseID];
    
    YYCourseCollectionCellModel *model = [[YYCourseCollectionCellModel alloc] initWithcourseID:courseID1 categoryID:categoryID1 teacherID:courseTeacherID11 title:courseTitle1 introduce:courseIntroduce1  courseimgurl:courseImg1 showImgurl:courseShowImg1 listImgurl:courseListImg1 tags:courseTags1 feature:coursefFeature1 crowd:courseCrowd1 seriesNum:courseSeriesNum1 collectionNum:courseCollectionNum1 commentNum:courseCommentNum1 score:courseScore1];
    model.couseSeeTime = couseSeeTime1;
    model.userID = userID1;
    
    return model;

}
#pragma mark 课程表
/***------------------------课程表-----------------------------***/
NSString *catalogueTable                    = @"t_catalogueTable";                      //课件表

NSString *catalogueID                       = @"catalogueID";                           //课件id
/**
 *  courseID;//课程id上面已经有了
 */
NSString *catalogueIndex                    = @"catalogueIndex";                        //课程序号(第几节)
NSString *catalogueTitle                    = @"catalogueTitle";                        //课程标题
NSString *catalogueMediaURL                 = @"catalogueMediaURL";                     //课程视频的URL字符串
NSString *viewNum                           = @"viewNum";                               //观看人次
/**
 *  创建课件表
 */
- (void)createCatalogueTableWithTableName:(NSString *)tableName{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text)", tableName, catalogueID, courseID, catalogueIndex, catalogueTitle, catalogueMediaURL, viewNum];
        
        if (![db executeUpdate:createSql]) {
            YYLog(@"不能创建课件表%@",[db lastErrorMessage]);
        }
    }];
}
/**
 *  添加课程列表
 */
- (void)addCourseCatalogueModelsArray:(NSArray *)catalogueArray toTableView:(NSString *)catalogueTable{
    [catalogueArray enumerateObjectsUsingBlock:^(YYCourseCellModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?)", catalogueTable, catalogueID, courseID, catalogueIndex, catalogueTitle, catalogueMediaURL, viewNum];
            
            if (![db executeUpdate:insertSql,model.ID, model.courseID, model.courseIndex, model.courseTitle, model.courseMediaURL, model.viewNum]) {
                YYLog(@"插入课件数据失败%@",[db lastErrorMessage]);
            }
        }];
    }];
}
/**
 *  获取所有课件列表
 */
- (NSArray *)courseCatalogueListWithCourseID:(NSString *)courseSelectID andCatalogueTable:(NSString *)catalogueTable{
    NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        /**
         *  SELECT * FROM %@ WHERE %@ = %@
         order by id asc
         */
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@", catalogueTable, courseID, courseSelectID];
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        if ([db hadError]) {
            YYLog(@"获取课程数据失败%@", [db lastErrorMessage]);
        }
        else{
            while ([resultSet next]) {
                YYCourseCellModel *model = [self analysisCatalogueModelWithResultSet:resultSet];
                [array addObject:model];
            }
        }
    }];
    return array;
}
/**
 *  解析课件模型
 */
- (YYCourseCellModel *)analysisCatalogueModelWithResultSet:(FMResultSet *)resultSet{
    NSString *catalogueID1                       = [resultSet stringForColumn:catalogueID];                 //课件id
    NSString *courseID1                          = [resultSet stringForColumn:courseID];
    NSString *catalogueIndex1                    = [resultSet stringForColumn:catalogueIndex];              //课程序号(第几节)
    NSString *catalogueTitle1                    = [resultSet stringForColumn:catalogueTitle];              //课程标题
    NSString *catalogueMediaURL1                 = [resultSet stringForColumn:catalogueMediaURL];           //课程视频的URL字符串
    NSString *viewNum1                           = [resultSet stringForColumn:viewNum];                     //观看人次
    
    YYCourseCellModel *model = [[YYCourseCellModel alloc] initWithID:catalogueID1 courseID:courseID1 courseIndex:catalogueIndex1 courseTitle:catalogueTitle1 courseMediaURL:catalogueMediaURL1 viewNum:viewNum1];
    
    return model;
    
}

/**
 *  删除某门课程的课件
 */
- (void)removeAllCatalogueWithCourseID:(NSString *)courseDeleteID andCatalogueTable:(NSString *)catalogueTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *removeSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@",catalogueTable, courseID, courseDeleteID];
        
        if (![db executeUpdate:removeSql]) {
            YYLog(@"删除单个课程的课表失败:%@",[db lastErrorMessage]);
        }
        
    }];
}
#pragma mark 课程收藏表
/***----------------------------课程收藏表---------------------------***/
NSString *collectCourseYesTable         = @"t_collectCourseYesTable";            //用户是否收藏课程的表

NSString *useruserID                        = @"useruserID";                             //用户ID

/**
 *  创建课程表
 */
- (void)createcollectCourseYesTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT, %@ text, %@ text)", collectCourseYesTable, useruserID, courseID];
        
        if (![db executeUpdate:createSql]) {
            YYLog(@"不能创建课程收藏表%@",[db lastErrorMessage]);
        }
    }];
    
}

/**
 *  添加课程收藏
 */
- (void)addCourseID:(NSString *)collectCourseID andUserID:(NSString *)collectUserID{
   
    BOOL collect = [self selectCollectWithCourseID:collectCourseID andUserID:collectUserID];
    if (!collect) {
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (?, ?)", collectCourseYesTable, useruserID, courseID];
            
            if (![db executeUpdate:insertSql, collectUserID, collectCourseID]) {
                YYLog(@"插入课程收藏表数据失败%@",[db lastErrorMessage]);
            }
        }];
    }
}
/**
 *  查询课程是否收藏
 */
- (BOOL)selectCollectWithCourseID:(NSString *)collectCourseID andUserID:(NSString *)collectUserID{
    
    NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ AND %@ = %@", collectCourseYesTable, useruserID, collectUserID, courseID, collectCourseID];
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        if ([db hadError]) {
            YYLog(@"获取课程收藏数据失败%@", [db lastErrorMessage]);
        }
        else{
            if ([resultSet next]) {
                [array addObject:@"1"];
                [array addObject:@"1"];
            }
        }
 
    }];
    if (array.count == 2) {
        return YES;
    }
    return NO;
}
/**
 *  删除一个课程收藏
 */
- (void)removeCollectWithCourseID:(NSString *)collectCourseID andUserID:(NSString *)collectUserID{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *removeSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@ AND %@ = %@",collectCourseYesTable, useruserID, collectUserID, courseID, collectCourseID];
        
        if (![db executeUpdate:removeSql]) {
            YYLog(@"删除单个课程收藏失败:%@",[db lastErrorMessage]);
        }
        
    }];
}
/***------------------------讲师表-----------------------------***/
NSString *teacherTable                          = @"t_teacherTable";                //讲师表

NSString *teacherID                             = @"teacherID";                     //讲师ID
NSString *teacherIconUrl                        = @"teacherIconUrl";                //讲师头像的URL
NSString *teacherName                           = @"teacherName";                   //讲师名字
NSString *teacherIntroduce                      = @"teacherIntroduce";              //讲师介绍
/**
 *  创建讲师表
 */
- (void)createteacherTable{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT, %@ text, %@ text, %@ text, %@ text)", teacherTable, teacherID, teacherIconUrl, teacherName, teacherIntroduce];
        
        if (![db executeUpdate:createSql]) {
            YYLog(@"不能创建讲师表%@",[db lastErrorMessage]);
        }
    }];

}
/**
 *  添加一个讲师,若不存在则插入，存在的话就更新
 */
- (void)addTeacherModel:(YYTeacherModel *)teacherModel{
    YYTeacherModel *model = [self teacherModelWithTeacherID:teacherModel.teacherID];
    if (!model) {
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@) VALUES (?, ?, ?, ?)", teacherTable, teacherID, teacherIconUrl, teacherName, teacherIntroduce];
            
            if (![db executeUpdate:insertSql, teacherModel.teacherID, teacherModel.teacherIconUrl, teacherModel.teacherName, teacherModel.teacherIntroduce]) {
                YYLog(@"插入讲师模型数据失败%@",[db lastErrorMessage]);
            }
        }];
    }
    else{//更新数据
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ set '%@' = '%@' , '%@' = '%@' , '%@' = '%@' WHERE %@=%@", teacherTable, teacherIconUrl,teacherModel.teacherIconUrl, teacherName, teacherModel.teacherName, teacherIntroduce,teacherModel.teacherIntroduce, teacherID, teacherModel.teacherID];
            
            if (![db executeUpdate:updateSql, teacherModel.teacherID, teacherModel.teacherIconUrl, teacherModel.teacherName, teacherModel.teacherIntroduce]) {
                YYLog(@"插入讲师模型数据失败%@",[db lastErrorMessage]);
            }
        }];
    }
}
/**
 *  获取一个讲师模型
 */
- (YYTeacherModel *)teacherModelWithTeacherID:(NSString *)teacherSelectID{
    NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@", teacherTable, teacherID, teacherSelectID];
        
        FMResultSet *resultSet = [db executeQuery:selectSql];
        if ([db hadError]) {
            YYLog(@"获取讲师模型数据失败%@", [db lastErrorMessage]);
        }
        else{
            if ([resultSet next]) {
                NSString *teacherID1                            = [resultSet stringForColumn:teacherID];             //讲师ID
                NSString *teacherIconUrl1                        = [resultSet stringForColumn:teacherIconUrl];        //讲师头像的URL
                NSString *teacherName1                           = [resultSet stringForColumn:teacherName];           //讲师名字
                NSString *teacherIntroduce1                      = [resultSet stringForColumn:teacherIntroduce];      //讲师介绍
                YYTeacherModel *model = [[YYTeacherModel alloc] initWithTeacherID:teacherID1 andIconURL:teacherIconUrl1 andName:teacherName1 andIntroduce:teacherIntroduce1];
                [array addObject:model];
            }
        }
    }];
    if (array.count == 0) {
        return nil;
    }
    YYTeacherModel *teacherModel = [array firstObject];
    return teacherModel;

}
/***------------------------课程评论表-----------------------------***/
/**
 *  添加课程评论列表
 */
- (void)addCourseCommentModelsArray:(NSArray <YYCourseCommentModel *>*)array{
    
}
@end
