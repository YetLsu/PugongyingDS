//
//  YYYiZhenQuestionView.m
//  pugongying
//
//  Created by wyy on 16/3/9.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenQuestionView.h"
#import "YYClinicModel.h"
#import "YYYizhenUserModel.h"


@interface YYYiZhenQuestionView ()
/**
 *背景图片
 */
@property (nonatomic, weak) UIImageView *bgImageView;
/**
 *  案例平台Label
 */
@property (nonatomic, weak) UILabel *platformLabel;
/**
 *  用户头像ImageView
 */
@property (nonatomic, weak) UIImageView *userIconImageView;
/**
 *  用户昵称Label
 */
@property (nonatomic, weak) UILabel *userNameLabel;
/**
 *  店铺网址Label
 */
@property (nonatomic, weak) UILabel *storeAddressLabel;
/**
 *  QQ号码Label
 */
@property (nonatomic, weak) UILabel *QQLabel;
/**
 *  电话号码Label
 */
@property (nonatomic, weak) UILabel *phoneNumberLabel;
/**
 *  是否专人负责Label
 */
@property (nonatomic, weak) UILabel *someoneLabel;
/**
 *  发布时间Label
 */
@property (nonatomic, weak) UILabel *createDateLabel;
/**
 *  elem2Label
 */
@property (nonatomic, weak) UILabel *elem2Label;
/**
 *  elem3Label
 */
@property (nonatomic, weak) UILabel *elem3Label;
/**
 *  elem4Label
 */
@property (nonatomic, weak) UILabel *elem4Label;
/**
 *  问题描述
 */
@property (nonatomic, weak) UILabel *questionIntroLabel;
@end

@implementation YYYiZhenQuestionView

+ (instancetype)yiZhenQuestionViewWithFrame:(CGRect)viewFrame{
    YYYiZhenQuestionView *questionView = [[YYYiZhenQuestionView alloc] initWithFrame:viewFrame];
    
    return questionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
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
         *  案例平台Label
         */
        UILabel *platformLabel = [[UILabel alloc] init];
        [self addSubview:platformLabel];
        self.platformLabel = platformLabel;
        self.platformLabel.textAlignment = NSTextAlignmentRight;
        self.platformLabel.textColor = [UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0];
        self.platformLabel.font = [UIFont systemFontOfSize:14];

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
         *  店铺网址Label
         */
        UILabel *storeAddressLabel = [[UILabel alloc] init];
        [self addSubview:storeAddressLabel];
        self.storeAddressLabel = storeAddressLabel;
        self.storeAddressLabel.textColor = YYGrayTextColor;
        self.storeAddressLabel.font = [UIFont systemFontOfSize:14];

        /**
         *  QQ号码Label
         */
        UILabel *QQLabel = [[UILabel alloc] init];
        [self addSubview:QQLabel];
        self.QQLabel = QQLabel;
        self.QQLabel.textColor = YYGrayTextColor;

        /**
         *  电话号码Label
         */
        UILabel *phoneNumberLabel = [[UILabel alloc] init];
        [self addSubview:phoneNumberLabel];
        self.phoneNumberLabel = phoneNumberLabel;
        self.phoneNumberLabel.textColor = YYGrayTextColor;
        self.phoneNumberLabel.font = [UIFont systemFontOfSize:14];

        /**
         *  是否专人负责Label
         */
        UILabel *someoneLabel = [[UILabel alloc] init];
        [self addSubview:someoneLabel];
        self.someoneLabel = someoneLabel;
        self.someoneLabel.text = @"专人负责";
        self.someoneLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        self.someoneLabel.font = [UIFont systemFontOfSize:13];


        /**
         *  发布时间Label
         */
        UILabel *createDateLabel = [[UILabel alloc] init];
        [self addSubview:createDateLabel];
        self.createDateLabel = createDateLabel;
        self.createDateLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        self.createDateLabel.font = [UIFont systemFontOfSize:13];
        self.createDateLabel.textAlignment = NSTextAlignmentRight;

        /**
         *  elme2Label
         */
        UILabel *elme2Label = [[UILabel alloc] init];
        [self addSubview:elme2Label];
        self.elem2Label = elme2Label;
        self.elem2Label.textColor = YYGrayTextColor;
        /**
         *  elme3Label
         */
        UILabel *elme3Label = [[UILabel alloc] init];
        [self addSubview:elme3Label];
        self.elem3Label = elme3Label;
        self.elem3Label.textColor = YYGrayTextColor;
        /**
         *  elme4Label
         */
        UILabel *elme4Label = [[UILabel alloc] init];
        [self addSubview:elme4Label];
        self.elem4Label = elme4Label;
        self.elem4Label.textColor = YYGrayTextColor;
        /**
         *  问题描述
         */
        UILabel *questionIntroLabel = [[UILabel alloc] init];
        [self addSubview:questionIntroLabel];
        self.questionIntroLabel = questionIntroLabel;
        self.questionIntroLabel.textColor = YYGrayTextColor;
        self.questionIntroLabel.numberOfLines = 0;

    }
    return self;
}

- (void)setModelFrame:(YYYiZhenQuestionFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    YYClinicModel *model = modelFrame.model;
    //用户模型
    YYYizhenUserModel *userModel = model.userModel;
    //发布时间
    NSString *createDate = model.createTime;
    //问题描述
    NSString *questionIntro = model.content;
    // 平台
    NSString *platform = nil;
    //网店地址
    NSString *storeAddress = nil;
    //elem2Label
    NSString *elem2Str =  nil;
    //elem3Label
    NSString *elem3Str =  nil;
    //elem2Label
    NSString *elem4Str =  nil;
    
    if ([model.categoryid isEqualToString:@"1"]) {
        platform = @"淘宝";
        storeAddress = [NSString stringWithFormat:@"店铺全称：%@",model.elem1] ;
        elem2Str = [NSString stringWithFormat:@"店铺主营产品：%@",model.elem2];
        elem3Str = [NSString stringWithFormat:@"是否有请美工：%@",model.elem3];
        elem4Str = [NSString stringWithFormat:@"店铺操作时间：%@",model.elem4];
    }
    else if ([model.categoryid isEqualToString:@"2"]){
        platform = @"1688";
        storeAddress = [NSString stringWithFormat:@"公司全称/账号ID：%@",model.elem1];
        elem2Str = [NSString stringWithFormat:@"店铺主营产品：%@",model.elem2];
        elem3Str = [NSString stringWithFormat:@"是否有请美工：%@",model.elem3];
        elem4Str = [NSString stringWithFormat:@"店铺操作时间：%@",model.elem4];
    }
    else if ([model.categoryid isEqualToString:@"3"]){
        platform = @"国际站";
        storeAddress = [NSString stringWithFormat:@"公司全称：%@",model.elem1];
        elem2Str = [NSString stringWithFormat:@"店铺操作时间：%@",model.elem2];
        elem3Str = [NSString stringWithFormat:@"每周上传产品数量：%@",model.elem3];
        elem4Str = [NSString stringWithFormat:@"是否使用P4P业务：%@",model.elem4];
    }
    
    self.bgImageView.frame = modelFrame.bgImageViewF;
    /**
     *  案例平台Label
     */
    self.platformLabel.frame = modelFrame.platformF;
    self.platformLabel.text = [NSString stringWithFormat:@"网店平台：%@",platform];
    /**
     *  用户头像ImageView
     */
    self.userIconImageView.frame = modelFrame.userIconStrF;
    
    if (userModel.userIocnImgUrl) {
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userIocnImgUrl] placeholderImage:[UIImage imageNamed:@"profile_iconmoren"]];
    }
    else{
        self.userIconImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    }
    self.userIconImageView.layer.cornerRadius = modelFrame.userIconStrF.size.width/2.0;
    self.userIconImageView.layer.masksToBounds = YES;
    /**
     *  用户昵称Label
     */
    self.userNameLabel.frame = modelFrame.userNameF;
    self.userNameLabel.text = userModel.userName;
    /**
     *  店铺网址Label
     */
    self.storeAddressLabel.frame = modelFrame.storeAddressF;
    self.storeAddressLabel.text = storeAddress;
    /**
     *  QQ号码Label
     */
    self.QQLabel.frame = modelFrame.QQF;
    self.QQLabel.text = [NSString stringWithFormat:@"QQ：%@",userModel.qq];
    /**
     *  电话号码Label
     */
    self.phoneNumberLabel.frame = modelFrame.phoneNumberF;
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"手机号码：%@",userModel.phone];

    /**
     *  发布时间Label
     */
    self.createDateLabel.frame = modelFrame.createDateF;
    NSRange range = NSMakeRange(0, createDate.length - 3);
    NSString *newCreateDate = [createDate substringWithRange:range];
    self.createDateLabel.text = [NSString stringWithFormat:@"%@ 提交",newCreateDate];
//
    /**
     *  elem2Label
     */
    self.elem2Label.frame = modelFrame.elem2LabelF;
    self.elem2Label.text = elem2Str;

    /**
     *  elem3Label
     */
    self.elem3Label.frame = modelFrame.elem3LabelF;
    self.elem3Label.text = elem3Str;
    /**
     *  elem4Label
     */
    self.elem4Label.frame = modelFrame.elem4LabelF;
    self.elem4Label.text = elem4Str;
    /**
     *  问题描述
     */
    self.questionIntroLabel.frame = modelFrame.questionIntroF;
    self.questionIntroLabel.text = [NSString stringWithFormat:@"问题描述：%@",questionIntro];

}
@end
