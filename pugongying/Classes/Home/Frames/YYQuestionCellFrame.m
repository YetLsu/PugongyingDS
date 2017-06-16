//
//  YYQuestionCellFrame.m
//  pugongying
//
//  Created by wyy on 16/2/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYQuestionCellFrame.h"
#import "YYQuestionModel.h"


@implementation YYQuestionCellFrame
- (void)setModel:(YYQuestionModel *)model{
    _model = model;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.contentText];
    
    NSMutableParagraphStyle *paraphStyle = [[NSMutableParagraphStyle alloc] init];
    paraphStyle.lineSpacing = 6;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paraphStyle range:NSMakeRange(0, model.contentText.length)];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    attr[NSParagraphStyleAttributeName] = paraphStyle;
    
    
    CGFloat contentLabelW = YYWidthScreen - 2 * YY18WidthMargin;

    self.contentHeight = [model.contentText boundingRectWithSize:CGSizeMake(contentLabelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    YYLog(@"frame里面的高度＝%f",self.contentHeight);
    
    self.cellRowHeight = YY12HeightMargin + 35 + YY12HeightMargin + self.contentHeight + YY10HeightMargin + 14 + YY10HeightMargin + YY10HeightMargin + 16 + YY10HeightMargin + YY12HeightMargin;

}
@end
