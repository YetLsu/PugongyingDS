//
//  YYCollectNewsFrame.h
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYInformationModel;

@interface YYCollectNewsFrame : NSObject

@property (nonatomic, strong) YYInformationModel *model;

/**
 *  单元格高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  资讯图片Frame
 */
@property (nonatomic, assign) CGRect newsIconF;
/**
 *  资讯标题LabelFrame
 */
@property (nonatomic, assign) CGRect newsTitleF;
/**
 *  资讯内容LabelFrame
 */
@property (nonatomic, assign) CGRect newsContentF;
/**
 *  取消收藏资讯ButtonFrame
 */
@property (nonatomic, assign) CGRect newsCancelCollectF;
/**
 *  查看资讯ButtonFrame
 */
@property (nonatomic, assign) CGRect newsLookF;
@end
