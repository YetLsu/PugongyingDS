//
//  YYYiZhenAnswerView.m
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenAnswerView.h"

#import "YYClinicModel.h"
#import "YYYizhenUserModel.h"

@interface YYYiZhenAnswerView ()
/**
 *背景图片
 */
@property (nonatomic, weak) UIImageView *bgImageView;
/**
 *  用户头像ImageView
 */
@property (nonatomic, weak) UIImageView *userIconImageView;
/**
 *  用户昵称Label
 */
@property (nonatomic, weak) UILabel *userNameLabel;
/**
 *  蒲公英名字下方的蒲公英官方义诊Label
 */
@property (nonatomic, weak) UILabel *pugongyingLabel;
/**
 *  义诊已完成图片ImageView
 */
@property (nonatomic, weak) UIImageView *yizhenFinishImageView;
/**
 *  回复内容Label
 */
@property (nonatomic, weak) UILabel *answerContentLabel;
/**
 *  回复时间Label
 */
@property (nonatomic, weak) UILabel *answerDateLabel;


@end

@implementation YYYiZhenAnswerView
+ (instancetype) yiZhenAnswerViewWithFrame:(CGRect)viewFrame{
    YYYiZhenAnswerView *answerView = [[YYYiZhenAnswerView alloc] initWithFrame:viewFrame];
    
    return answerView;
}
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        /**
         *背景图片
         */
        UIImageView *bgView = [[UIImageView alloc] init];
        [self addSubview:bgView];
        bgView.image = [UIImage imageNamed:@"yizhen_detailsBG"];
        bgView.contentMode = UIViewContentModeScaleToFill;
        self.bgImageView = bgView;
        /**
         *  用户头像ImageView
         */
        UIImageView *userIconImageView = [[UIImageView alloc] init];
        [self addSubview:userIconImageView];
        self.userIconImageView = userIconImageView;
        /**
         *  用户昵称Label
         */
        UILabel *userNameLabel = [[UILabel alloc] init];
        [self addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
        self.userNameLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        self.userNameLabel.font = [UIFont systemFontOfSize:15];

        /**
         *  蒲公英名字下方的蒲公英官方义诊Label
         */
        UILabel *pugongyingLabel = [[UILabel alloc] init];
        [self addSubview:pugongyingLabel];
        self.pugongyingLabel = pugongyingLabel;
        self.pugongyingLabel.textColor = YYGrayTextColor;
        self.pugongyingLabel.font = [UIFont systemFontOfSize:14];
        self.pugongyingLabel.text = @"蒲公英官方义诊";
        /**
         *  义诊已完成图片ImageView
         */
        UIImageView *yizhenFinishImageView = [[UIImageView alloc] init];
        [self addSubview:yizhenFinishImageView];
        self.yizhenFinishImageView = yizhenFinishImageView;
        self.yizhenFinishImageView.image = [UIImage imageNamed:@"yizhen_finishImage"];
        /**
         *  回复内容Label
         */
        UILabel *answerContentLabel = [[UILabel alloc] init];
        [self addSubview:answerContentLabel];
        self.answerContentLabel = answerContentLabel;
        self.answerContentLabel.textColor = YYGrayTextColor;
        self.answerContentLabel.numberOfLines = 0;
        /**
         *  回复时间Label
         */
        UILabel *answerDateLabel = [[UILabel alloc] init];
        [self addSubview:answerDateLabel];
        self.answerDateLabel = answerDateLabel;
        self.answerDateLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        self.answerDateLabel.font = [UIFont systemFontOfSize:13];
        self.answerDateLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setAnswerModelFrame:(YYYiZhenAnswerFrame *)answerModelFrame{
    _answerModelFrame = answerModelFrame;
    
    
    YYClinicModel *model = answerModelFrame.model;

    //是否完成
    NSString *finish = model.done;
    //回复时间
    NSString *replyTime = model.replyTime;
    //发布时间
    NSString *createTime = model.createTime;
    //回复内容
    NSString *result = model.result;
    
    self.bgImageView.frame = answerModelFrame.bgImageViewF;
    /**
     *  官方头像ImageView
     */
    self.userIconImageView.frame = answerModelFrame.userIconStrF;
    self.userIconImageView.image = [UIImage imageNamed:@"yizhen_answer_iocn"];
    
    self.userIconImageView.layer.cornerRadius = answerModelFrame.userIconStrF.size.width/2.0;
    self.userIconImageView.layer.masksToBounds = YES;
    /**
     *  官方昵称Label
     */
    self.userNameLabel.frame = answerModelFrame.userNameF;
    self.userNameLabel.text = @"小Pú";
    /**
     *  蒲公英名字下方的蒲公英官方义诊Label
     */
    self.pugongyingLabel.frame = answerModelFrame.pugongyingF;
    /**
     *  义诊已完成图片ImageView
     */
   
    self.yizhenFinishImageView.frame = answerModelFrame.yizhenFinishF;

    /**
     *  回复内容Label
     */
    NSString *replyDate;
    NSRange range = NSMakeRange(0, createTime.length - 3);
    self.answerContentLabel.frame = answerModelFrame.answerContentF;
    if ([finish isEqualToString:@"1"]) {//完成义诊   图片hidden属性为NO
        self.answerContentLabel.text = result;
        replyDate = [replyTime substringWithRange:range];
        self.yizhenFinishImageView.hidden = NO;

    }
    else{
        NSString * contentStr = @"【系统通知】您好，您的义诊申请我们已经收到，核对后会给您回复，本次义诊预计在48小时内完成，还请您耐心等待。";
        self.answerContentLabel.text = contentStr;
        replyDate = [createTime substringWithRange:range];
        self.yizhenFinishImageView.hidden = YES;

    }

    /**
     *  回复时间Label
     */
    self.answerDateLabel.frame = answerModelFrame.answerDateF;
    self.answerDateLabel.text = [NSString stringWithFormat:@"%@ 回复",replyDate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
