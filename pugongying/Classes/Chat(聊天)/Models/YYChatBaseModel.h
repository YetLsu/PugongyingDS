//
//  YYChatBaseModel.h
//  pugongying
//
//  Created by wyy on 16/6/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  发送消息状态
 */
typedef NS_ENUM(NSInteger, YYChatSendMessageStatus){
    /**
     *  @"发送失败"
     */
    YYChatSendMessageStatusFaild = 0,
    /**
     *  @"发送成功"
     */
    YYChatSendMessageStatusSuccess = 1,
    /**
     *  @"发送中"
     */
    YYChatSendMessageStatusSending = 2,
};
/**
 *  对话类型
 */
typedef NS_ENUM(NSUInteger, YYChatType){
    /**
     *  @"单聊"
     */
    YYChatTypeFriendPrivate,
    /**
     *  @"群聊"
     */
    YYChatTypeGroup,
};
/**
 *  消息是否是自己发的
 */
typedef NS_ENUM(NSUInteger, YYMessageFrom){
    /**
     *  @"自己"
     */
    YYMessageFromMe,
    /**
     *  @"别人"
     */
    YYMessageFromOther
};

@interface YYChatBaseModel : NSObject
/**
 *  消息的类型区分
 */
@property (nonatomic, assign) YYChatType chatType;
/**
 *  消息发送状态
 */
@property (nonatomic, assign) YYChatSendMessageStatus chatSendStatus;
/**
 *  消息是否是自己发的
 */
@property (nonatomic, assign) YYMessageFrom messageFrom;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *userIconUrlStr;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  聊天内容
 */
@property (nonatomic, copy) NSString *sendContent;
/**
 *  发送或者收到时间
 */
@property (nonatomic, copy) NSString *sendDateStr;
/**
 *  发送或者收到
 */
@property (nonatomic, copy) NSString *sendReceive;
/**
 *  发送失败的原因
 */
@property (nonatomic, strong) NSString *faildReason;

@end
