//
//  YYYiZhenCaseFrame.m
//  pugongying
//
//  Created by wyy on 16/3/8.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenCaseFrame.h"
#import "YYClinicModel.h"


@implementation YYYiZhenCaseFrame
- (void)setModel:(YYClinicModel *)model{
    _model = model;
    
    /**
     *  案例名称Frame
     */
    CGFloat caseNameLW = (YYWidthScreen - YY18WidthMargin)/2.0;
    CGFloat caseNameLH = 20;
    self.caseNameF = CGRectMake(YY18WidthMargin, YY10HeightMargin, caseNameLW, caseNameLH);
    /**
     *  案例分类Frame
     */
    CGFloat caseSortX = YYWidthScreen - YY18WidthMargin - caseNameLW;
    self.caseSortF = CGRectMake(caseSortX, YY10HeightMargin, caseNameLW, caseNameLH);
    //问题
    /**
     *  用户头像Frame
     */
    CGFloat userIconW = 55;
    CGFloat userIconY = CGRectGetMaxY(self.caseNameF) + YY10HeightMargin + YY12HeightMargin;
    self.userIconStrF = CGRectMake(YY18WidthMargin, userIconY, userIconW, userIconW);
    /**
     *  用户昵称Frame
     */
    CGFloat userNameX = YY18WidthMargin + userIconW + YY12WidthMargin;
    CGFloat userNameW = YYWidthScreen - YY18WidthMargin - userNameX;
    CGFloat userNameH = 23;
    self.userNameF = CGRectMake(userNameX, userIconY, userNameW, userNameH);
    /**
     *  问题描述Frame
     */
    CGFloat questionIntroX = userNameX;
    CGFloat questionIntroY = CGRectGetMaxY(self.userNameF) + 5;
    CGFloat questionIntroW = userNameW;
    CGFloat questionIntroH = 60;
    self.questionIntroF = CGRectMake(questionIntroX, questionIntroY, questionIntroW, questionIntroH);
    //回答
    /**
     *  回答者头像Frame
     */
    CGFloat answerIconY = CGRectGetMaxY(self.questionIntroF) + YY10HeightMargin * 2;
    self.answerIconUrlF = CGRectMake(YY18WidthMargin, answerIconY, userIconW, userIconW);
    /**
     *  回答者昵称Frame
     */
    self.answerNameF = CGRectMake(userNameX, answerIconY, userNameW, userNameH);
    /**
     *  义诊结果Frame
     */
    CGFloat answerResultY = CGRectGetMaxY(self.answerNameF) + 5;
    self.answerResultF = CGRectMake(userNameX, answerResultY, questionIntroW, questionIntroH);
    /**
     *  提交时间LabelFrame
     */
    CGFloat createLabelY = CGRectGetMaxY(self.answerResultF) + YY10HeightMargin + YY12HeightMargin;
    CGFloat createLabelW = 200;
    self.createLabelF = CGRectMake(YY18WidthMargin, createLabelY, createLabelW, 21);
    /**
     *  行高
     */
    CGFloat answerBtnH = 21;
    self.cellHeight = CGRectGetMaxY(self.answerResultF) + YY10HeightMargin + YY12HeightMargin * 2 + answerBtnH;
}

@end
