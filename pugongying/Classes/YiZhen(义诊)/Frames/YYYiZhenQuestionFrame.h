//
//  YYYiZhenQuestionFrame.h
//  pugongying
//
//  Created by wyy on 16/3/9.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYClinicModel;

@interface YYYiZhenQuestionFrame : NSObject
@property (nonatomic, strong) YYClinicModel *model;

/**
 *背景图片
 */
@property (nonatomic, assign) CGRect bgImageViewF;
/**
 *  view的高
 */
@property (nonatomic, assign) CGFloat viewHeight;
/**
 *  案例平台Frame
 */
@property (nonatomic, assign) CGRect platformF;
/**
 *  用户头像Frame
 */
@property (nonatomic, assign) CGRect userIconStrF;
/**
 *  用户昵称Frame
 */
@property (nonatomic, assign) CGRect userNameF;
/**
 *  店铺网址Frame,elme1
 */
@property (nonatomic, assign) CGRect storeAddressF;
/**
 *  QQ号码Frame
 */
@property (nonatomic, assign) CGRect QQF;
/**
 *  电话号码Frame
 */
@property (nonatomic, assign) CGRect phoneNumberF;
/**
 *  是否专人负责Frame
 */
@property (nonatomic, assign) CGRect someoneF;
/**
 *  发布时间Frame
 */
@property (nonatomic, assign) CGRect createDateF;
/**
 *  elem2LabelFrame
 */
@property (nonatomic, assign) CGRect elem2LabelF;
/**
 *   elem3LabelFrame
 */
@property (nonatomic, assign) CGRect elem3LabelF;
/**
 *  elem4LabelFrame
 */
@property (nonatomic, assign) CGRect elem4LabelF;
/**
 *  问题描述
 */
@property (nonatomic, assign) CGRect questionIntroF;
@end
