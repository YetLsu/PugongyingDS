//
//  YYMySeedCellFrame.m
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMySeedCellFrame.h"
#import "YYMySeedCellModel.h"

@implementation YYMySeedCellFrame

- (void)setModel:(YYMySeedCellModel *)model{
    _model = model;
   
    /**
     *  种子左侧的图片F
     */
    CGFloat iconW = 30;
    CGFloat iconY = YY12HeightMargin;
    self.seedLeftIconF = CGRectMake(YY12WidthMargin, iconY, iconW, iconW);
    /**
     *  种子赠送或消耗原因f
     */
    CGFloat seedNumberW = 30;
    
    CGFloat contentX = CGRectGetMaxX(self.seedLeftIconF) + 20/375.0 * YYWidthScreen;
    CGFloat contentW = YYWidthScreen - contentX - YY18WidthMargin - seedNumberW;
    CGFloat contentH = 15;
    self.seedContentF = CGRectMake(contentX, iconY, contentW, contentH);
    /**
     *  种子时间F
     */
    CGFloat timeY = CGRectGetMaxY(self.seedContentF) + 3;
    CGFloat timeH = 12;
    self.timeF = CGRectMake(contentX, timeY, contentW, timeH);
    /**
     *  种子增加或减少量F
     */
    CGFloat seedNumberH = 30;
    CGFloat seedNumberX = YYWidthScreen - seedNumberW - YY18WidthMargin;
    CGFloat seedNumberY = YY12HeightMargin;
    self.seedNumberF = CGRectMake(seedNumberX, seedNumberY, seedNumberW, seedNumberH);
    
    /**
     *  行高
     */
    self.cellHeight = YY12HeightMargin * 2 + iconW;

}

@end
