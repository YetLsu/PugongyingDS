//
//  YYUserTool.h
//  pugongying
//
//  Created by wyy on 16/3/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYUserModel.h"

@interface YYUserTool : NSObject
/**
 *  取出用户模型
 */
+ (YYUserModel *)userModel;
/**
 *  保存用户模型
 */
+ (void)saveUserModelWithModel:(YYUserModel *)userMOdel;
/**
 *  删除用户模型
 */
+ (void)removeUserModel;
@end
