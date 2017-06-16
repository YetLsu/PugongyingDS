//
//  YYMySeedCellModel.h
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMySeedCellModel : NSObject

/**
*  种子左侧的图片
*/
@property (nonatomic, copy) NSString *seedLeftIcon;
/**
 *  种子消息的ID
 */
@property (nonatomic, copy) NSString *seedID;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *userid;
/**
 *  规则id
 */
@property (nonatomic, copy) NSString *rootid;
/**
 *  种子赠送或消耗原因
 */
@property (nonatomic, copy) NSString *content;
/**
 *  种子时间
 */
@property (nonatomic, copy) NSString *create_dt;
/**
 *  种子数
 */
@property (nonatomic, copy) NSString *seednum;
/**
 *  增减(1,-1)
 */
@property (nonatomic, copy) NSString *change;


@end
