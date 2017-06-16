//
//  YYCircleChatMessageModel.h
//  pugongying
//
//  Created by wyy on 16/6/2.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCircleChatMessageModel : NSObject
/**
 *  头像
 */
@property (nonatomic, copy) NSString *userIconUrlStr;
/**
 *  聊天内容
 */
@property (nonatomic, copy) NSString *sendContent;
/**
 *  发送或者收到时间
 */
@property (nonatomic, copy) NSString *sendDate;
/**
 *  发送或者收到
 */
@property (nonatomic, copy) NSString *sendReceive;
@end
