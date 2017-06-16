//
//  YYUserModel.h
//  pugongying
//
//  Created by wyy on 16/3/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUserModel : NSObject<NSCoding>
/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *userID;
/**
 *  用户名,手机号或邮箱
 */
@property (nonatomic, copy) NSString *username;
/**
 *  密码,32加密
 */
@property (nonatomic, copy) NSString *password;
/**
 *  昵称,默认同username
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  头像图片地址
 */
@property (nonatomic, copy) NSString *headimgurl;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 *   电子邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  实名认证状态,('未认证',
 '认证中','已认证','认证失败')
 */
@property (nonatomic, copy) NSString *regstate;
/**
 *  身份证号
 */
@property (nonatomic, copy) NSString *idcard;
/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *realname;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  年龄
 */
@property (nonatomic, copy) NSString *age;
/**
 *  身份证件图片地址
 */
@property (nonatomic, copy) NSString *idcardimgurl;
/**
 *  公司认证状态
 */
@property (nonatomic, copy) NSString *authstate;
/**
 *  公司名称
 */
@property (nonatomic, copy) NSString *company;
/**
 *  营业执照号
 */
@property (nonatomic, copy) NSString *license;
/**
 *  营业执照图片地址
 */
@property (nonatomic, copy) NSString *licenseimgurl;
/**
 *  种子量
 */
@property (nonatomic, copy) NSString *seed;
/**
 *  等级,('等级一','等级二')
 */
@property (nonatomic, copy) NSString *level;
/**
 *  当月签到,'1,2,5,31'数组式 字符串
 */
@property (nonatomic, copy) NSString *signday;

@end
