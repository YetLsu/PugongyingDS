//
//  YYUserModel.m
//  pugongying
//
//  Created by wyy on 16/3/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYUserModel.h"

#define YYUserNickName @"YYUserNickName"
#define YYUserModelID @"YYUserModelID"
#define YYUserHeadimgurl @"YYUserHeadimgurl"
#define YYUserIdcard @"YYUserIdcard"
#define YYUserIdcardUrl @"YYUserIdcardUrl"
#define YYUserRealname @"YYUserRealname"
#define YYUserPhone @"YYUserPhone"
#define YYUserCompany @"YYUserCompany"
#define YYUserAuthent @"YYUserAuthent"
#define YYUserReg @"YYUserReg"
#define YYUserLicense @"YYUserLicense"
#define YYUserLicenseimgurl @"YYUserLicenseimgurl"
#define YYUserAuthState @"YYUserAuthState"
#define YYUserRegState @"YYUserRegState"

@implementation YYUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    /**
     *  用户ID
     */
    [aCoder encodeObject:self.userID forKey:@"userID"];
    /**
     *  用户名,手机号或邮箱
     */
    [aCoder encodeObject:self.username forKey:@"username"];
    /**
     *  密码,32加密
     */
    [aCoder encodeObject:self.password forKey:@"password"];
    /**
     *  昵称,默认同username
     */
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    /**
     *  头像图片地址
     */
    [aCoder encodeObject:self.headimgurl forKey:@"headimgurl"];
    /**
     *  手机号
     */
    [aCoder encodeObject:self.phone forKey:@"phone"];
    /**
     *   电子邮箱
     */
    [aCoder encodeObject:self.email forKey:@"email"];
    /**
     *  实名认证状态,('未认证',
     '认证中','已认证','认证失败')
     */
    [aCoder encodeObject:self.regstate forKey:@"regstate"];

    /**
     *  身份证号
     */
    [aCoder encodeObject:self.idcard forKey:@"idcard"];
    /**
     *  真实姓名
     */
    [aCoder encodeObject:self.realname forKey:@"realname"];
    /**
     *  性别
     */
    [aCoder encodeObject:self.sex forKey:@"sex"];
    /**
     *  年龄
     */
    [aCoder encodeObject:self.age forKey:@"age"];
    /**
     *  身份证件图片地址
     */
    [aCoder encodeObject:self.idcardimgurl forKey:@"idcardimgurl"];
    /**
     *  公司认证状态
     */
    [aCoder encodeObject:self.authstate forKey:@"authstate"];
    /**
     *  公司名称
     */
    [aCoder encodeObject:self.company forKey:@"company"];
    /**
     *  营业执照号
     */
    [aCoder encodeObject:self.license forKey:@"license"];
    /**
     *  营业执照图片地址
     */
    [aCoder encodeObject:self.licenseimgurl forKey:@"licenseimgurl"];
    /**
     *  种子量
     */
    [aCoder encodeObject:self.seed forKey:@"seed"];
    /**
     *  等级,('等级一','等级二')
     */
    [aCoder encodeObject:self.level forKey:@"level"];
    /**
     *  当月签到,'1,2,5,31'数组式 字符串
     */
    [aCoder encodeObject:self.signday forKey:@"signday"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        /**
         *  用户ID
         */
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        /**
         *  用户名,手机号或邮箱
         */
        self.username = [aDecoder decodeObjectForKey:@"username"];
        /**
         *  密码,32加密
         */
        self.password = [aDecoder decodeObjectForKey:@"password"];
        /**
         *  昵称,默认同username
         */
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        /**
         *  头像图片地址
         */
        self.headimgurl = [aDecoder decodeObjectForKey:@"headimgurl"];
        /**
         *  手机号
         */
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        /**
         *   电子邮箱
         */
        self.email = [aDecoder decodeObjectForKey:@"email"];
        /**
         *  实名认证状态,('未认证',
         '认证中','已认证','认证失败')
         */
        self.regstate = [aDecoder decodeObjectForKey:@"regstate"];
        /**
         *  身份证号
         */
        self.idcard = [aDecoder decodeObjectForKey:@"idcard"];
        /**
         *  真实姓名
         */
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        /**
         *  性别
         */
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        /**
         *  年龄
         */
        self.age = [aDecoder decodeObjectForKey:@"age"];
        /**
         *  身份证件图片地址
         */
        self.idcardimgurl = [aDecoder decodeObjectForKey:@"idcardimgurl"];
        /**
         *  公司认证状态
         */
        self.authstate = [aDecoder decodeObjectForKey:@"authstate"];
        /**
         *  公司名称
         */
        self.company = [aDecoder decodeObjectForKey:@"company"];
        /**
         *  营业执照号
         */
        self.license = [aDecoder decodeObjectForKey:@"license"];
        /**
         *  营业执照图片地址
         */
        self.licenseimgurl = [aDecoder decodeObjectForKey:@"licenseimgurl"];
        /**
         *  种子量
         */
        self.seed = [aDecoder decodeObjectForKey:@"seed"];
        /**
         *  等级,('等级一','等级二')
         */
        self.level = [aDecoder decodeObjectForKey:@"level"];
        /**
         *  当月签到,'1,2,5,31'数组式 字符串
         */
        self.signday = [aDecoder decodeObjectForKey:@"signday"];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.userID = value;
    }
}
@end
