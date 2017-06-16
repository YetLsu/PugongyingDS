//
//  YYYiZhenQuestionFrame.m
//  pugongying
//
//  Created by wyy on 16/3/9.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenQuestionFrame.h"
#import "YYClinicModel.h"

@implementation YYYiZhenQuestionFrame
- (void)setModel:(YYClinicModel *)model{
    _model = model;
    CGFloat heightMargin = 20/667.0*[UIScreen mainScreen].bounds.size.height;
    
    
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
     *  案例平台Frame
     */
    CGFloat platformW = userNameW;
    CGFloat platformH = userNameH;
    CGFloat platformX = userNameX + userNameW;
    self.platformF = CGRectMake(platformX, userNameY, platformW, platformH);
    //    店铺网址和手机号交换位置
    /**
     *  店铺网址Frame
     */
    CGFloat storeAddressY = userNameY + userNameH + 10;
    CGFloat storeAddressW = superViewWidth - userNameX;
    self.phoneNumberF = CGRectMake(userNameX, storeAddressY, storeAddressW, userNameH);
    /**
     *  电话号码Frame
     */
    CGFloat phoneNumberY = CGRectGetMaxY(self.userIconStrF) + YY10HeightMargin;
    CGFloat phoneNumberW = superViewWidth - YY12WidthMargin * 2;
    self.storeAddressF = CGRectMake(YY12WidthMargin, phoneNumberY, phoneNumberW, userNameH);
    /**
     *  QQ号码Frame
     */
    CGFloat QQY = phoneNumberY + userNameH + heightMargin;
    self.QQF = CGRectMake(YY12WidthMargin, QQY, phoneNumberW, userNameH);
    /**
     *  elem2LabelFrame
     */
    CGFloat elem2LabelY = QQY + userNameH + heightMargin;
    self.elem2LabelF = CGRectMake(YY12WidthMargin, elem2LabelY, phoneNumberW, userNameH);
    /**
     *  elem3LabelFrame
     */
    CGFloat elem3LabelY = elem2LabelY + heightMargin + userNameH;
    self.elem3LabelF = CGRectMake(YY12WidthMargin, elem3LabelY, phoneNumberW, userNameH);
    /**
     *  elem4LabelFrame
     */
    CGFloat elem4LabelY = elem3LabelY + heightMargin + userNameH;
    self.elem4LabelF = CGRectMake(YY12WidthMargin, elem4LabelY, phoneNumberW, userNameH);
    
    /**
     *  问题描述
     */
    CGFloat introY = elem4LabelY + heightMargin + userNameH;
    //
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.questionIntro];
    //
    //    NSMutableParagraphStyle *paraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraphStyle.lineSpacing = 5;
    //
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paraphStyle range:NSMakeRange(0, model.questionIntro.length)];
    //
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    //    attr[NSParagraphStyleAttributeName] = paraphStyle;
    
    CGFloat introH = [model.content boundingRectWithSize:CGSizeMake(phoneNumberW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    //    CGFloat introH = [attributedString boundingRectWithSize:CGSizeMake(phoneNumberW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    
    self.questionIntroF = CGRectMake(YY12WidthMargin, introY, phoneNumberW, introH);
    
    //    /**
    //     *  是否专人负责Frame
    //     */
    CGFloat someoneY = introY + introH + YY10HeightMargin;
    CGFloat someoneX = YY12WidthMargin;
    CGFloat someoneW = 60;
    self.someoneF = CGRectMake(someoneX, someoneY, someoneW, userNameH);
    //    /**
    //     *  发布时间Frame
    //     */
    CGFloat createDateX = someoneX + someoneW;
    CGFloat createSateW = superViewWidth - createDateX - YY12WidthMargin - 3;
    self.createDateF = CGRectMake(createDateX, someoneY, createSateW, userNameH);
    
    /**
     *  view的高
     */
    self.viewHeight = someoneY + userNameH + YY10HeightMargin;
    self.bgImageViewF = CGRectMake(0, 0, superViewWidth, self.viewHeight);

}


@end
