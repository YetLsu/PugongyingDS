//
//  YYApplyYiZhenModel.h
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYApplyYiZhenModel : NSObject
/**
 *  联系人
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  联系电话
 */
@property (nonatomic, copy) NSString *phoneNumber;
/**
 *  QQ号码
 */
@property (nonatomic, copy) NSString *QQ;
/**
 *  店铺网址
 */
@property (nonatomic, copy) NSString *storeAddress;
/**
 *  操作店铺时间
 */
@property (nonatomic, copy) NSString *storeTime;
/**
 *  每天操作店铺时间
 */
@property (nonatomic, copy) NSString *storeDayTime;
/**
 *  案例平台
 */
@property (nonatomic, copy) NSString *platform;
/**
 *  店铺装修
 */
@property (nonatomic, copy) NSString *storeFitment;
/**
 *  专人负责
 */
@property (nonatomic, copy) NSString *someone;
/**
 *  问题描述
 */
@property (nonatomic, copy) NSString *questionIntro;


- (instancetype)initWithUserName:(NSString *)userName phoneNumber:(NSString *)phoneNumber QQ:(NSString *)QQ storeAddress:(NSString *)storeAddress storeTime:(NSString *)storeTime storeDayTime:(NSString *)storeDayTime platform:(NSString *)platform storeFitment:(NSString *)storeFitment someone:(NSString *)someone;
@end
