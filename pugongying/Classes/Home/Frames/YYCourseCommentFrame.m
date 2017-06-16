//
//  YYCourseCommentFrame.m
//  pugongying
//
//  Created by wyy on 16/2/27.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCommentFrame.h"
#import "YYCourseCommentModel.h"

@implementation YYCourseCommentFrame
- (void)setModel:(YYCourseCommentModel *)model{
    _model = model;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.commentStr];
    
    NSMutableParagraphStyle *paraphStyle = [[NSMutableParagraphStyle alloc] init];
    paraphStyle.lineSpacing = 6;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paraphStyle range:NSMakeRange(0, model.commentStr.length)];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    attr[NSParagraphStyleAttributeName] = paraphStyle;
    
    CGFloat userNameX = YY18WidthMargin + 35 + YY12WidthMargin;
    CGFloat commentLabelW = YYWidthScreen - userNameX - YY18WidthMargin;

    self.commentLabelH = [model.commentStr boundingRectWithSize:CGSizeMake(commentLabelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    
    
    
    CGFloat timeLabelY = 16/667.0*YYHeightScreen;
    CGFloat timeLabelH = 14;
    self.cellHeight = timeLabelY + timeLabelH + YY10HeightMargin + self.commentLabelH + YY12HeightMargin + 0.5 + YY10HeightMargin + timeLabelH;
}

@end
