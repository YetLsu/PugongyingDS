//
//  YYCourseCommentFrame.h
//  pugongying
//
//  Created by wyy on 16/2/27.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCourseCommentModel;

@interface YYCourseCommentFrame : NSObject

@property (nonatomic, strong) YYCourseCommentModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat commentLabelH;

@end
