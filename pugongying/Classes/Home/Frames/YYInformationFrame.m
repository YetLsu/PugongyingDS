//
//  YYInformationFrame.m
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYInformationFrame.h"
#import "YYInformationModel.h"



@implementation YYInformationFrame
- (void)setModel:(YYInformationModel *)model{
    _model = model;
    /**
     *  图片ImageView的frame
     */
    CGFloat iconImageVW = 70;
    self.iconImageViewF = CGRectMake(YY18WidthMargin, YY12HeightMargin, iconImageVW, iconImageVW);
    /**
     *  分类和标题的Label的frame
     */
    CGFloat sortTitleX = YY18WidthMargin + iconImageVW + YY12WidthMargin;
    CGFloat sortTitleY = YY12WidthMargin + 6;
    CGFloat sortTitleW = YYWidthScreen - sortTitleX - YY18WidthMargin;
    CGFloat sortTitleH = 18;
    self.sortTitleLabelF = CGRectMake(sortTitleX, sortTitleY, sortTitleW, sortTitleH);
    
    /**
     *  内容Label的frame
     */
    CGFloat contentLabelY = sortTitleY + sortTitleH + 4;
    CGFloat contentLabelW =  YYWidthScreen - sortTitleX - YY18WidthMargin*2;
    CGFloat contentLabelH = 35;
    self.contentTextLabelF = CGRectMake(sortTitleX, contentLabelY, contentLabelW, contentLabelH);
    /**
     *  时间Label的frame
     */
    CGFloat timeLabelW = YYWidthScreen/2;
    CGFloat timeLabelH = 15;

    CGFloat timeLabelX = YYWidthScreen - YY18WidthMargin - timeLabelW;
    CGFloat timeLabelY = CGRectGetMaxY(self.contentTextLabelF) + 5;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    

    CGFloat imageH = YY12HeightMargin*2 +iconImageVW;
    
    CGFloat titleH = timeLabelY + timeLabelH + YY12HeightMargin;
    if (imageH >titleH) {
        self.cellHeight = imageH;
    }
    else{
        self.cellHeight = titleH;
    }
//    YYLog(@"图片算：%f文本算：%f",imageH, titleH);
    self.lineViewF = CGRectMake(0, self.cellHeight - 0.5, YYWidthScreen, 0.5);
}
@end

