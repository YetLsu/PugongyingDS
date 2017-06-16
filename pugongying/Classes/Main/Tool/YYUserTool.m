//
//  YYUserTool.m
//  pugongying
//
//  Created by wyy on 16/3/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYUserTool.h"
#define YYUserModelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selfuser.archieve"]

@implementation YYUserTool
/**
 *  取出用户模型
 */
+ (YYUserModel *)userModel{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YYUserModelPath];
}
/**
 *  保存用户模型
 */
+ (void)saveUserModelWithModel:(YYUserModel *)userMOdel{
    [NSKeyedArchiver archiveRootObject:userMOdel toFile:YYUserModelPath];
}
/**
 *  删除用户模型
 */
+ (void)removeUserModel{
    YYUserModel *model = [[YYUserModel alloc] init];
                          
    [NSKeyedArchiver archiveRootObject:model toFile:YYUserModelPath];
}
@end
