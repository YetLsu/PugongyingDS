//
//  YYMainDataTool.m
//  pugongying
//
//  Created by wyy on 16/5/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMainDataTool.h"
#define YYMainModelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mainModel.archieve"]

@implementation YYMainDataTool
/**
 *  取出用户模型
 */
+ (YYMainDataModel *)mainModel{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YYMainModelPath];
}
/**
 *  保存用户模型
 */
+ (void)saveMainModelWithModel:(YYMainDataModel *)mainModel{
    [NSKeyedArchiver archiveRootObject:mainModel toFile:YYMainModelPath];
}
/**
 *  删除用户模型
 */
+ (void)removeMainModel{
    YYMainDataModel *model = [[YYMainDataModel alloc] init];
    
    [NSKeyedArchiver archiveRootObject:model toFile:YYMainModelPath];

}
@end
