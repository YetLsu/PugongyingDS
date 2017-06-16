//
//  YYCollectNewsFrame.m
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCollectNewsFrame.h"
#import "YYInformationModel.h"

@implementation YYCollectNewsFrame

- (void)setModel:(YYInformationModel *)model{
    _model = model;
    
    /**
     *  资讯图片Frame
     */
    
    CGFloat iconW = 83;
    CGFloat iconH = 83;
    self.newsIconF = CGRectMake(YY18WidthMargin, YY12HeightMargin, iconW, iconH);
    /**
     *  资讯标题LabelFrame
     */
    CGFloat newsTitleX = YY18WidthMargin + YY12WidthMargin + iconW;
    CGFloat newsTitleW = YYWidthScreen - YY18WidthMargin - newsTitleX;
    CGFloat newsTitleY = YY12HeightMargin;
    CGFloat newsTitleH = 30;
    self.newsTitleF = CGRectMake(newsTitleX, newsTitleY, newsTitleW, newsTitleH);
    /**
     *  资讯内容LabelFrame
     */
    CGFloat newsContentY = newsTitleY + newsTitleH;
    CGFloat newsContentH = 45;
    self.newsContentF = CGRectMake(newsTitleX, newsContentY, newsTitleW, newsContentH);
    /**
     *  取消收藏资讯ButtonFrame
     */
    CGFloat cancelY = CGRectGetMaxY(self.newsIconF) + YY12HeightMargin * 3;
    CGFloat cancelW = 80;
    CGFloat cancelH = 25;
    CGFloat lookX = YYWidthScreen - cancelW - YY18WidthMargin;

    self.newsLookF = CGRectMake(lookX, cancelY, cancelW, cancelH);
    /**
     *  查看资讯ButtonFrame
     */
    CGFloat cancelX = lookX - YY12WidthMargin - cancelW;
    self.newsCancelCollectF = CGRectMake(cancelX, cancelY, cancelW, cancelH);;
    
    /**
     *  单元格高度
     */
    self.cellHeight = CGRectGetMaxY(self.newsCancelCollectF) + YY12HeightMargin;

}
@end
