//
//  YYYiZhenAnswerFrame.m
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenAnswerFrame.h"
#import "YYClinicModel.h"

@implementation YYYiZhenAnswerFrame
- (void)setModel:(YYClinicModel *)model{
    _model = model;
    
    CGFloat superViewWidth = YYWidthScreen - YY18WidthMargin * 2;
    /**
     *  用户头像Frame
     */
    CGFloat userIconW = 55;
    self.userIconStrF = CGRectMake(YY12WidthMargin, YY12HeightMargin, userIconW, userIconW);
    /**
     *  用户昵称Frame
     */
    CGFloat userNameY = YY12HeightMargin;
    CGFloat userNameW = (superViewWidth - YY12WidthMargin * 2 - userIconW)/2.0;
    CGFloat userNameH = 20;
    CGFloat userNameX = YY12WidthMargin + userIconW + 5;
    self.userNameF = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    /**
     *  蒲公英名字下方的蒲公英官方义诊LabelFrame
     */
    CGFloat pugongyingY = userNameY + userNameH + 10;
    CGFloat pugongyingW = superViewWidth - userNameX;
    self.pugongyingF = CGRectMake(userNameX, pugongyingY, pugongyingW, userNameH);
    /**
     *  义诊已完成图片Frame
     */
    CGFloat yizhenFinishW = 85;
    CGFloat yizhenFinishH = 40;
    CGFloat yizhenFinishY = YY12HeightMargin + 6;
    CGFloat yizhenFinishX = superViewWidth - yizhenFinishW - YY12WidthMargin;
    self.yizhenFinishF = CGRectMake(yizhenFinishX, yizhenFinishY, yizhenFinishW, yizhenFinishH);
    /**
     *  回复内容LabelFrame
     */
    NSString *contentStr = nil;
    
    
    if ([model.done isEqualToString:@"1"]) {//已回复
        contentStr = model.result;
    }
    else{//系统回复
        contentStr = @"【系统通知】您好，您的义诊申请我们已经收到，核对后会给您回复，本次义诊预计在48小时内完成，还请您耐心等待。";
    }
    
    CGFloat contentStrW = superViewWidth - 2 * YY12WidthMargin;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    CGFloat contentStrH = [contentStr boundingRectWithSize:CGSizeMake(contentStrW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    CGFloat contentStrY = self.userIconStrF.origin.y + self.userIconStrF.size.height + YY12HeightMargin;
    self.answerContentF = CGRectMake(YY12WidthMargin, contentStrY, contentStrW, contentStrH);
    
    CGFloat answerDateY = contentStrY + contentStrH + YY12HeightMargin;
    self.answerDateF = CGRectMake(YY18WidthMargin, answerDateY, superViewWidth - YY18WidthMargin * 2, 20);
    
    self.viewHeight = answerDateY + self.answerDateF.size.height + YY12HeightMargin;
    
    self.bgImageViewF = CGRectMake(0, 0, superViewWidth, self.viewHeight);
}


@end
