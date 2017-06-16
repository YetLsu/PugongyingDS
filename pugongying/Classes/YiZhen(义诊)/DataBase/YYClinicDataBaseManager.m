//
//  YYYizhenDataBaseManager.m
//  pugongying
//
//  Created by wyy on 16/3/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYClinicDataBaseManager.h"
#import "YYClinicModel.h"
#import "YYYizhenUserModel.h"

@interface YYClinicDataBaseManager ()
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end
@implementation YYClinicDataBaseManager
- (FMDatabaseQueue *)queue{
    if (!_queue) {
        NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [docuPath stringByAppendingPathComponent:@"clinicCase.sqlite"];
        YYLog(@"数据库路径:%@",path);
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _queue;
}
+ (instancetype)shareClinicDataBaseManager{
    return [[self alloc] init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static YYClinicDataBaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        [self createYizhensTableWithClinicTable:clinicCaseTable];
        [self createYizhensTableWithClinicTable:myClinicTable];
    }
    return self;
}


/*------------------------我的义诊-----------------------*/
NSString *clinicCaseTable           =@"t_clinicCaseTable";             //义诊案例数据表
NSString *myClinicTable           =@"t_myClinicTable";             //义诊案例数据表
/**
 *  用户的信息
 */
NSString *userName              =@"userName";                   //用户姓名
NSString *userPhone             =@"userPhone";                  //用户电话
NSString *userSex               =@"userSex";                    //性别
NSString *userQQ                =@"userQQ";                     //qq
NSString *userIocnImgUrl        =@"userIocnImgUrl";             //用户头像URL
NSString *userID                =@"userID";                     //用户头像URL
/**
 *  管理员的信息
 */
NSString *adminName             =@"adminName";                  //管理员姓名
NSString *adminIocnImgUrl       =@"adminIocnImgUrl";            //管理员头像URL

NSString *clinicID              =@"clinicID";                  //义诊ID
NSString *clinicCategoryid      =@"clinicCategoryid";           //分类，淘宝，1688，国际站
NSString *clinicTitle           =@"clinicTitle";                 //义诊标题

NSString *elem1                 =@"elem1";
NSString *elem2                 =@"elem2";
NSString *elem3                 =@"elem3";
NSString *elem4                 =@"elem4";

NSString *clinicContent         =@"clinicContent";              //问题描述
NSString *clinicResult          =@"clinicResult";               //义诊回复
NSString *clinicDone            =@"clinicDone";                 //义诊是否完成(0,1)
NSString *replyTime             =@"replyTime";                  //义诊回复时间
NSString *createTime            =@"createTime";                 //义诊创建时间

/**
 *  创建义诊表单
 */
- (void)createYizhensTableWithClinicTable:(NSString *)tableName{

    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY ASC AUTOINCREMENT,%@ text, %@ text, %@ text,%@ text, %@ text, %@ text,%@ text, %@ text,%@ text, %@ text, %@ text,%@ text, %@ text,%@ text, %@ text, %@ text,%@ text, %@ text,%@ text, %@ text)", tableName, userID, userName, userPhone, userSex, userQQ, userIocnImgUrl, adminName, adminIocnImgUrl, clinicID, clinicCategoryid, clinicTitle, elem1, elem2, elem3, elem4, clinicContent, clinicResult, clinicDone, replyTime, createTime];
        
        if (![db executeUpdate:sqlStr]) {
            YYLog(@"不能创建资讯表%@",[db lastErrorMessage]);
        }
    }];
    
}

/**
 *  添加义诊列表
 */
- (void)addclinics:(NSArray *)yizhensArray andClinicTable:(NSString *)tableName{
    for (YYClinicModel *model in yizhensArray) {
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", tableName,userID, userName, userPhone, userSex, userQQ, userIocnImgUrl, adminName, adminIocnImgUrl, clinicID, clinicCategoryid, clinicTitle, elem1, elem2, elem3, elem4, clinicContent, clinicResult, clinicDone, replyTime, createTime];
           
        if (![db executeUpdate:insertSql, model.userModel.userID, model.userModel.userName, model.userModel.phone, model.userModel.sex, model.userModel.qq, model.userModel.userIocnImgUrl, model.administratorModel.userName, model.administratorModel.userIocnImgUrl, model.clinicID, model.categoryid, model.title, model.elem1, model.elem2, model.elem3, model.elem4, model.content, model.result, model.done, model.replyTime, model.createTime]) {
            
                YYLog(@"插入国际站义诊数据失败%@",[db lastErrorMessage]);
        }
        }];
        
    }
}
/**
 *  获取所有资讯
 */
- (NSArray *)clinicsListFromClinicTable:(NSString *)tableName{
    NSMutableArray *array = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *resultSet = [db executeQuery:selectSql];
        if ([db hadError]) {
            YYLog(@"查询义诊数据失败%@",[db lastErrorMessage]);
        }
        else{
            while ([resultSet next]) {
                /**
                 *  用户的信息
                 */
                NSString *userName1              =[resultSet stringForColumn:userName];                   //用户姓名
                NSString *userPhone1             =[resultSet stringForColumn:userPhone];                  //用户电话
                NSString *userSex1               =[resultSet stringForColumn:userSex];                    //性别
                NSString *userQQ1                =[resultSet stringForColumn:userQQ];                     //qq
                NSString *userIocnImgUrl1        =[resultSet stringForColumn:userIocnImgUrl];             //用户头像URL
                NSString *userID1                =[resultSet stringForColumn:userID];                     //用户ID
                /**
                 *  管理员的信息
                 */
                NSString *adminName1             =[resultSet stringForColumn:adminName];                  //管理员姓名
                NSString *adminIocnImgUrl1       =[resultSet stringForColumn:adminIocnImgUrl];            //管理员头像URL
                
                NSString *clinicID1              = [resultSet stringForColumn:clinicID];                 //义诊ID
                NSString *clinicCategoryid1      = [resultSet stringForColumn:clinicCategoryid];       //分类，淘宝，1688，国际站
                NSString *clinicTitle1           = [resultSet stringForColumn:clinicTitle];             //义诊标题
                
                NSString *elem11                 = [resultSet stringForColumn:elem1];
                NSString *elem21                 = [resultSet stringForColumn:elem2];
                NSString *elem31                 = [resultSet stringForColumn:elem3];
                NSString *elem41                 = [resultSet stringForColumn:elem4];
                
                NSString *clinicContent1         = [resultSet stringForColumn:clinicContent];              //问题描述
                NSString *clinicResult1          = [resultSet stringForColumn:clinicResult];               //义诊回复
                NSString *clinicDone1            = [resultSet stringForColumn:clinicDone];                 //义诊是否完成(0,1)
                NSString *replyTime1             = [resultSet stringForColumn:replyTime];                  //义诊回复时间
                NSString *createTime1            = [resultSet stringForColumn:createTime];                //义诊创建时间
                
                YYYizhenUserModel *userModel = [[YYYizhenUserModel alloc] initWithUserName:userName1 phone:userPhone1 sex:userSex1 qq:userQQ1 userIconImgUrl:userIocnImgUrl1 userID:userID];
                YYYizhenUserModel *adminModel = [[YYYizhenUserModel alloc] initWithUserName:adminName1 phone:nil sex:nil qq:nil userIconImgUrl:adminIocnImgUrl1 userID:nil];
                
               
                YYClinicModel *model = [[YYClinicModel alloc] initWithClinicID:clinicID1 userModel:userModel adminModel:adminModel categoryid:clinicCategoryid1 title:clinicTitle1 elem1:elem11 elem2:elem21 elem3:elem31 elem4:elem41 content:clinicContent1 result:clinicResult1 done:clinicDone1 replyTime:replyTime1 createTime:createTime1];
                model.userModel.userID = userID1;
                
                [array addObject:model];
            }
        }
    }];
    return array;
}
/**
 *  删除所有义诊
 */
- (void)removeAllYizhensAtClinicTable:(NSString *)tableName{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *cleanSql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        NSString *sequenceSql = [NSString stringWithFormat:@"UPDATE sqlite_sequence set seq=0 where name='%@'",tableName];
        [db executeUpdate:sequenceSql];
        
        if (![db executeUpdate:cleanSql]) {
            YYLog(@"删除所有义诊失败:%@",[db lastErrorMessage]);
        }
    }];
}
@end
