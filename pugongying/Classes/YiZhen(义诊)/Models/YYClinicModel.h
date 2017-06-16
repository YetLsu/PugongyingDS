//
//  YYYiZhenCaseModel.h
//  pugongying
//
//  Created by wyy on 16/3/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYYizhenUserModel;

@interface YYClinicModel : NSObject
/**
 *  义诊ID
 */
@property (nonatomic, copy) NSString *clinicID;
/**
 *  用户的信息
 */
@property (nonatomic, strong) YYYizhenUserModel *userModel;
/**
 *  管理员的信息
 */
@property (nonatomic, strong) YYYizhenUserModel *administratorModel;
/**
 *  分类，淘宝，1688，国际站
 */
@property (nonatomic, copy) NSString *categoryid;
/**
 * 义诊标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  填写内容1
 */
@property (nonatomic, copy) NSString *elem1;
/**
 *  填写内容2
 */
@property (nonatomic, copy) NSString *elem2;
/**
 *  填写内容3
 */
@property (nonatomic, copy) NSString *elem3;
/**
 *  填写内容4
 */
@property (nonatomic, copy) NSString *elem4;
/**
 *  补充内容
 */
@property (nonatomic, copy) NSString *content;
/**
 * 义诊结果
 */
@property (nonatomic, copy) NSString *result;
/**
 * 义诊是否完成(0,1)
 */
@property (nonatomic, copy) NSString *done;
/**
 * 义诊回复时间
 */
@property (nonatomic, copy) NSString *replyTime;
/**
 *  义诊创建时间
 */
@property (nonatomic, copy) NSString *createTime;



- (instancetype)initWithClinicID:(NSString *)clinicID userModel:(YYYizhenUserModel *)userModel adminModel:(YYYizhenUserModel *)adminModel categoryid:(NSString *)categoryid title:(NSString *)title elem1:(NSString *)elem1 elem2:(NSString *)elem2 elem3:(NSString *)elem3 elem4:(NSString *)elem4 content:(NSString *)content result:(NSString *)result done:(NSString *)done replyTime:(NSString *)replyTime createTime:(NSString *)createTime;
@end
