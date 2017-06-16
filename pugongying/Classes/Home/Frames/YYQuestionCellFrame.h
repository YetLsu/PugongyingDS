//
//  YYQuestionCellFrame.h
//  pugongying
//
//  Created by wyy on 16/2/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYQuestionModel;
@interface YYQuestionCellFrame : NSObject


@property (nonatomic, strong) YYQuestionModel *model;

/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellRowHeight;
/**
 *  内容高度
 */
@property (nonatomic, assign) CGFloat contentHeight;
@end
