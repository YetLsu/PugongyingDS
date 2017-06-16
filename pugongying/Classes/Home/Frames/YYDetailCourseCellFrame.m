//
//  YYDetailCourseCellFrame.m
//  pugongying
//
//  Created by wyy on 16/5/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYDetailCourseCellFrame.h"
#import "YYCourseCollectionCellModel.h"
#import "YYTeacherModel.h"

@interface YYDetailCourseCellFrame ()

@end

@implementation YYDetailCourseCellFrame
#pragma mark 重写讲师模型的Setter方法
- (void)setTeacherModel:(YYTeacherModel *)teacherModel{
    _teacherModel = teacherModel;
    
    /**
     *  讲师上面标题的ViewF
     */
    CGFloat titleViewX = 0;
    CGFloat titleViewY = 0;
    CGFloat titleViewW = YYWidthScreen;
    CGFloat titleViewH = 2*YY12HeightMargin + 16;
    self.teacherTitleViewF = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    
    /**
     讲师头像F
     */
    CGFloat iconX = YY18WidthMargin;
    CGFloat iconY = titleViewH;
    CGFloat iconW = 70/375.0*YYWidthScreen;
    CGFloat iconH = iconW;
    self.iconImageViewF = CGRectMake(iconX, iconY, iconW, iconH);
    
    /**
     讲师名字F
     */
    CGFloat teacherNameLabelX = iconX + iconW + 10/375.0*YYWidthScreen;
    CGFloat teacherNameLabelY = iconY + 6/667.0*YYHeightScreen;
    CGFloat teacherNameLabelW = YYWidthScreen - YY18WidthMargin - teacherNameLabelX;
    CGFloat teacherNameLabelH = 15;
    self.nameLabelF = CGRectMake(teacherNameLabelX, teacherNameLabelY, teacherNameLabelW, teacherNameLabelH);
    /**
     讲师介绍F
     */
    CGFloat teacherIntroLabelX = teacherNameLabelX;
    CGFloat teacherIntroLabelY = CGRectGetMaxY(self.nameLabelF) + 10/667.0*YYHeightScreen;
    CGFloat teacherIntroLabelW = teacherNameLabelW;
    
    //获取讲师介绍高度
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    
    CGFloat teacherIntroLabelH = [self.teacherModel.teacherIntroduce boundingRectWithSize:CGSizeMake(teacherIntroLabelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;

    self.introduceLabelF = CGRectMake(teacherIntroLabelX, teacherIntroLabelY, teacherIntroLabelW, teacherIntroLabelH);
    
    /**
     *  中间灰色的ViewF
     */
    CGFloat grayViewX = 0;
    CGFloat iconViewMax = CGRectGetMaxY(self.iconImageViewF) + YY12HeightMargin;
    CGFloat introduceMax = CGRectGetMaxY(self.introduceLabelF) + YY12HeightMargin;

    CGFloat grayViewY = iconViewMax > introduceMax ? iconViewMax : introduceMax;
    CGFloat grayViewW = YYWidthScreen;
    CGFloat grayViewH = 10/667.0 * YYHeightScreen;
    self.grayViewF = CGRectMake(grayViewX, grayViewY, grayViewW, grayViewH);
    
}
#pragma mark 重写课程模型的Setter方法
- (void)setCourseModel:(YYCourseCollectionCellModel *)courseModel{
    _courseModel = courseModel;
    /**
     *  课程上面标题的ViewF
     */
    CGFloat titleViewX = 0;
    CGFloat titleViewY = CGRectGetMaxY(self.grayViewF);
    CGFloat titleViewW = YYWidthScreen;
    CGFloat titleViewH = 2*YY12HeightMargin + 16;
    self.courseTitleViewF = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    /**
     *  课程详情的高度
     */
    NSString *labelText = [NSString stringWithFormat:@"%@：%@",@"课程详情",_courseModel.courseIntroduce];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    
    //设置课程详情高度
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    
    CGFloat labelW = YYWidthScreen - YY18WidthMargin * 2;
    self.courseIntroH = [labelText boundingRectWithSize:CGSizeMake(labelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    
    CGFloat marginY = 10/667.0*YYHeightScreen;
    CGFloat cellH = 13;

    self.rowHeight = CGRectGetMaxY(self.courseTitleViewF) + 5 * (cellH + marginY) + self.courseIntroH + marginY;
    
}

@end
