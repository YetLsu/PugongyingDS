//
//  YYMyMessageFrame.h
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYMyMessageModel;

@interface YYMyMessageFrame : NSObject

@property (nonatomic, strong) YYMyMessageModel *model;

/**
 *  左边的点的imageView的frame
 */
@property (nonatomic, assign) CGRect readImageViewF;
/**
 *  消息类型的label的frame
 */
@property (nonatomic, assign) CGRect messageSortLabelF;
/**
 *  消息内容的label的frame
 */
@property (nonatomic, assign) CGRect messageContentLabelF;
/**
 *  消息时间的label的frame
 */
@property (nonatomic, assign) CGRect messageTimeLabelF;
/**
 *  单元格高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
