//
//  YYMySeedCellFrame.h
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYMySeedCellModel;
@interface YYMySeedCellFrame : NSObject

@property (nonatomic, strong) YYMySeedCellModel *model;

/**
 *  种子左侧的图片F
 */
@property (nonatomic, assign) CGRect seedLeftIconF;
/**
 *  种子赠送或消耗原因f
 */
@property (nonatomic, assign) CGRect seedContentF;
/**
 *  种子时间F
 */
@property (nonatomic, assign) CGRect timeF;
/**
 *  种子增加或减少量F
 */
@property (nonatomic, assign) CGRect seedNumberF;

/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
