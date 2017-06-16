//
//  YYMainDataTool.h
//  pugongying
//
//  Created by wyy on 16/5/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMainDataModel.h"

@interface YYMainDataTool : NSObject
/**
 *  取出用户模型
 */
+ (YYMainDataModel *)mainModel;
/**
 *  保存用户模型
 */
+ (void)saveMainModelWithModel:(YYMainDataModel *)mainModel;
/**
 *  删除用户模型
 */
+ (void)removeMainModel;
@end
