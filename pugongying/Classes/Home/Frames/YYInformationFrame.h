//
//  YYInformationFrame.h
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYInformationModel;
@interface YYInformationFrame : NSObject

@property (nonatomic, strong) YYInformationModel *model;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  图片ImageView的frame
 */
@property (nonatomic, assign) CGRect iconImageViewF;
/**
 *  分类和标题的Label的frame
 */
@property (nonatomic, assign) CGRect sortTitleLabelF;
/**
 *  内容Label的frame
 */
@property (nonatomic, assign) CGRect contentTextLabelF;
/**
 *  时间Label的frame
 */
@property (nonatomic, assign) CGRect timeLabelF;
///**
// *  评论左边的图标的frame
// */
//@property (nonatomic, assign) CGRect commentImageViewF;
/**
 *  线View的frame
 */
@property (nonatomic, assign) CGRect lineViewF;
@end
