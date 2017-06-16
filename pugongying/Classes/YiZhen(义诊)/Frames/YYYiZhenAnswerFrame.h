//
//  YYYiZhenAnswerFrame.h
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYClinicModel;

@interface YYYiZhenAnswerFrame : NSObject
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
 *  用户头像Frame
 */
@property (nonatomic, assign) CGRect userIconStrF;
/**
 *  用户昵称Frame
 */
@property (nonatomic, assign) CGRect userNameF;
/**
 *  蒲公英名字下方的蒲公英官方义诊LabelFrame
 */
@property (nonatomic, assign) CGRect pugongyingF;
/**
 *  义诊已完成图片Frame
 */
@property (nonatomic, assign) CGRect yizhenFinishF;
/**
 *  回复内容LabelFrame
 */
@property (nonatomic, assign) CGRect answerContentF;
/**
 *  回复时间Frame
 */
@property (nonatomic, assign) CGRect answerDateF;
@end
