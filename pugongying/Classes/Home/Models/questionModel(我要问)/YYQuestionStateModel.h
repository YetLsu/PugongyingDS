//
//  YYQuestionStateModel.h
//  pugongying
//
//  Created by wyy on 16/3/1.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum YYQuestionState{
    YYQuestionStateProgress, //进行中
    YYQuestionStateFinshed, //已解决
    YYQuestionStateDisable //失效
} YYQState;

@interface YYQuestionStateModel : NSObject
/**
 *  头像URL字符串
 */
@property (nonatomic, copy) NSString *iconUrlStr;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  正文
 */
@property (nonatomic, copy) NSString *contentText;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *dateText;
/**
 *  回答人数
 */
@property (nonatomic, copy) NSString *answerNumber;
/**
 *  悬赏值
 */
@property (nonatomic, copy) NSString *rewardNumber;
/**
 *  标签
 */
@property (nonatomic, copy) NSString *markText;
/**
 *  状态
 */
@property (nonatomic, assign) YYQState state;
@end
