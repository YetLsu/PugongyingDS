//
//  YYMyMessageModel.h
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMyMessageModel : NSObject

/**
 *  我的消息ID
 */
@property (nonatomic, copy) NSString *messageID;
/**
 *  是否显示左边的点，表示消息是否已读，有点表示未读,0未读，1已读
 */
@property (nonatomic, copy) NSString *disable;
/**
 *  消息title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  消息内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  消息时间
 */
@property (nonatomic, copy) NSString *createTime;


@end
