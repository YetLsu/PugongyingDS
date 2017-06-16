//
//  YYQuestionStateCellFrame.h
//  pugongying
//
//  Created by wyy on 16/3/1.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYQuestionStateModel;
@interface YYQuestionStateCellFrame : NSObject
@property (nonatomic, strong) YYQuestionStateModel *model;

/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellRowHeight;
/**
 *  内容高度
 */
@property (nonatomic, assign) CGFloat contentHeight;
@end
