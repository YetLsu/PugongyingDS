//
//  YYMyMessageFrame.m
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMyMessageFrame.h"
#import "YYMyMessageModel.h"

@implementation YYMyMessageFrame

- (void)setModel:(YYMyMessageModel *)model{
    _model = model;
    /**
     *  左边的点的imageView的frame
     */
    CGFloat readImageViewX = YY18WidthMargin;
    CGFloat readImageViewY = YY10HeightMargin + 3;
    CGFloat readImageViewW = 7.5;
    CGFloat readImageViewH = readImageViewW;
    self.readImageViewF = CGRectMake(readImageViewX, readImageViewY, readImageViewW, readImageViewH);
    /**
     *  消息类型的label的frame
     */
    CGFloat timeW = 100;
    
    CGFloat sortX = readImageViewX + readImageViewW + 5;
    CGFloat sortY = YY10HeightMargin;
    CGFloat sortW = YYWidthScreen - timeW - YY18WidthMargin - sortX;
    CGFloat sortH = 17;
    self.messageSortLabelF = CGRectMake(sortX, sortY, sortW, sortH);
    /**
     *  消息内容的label的frame
     */
    CGFloat contentX = sortX;
    CGFloat contentY = sortY + sortH + 2;
    CGFloat contentW = sortW;
    CGFloat contentH = 14;
    self.messageContentLabelF = CGRectMake(contentX, contentY, contentW, contentH);
    /**
     *  单元格高度
     */
    self.cellHeight = CGRectGetMaxY(self.messageContentLabelF) + YY12HeightMargin;
    /**
     *  消息时间的label的frame
     */
    CGFloat timeH = self.cellHeight;
    CGFloat timeX = YYWidthScreen - timeW - YY18WidthMargin;
    self.messageTimeLabelF = CGRectMake(timeX, 0, timeW, timeH);

}
@end
