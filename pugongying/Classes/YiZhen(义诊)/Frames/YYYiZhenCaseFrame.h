//
//  YYYiZhenCaseFrame.h
//  pugongying
//
//  Created by wyy on 16/3/8.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYClinicModel;

@interface YYYiZhenCaseFrame : NSObject
/**
 *  淘宝模型
 */
@property (nonatomic, strong) YYClinicModel *model;

/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  案例名称Frame
 */
@property (nonatomic, assign) CGRect caseNameF;
/**
 *  案例平台Frame
 */
@property (nonatomic, assign) CGRect caseSortF;
//问题
/**
 *  用户头像Frame
 */
@property (nonatomic, assign) CGRect userIconStrF;
/**
 *  用户昵称Frame
 */
@property (nonatomic, assign) CGRect userNameF;
/**
 *  问题描述Frame
 */
@property (nonatomic, assign) CGRect questionIntroF;
//回答
/**
 *  回答者头像Frame
 */
@property (nonatomic, assign) CGRect answerIconUrlF;
/**
 *  回答者昵称Frame
 */
@property (nonatomic, assign) CGRect answerNameF;
/**
 *  义诊结果Frame
 */
@property (nonatomic, assign) CGRect answerResultF;
/**
 *  提交时间LabelFrame
 */
@property (nonatomic, assign) CGRect createLabelF;

@end
