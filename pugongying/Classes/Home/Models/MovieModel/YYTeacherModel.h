//
//  YYTeacherModel.h
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTeacherModel : NSObject
/**
 *  讲师ID
 */
@property (nonatomic, copy) NSString *teacherID;
/**
 *  讲师头像的URL
 */
@property (nonatomic, copy) NSString *teacherIconUrl;
/**
 *  讲师名字
 */
@property (nonatomic, copy) NSString *teacherName;
/**
 *  讲师介绍
 */
@property (nonatomic,copy) NSString *teacherIntroduce;

- (instancetype)initWithTeacherID:(NSString *)teacherID andIconURL:(NSString *)iconURLStr andName:(NSString *)teacherName andIntroduce:(NSString *)teacherIntroduce;
@end
