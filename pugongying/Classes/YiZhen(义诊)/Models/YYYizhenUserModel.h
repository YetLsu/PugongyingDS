//
//  YYYizhenUserModel.h
//  pugongying
//
//  Created by wyy on 16/3/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYYizhenUserModel : NSObject
/**
 *  姓名
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  电话
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  qq
 */
@property (nonatomic, copy) NSString *qq;
/**
 *  用户头像URL
 */
@property (nonatomic, copy) NSString *userIocnImgUrl;
/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *userID;
- (instancetype)initWithUserName:(NSString *)userName phone:(NSString *)phone sex:(NSString *)sex qq:(NSString *)qq userIconImgUrl:(NSString *)userIconImgUrl userID:(NSString *)userID;
/**
 *  创建用户模型或者管理员模型，tag值标记
 *  用户模型0
 *  管理员模型1
 */
- (instancetype)initWithTag:(NSInteger)tag;
@end
