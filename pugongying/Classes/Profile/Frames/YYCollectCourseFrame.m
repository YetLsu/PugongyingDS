//
//  YYCollectCourseFrame.m
//  pugongying
//
//  Created by wyy on 16/3/11.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCollectCourseFrame.h"
#import "YYCourseCollectionCellModel.h"


@implementation YYCollectCourseFrame
- (void)setModel:(YYCourseCollectionCellModel *)model{
    _model = model;
    
    /**
     *  课程图片Frame
     */
//    CGFloat scale = YYWidthScreen/375.0;
    CGFloat iconH = 72;
    CGFloat iconW = 100;
    self.courseIconF = CGRectMake(YY18WidthMargin, YY12HeightMargin, iconW, iconH);
    /**
     *  课程标题LabelFrame
     */
    CGFloat courseTitleX = YY18WidthMargin * 2 + iconW;
    CGFloat courseTitleW = YYWidthScreen - YY18WidthMargin - courseTitleX;
    CGFloat courseTitleY = YY12HeightMargin;
    CGFloat courseTitleH = 26;
    self.courseTitleF = CGRectMake(courseTitleX, courseTitleY, courseTitleW, courseTitleH);
    /**
     *  课程分类LabelFrame
     */
    CGFloat sortY = CGRectGetMaxY(self.courseTitleF);
    CGFloat sortH = 24;
    self.courseSortF = CGRectMake(courseTitleX, sortY, courseTitleW, sortH);
    /**
     *  课程播放量LabelFrame
     */
    CGFloat playNumberY = CGRectGetMaxY(self.courseSortF);
    CGFloat playNumberH = 22;
    self.coursePlayNumberF = CGRectMake(courseTitleX, playNumberY, courseTitleW, playNumberH);
    /**
     *  查看课程ButtonFrame
     */
    CGFloat cancelY = CGRectGetMaxY(self.courseIconF) + YY12HeightMargin * 2;
    CGFloat cancelW = 80;
    CGFloat cancelH = 25;
    CGFloat lookX = YYWidthScreen - cancelW - YY18WidthMargin;
    self.courseLookF = CGRectMake(lookX, cancelY, cancelW, cancelH);
    /**
     *  取消收藏课程ButtonFrame
     */
    CGFloat cancelX = lookX - YY12WidthMargin - cancelW;
    self.courseCancelCollectF = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    
    self.cellHeight = CGRectGetMaxY(self.courseLookF) + YY12HeightMargin;
    
    
    
}
@end
