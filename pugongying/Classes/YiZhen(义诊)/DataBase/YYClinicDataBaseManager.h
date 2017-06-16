//
//  YYYizhenDataBaseManager.h
//  pugongying
//
//  Created by wyy on 16/3/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YYClinicDataBaseManager : NSObject
+ (instancetype)shareClinicDataBaseManager;
/*------------------------我的义诊-----------------------*/
/**
 *  添加义诊列表
 */
- (void)addclinics:(NSArray *)yizhensArray andClinicTable:(NSString *)tableName;
/**
 *  获取所有义诊
 */
- (NSArray *)clinicsListFromClinicTable:(NSString *)tableName;
/**
 *  删除所有义诊
 */
- (void)removeAllYizhensAtClinicTable:(NSString *)tableName;
@end
