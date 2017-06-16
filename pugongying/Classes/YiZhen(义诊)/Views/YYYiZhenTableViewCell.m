//
//  YYYiZhenTableViewCell.m
//  pugongying
//
//  Created by wyy on 16/3/8.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenTableViewCell.h"

#import "YYYiZhenCaseFrame.h"
#import "YYClinicModel.h"
#import "YYYizhenUserModel.h"

@interface YYYiZhenTableViewCell ()

/**
 *  案例名称Label
 */
@property (nonatomic, weak) UILabel *caseNameLabel;
/**
 *  案例平台Label
 */
@property (nonatomic, weak) UILabel *caseSortLabel;
//问题
/**
 *  用户头像ImageView
 */
@property (nonatomic, weak) UIImageView *userIconImageView;
/**
 *  用户昵称Label
 */
@property (nonatomic, weak) UILabel *userNameLabel;
/**
 *  问题描述Label
 */
@property (nonatomic, weak) UILabel *questionIntroLabel;
//回答
/**
 *  回答者头像ImageView
 */
@property (nonatomic, weak) UIImageView *answerIconImageView;
/**
 *  回答者昵称Label
 */
@property (nonatomic, weak) UILabel *answerNameLabel;
/**
 *  义诊结果Label
 */
@property (nonatomic, weak) UILabel *answerResultLabel;
/**
 *  查看详细按钮
 */
@property (nonatomic, weak) UIButton *seeBtn;
/**
 *  义诊名称下的线
 */
@property (nonatomic, weak) UIView *line1View;
/**
 *  问题下的线
 */
@property (nonatomic, weak) UIView *line2View;
/**
 *  回答下的线
 */
@property (nonatomic, weak) UIView *line3View;
/**
 *  提交时间Label
 */
@property (nonatomic, weak) UILabel *createLabel;
@end

/**
 * tag值为0表示创建义诊案例的单元格，1表示创建我的提单的单元格
 */
NSInteger _cellTag;

@implementation YYYiZhenTableViewCell
+ (YYYiZhenTableViewCell *)yiZhenTableViewCellWithTableView:(UITableView *)tableView andTag:(NSInteger)tag{
    _cellTag = tag;
    static NSString *ID = @"YYYiZhenTableViewCell";
    YYYiZhenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYYiZhenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  案例名称Label
         */
        UILabel *caseNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:caseNameLabel];
        self.caseNameLabel = caseNameLabel;
        self.caseNameLabel.textColor = YYGrayTextColor;
        /**
         *  案例平台Label
         */
        UILabel *caseSortLabel = [[UILabel alloc] init];
        [self.contentView addSubview:caseSortLabel];
        self.caseSortLabel = caseSortLabel;
        self.caseSortLabel.textAlignment = NSTextAlignmentRight;
        self.caseSortLabel.textColor = [UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0];
        self.caseSortLabel.font = [UIFont systemFontOfSize:14];
        /**
         *  义诊名称下的线
         */
        UIView *line1View = [[UIView alloc] init];
        [self.contentView addSubview:line1View];
        self.line1View = line1View;
        self.line1View.backgroundColor = YYGrayLineColor;
        
        //问题
        /**
         *  用户头像ImageView
         */
        UIImageView *userIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:userIconImageView];
        self.userIconImageView = userIconImageView;
        CGFloat userIconW = 55;
        self.userIconImageView.layer.cornerRadius = userIconW/2.0;//设置圆的半径
        self.userIconImageView.layer.masksToBounds = YES;
        /**
         *  用户昵称Label
         */
        UILabel *userNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
        self.userNameLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        self.userNameLabel.font = [UIFont systemFontOfSize:15];
        /**
         *  问题描述Label
         */
        UILabel *questionIntroLabel = [[UILabel alloc] init];
        [self.contentView addSubview:questionIntroLabel];
        self.questionIntroLabel = questionIntroLabel;
        self.questionIntroLabel.textColor = YYGrayTextColor;
        self.questionIntroLabel.font = [UIFont systemFontOfSize:16];
        /**
         *  问题下的线
         */
        UIView *line2View = [[UIView alloc] init];
        [self.contentView addSubview:line2View];
        self.line2View = line2View;
        self.line2View.backgroundColor = YYGrayLineColor;
        
        //回答
        /**
         *  回答者头像ImageView
         */
        UIImageView *answerIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:answerIconImageView];
        self.answerIconImageView = answerIconImageView;
        self.answerIconImageView.layer.cornerRadius = userIconW/2.0;
        self.answerIconImageView.layer.masksToBounds = YES;
        /**
         *  回答者昵称Label
         */
        UILabel *answerNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:answerNameLabel];
        self.answerNameLabel = answerNameLabel;
        self.answerNameLabel.textColor = [UIColor colorWithRed:10/255.0 green:21/255.0 blue:72/255.0 alpha:1.0];
        self.answerNameLabel.font = [UIFont systemFontOfSize:15];
        /**
         *  义诊结果Label
         */
        UILabel *answerResultLabel = [[UILabel alloc] init];
        [self.contentView addSubview:answerResultLabel];
        self.answerResultLabel = answerResultLabel;
        self.answerResultLabel.textColor = [UIColor colorWithRed:10/255.0 green:21/255.0 blue:72/255.0 alpha:1.0];
        self.answerResultLabel.font = [UIFont systemFontOfSize:16];
        /**
         *  回答下的线
         */
        UIView *line3View = [[UIView alloc] init];
        [self.contentView addSubview:line3View];
        self.line3View = line3View;
        self.line3View.backgroundColor = YYGrayLineColor;

        /**
         *  查看详细按钮
         */
        UIButton *btn = [[UIButton alloc] init];
        [self.contentView addSubview:btn];
        self.seeBtn = btn;
        [self.seeBtn setBackgroundImage:[UIImage imageNamed:@"yizhen_seeBtnBG"] forState:UIControlStateNormal];
        [self.seeBtn setTitle:@"查看详细" forState:UIControlStateNormal];
        [self.seeBtn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
        self.seeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.seeBtn addTarget:self action:@selector(seeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  提交时间Label
         */
        UILabel *createLabel = [[UILabel alloc] init];
        [self.contentView addSubview:createLabel];
        self.createLabel = createLabel;
        self.createLabel.font = [UIFont systemFontOfSize:15];
        self.createLabel.textColor = YYGrayTextColor;
    }
    return self;
}

- (void)setModelFrame:(YYYiZhenCaseFrame *)modelFrame{
    _modelFrame = modelFrame;

    YYClinicModel *model = modelFrame.model;
    

    //用户模型
    YYYizhenUserModel *userMessageModel = model.userModel;
    
    //发布时间
    NSString *createDate = model.createTime;
    //义诊是否完成
    NSString *finish = model.done;
    //平台
    NSString *platform = nil;
    if ([model.categoryid isEqualToString:@"1"]) platform = @"淘宝";
    else if ([model.categoryid isEqualToString:@"2"]) platform = @"1688";
    else if ([model.categoryid isEqualToString:@"3"]) platform = @"国际站";
    //问题描述
    NSString *questionIntro = model.content;
    //回答结果
    NSString *result = model.result;
    //义诊标题
    NSString *title = model.title;
    
    /**
     *  提交时间Label 案例名称Label
     */
    self.createLabel.frame = modelFrame.createLabelF;
    NSRange range = NSMakeRange(0, createDate.length - 3);
    createDate = [createDate substringWithRange:range];
    self.createLabel.text = [NSString stringWithFormat:@"%@ 提交",createDate];
    
    self.caseNameLabel.frame = modelFrame.caseNameF;
    
#pragma mark 根据tag值区分哪种单元格
    if (_cellTag == 1) {//我的订单,不隐藏创建时间,显示义诊状态
        self.createLabel.hidden = NO;
        if ([finish isEqualToString:@"1"]) {
            self.caseNameLabel.text = @"义诊已完成";
            self.caseNameLabel.textColor = [UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0];
            self.answerResultLabel.text = result;
        }
        else{
            self.caseNameLabel.text = @"等待义诊结果";
            self.caseNameLabel.textColor = [UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0];
            NSString * contentStr = @"【系统通知】您好，您的义诊申请我们已经收到，核对后会给您回复，本次义诊预计在48小时内完成，还请您耐心等待。";
            self.answerResultLabel.text = contentStr;
        }
        
    }
    else if (_cellTag == 0){//义诊案例,隐藏创建时间，显示案例名称
        self.createLabel.hidden = YES;
        self.caseNameLabel.text = title;
        self.answerResultLabel.text = result;
    }
    /**
     *  案例平台Label
     */
    self.caseSortLabel.frame = modelFrame.caseSortF;
    self.caseSortLabel.text = [NSString stringWithFormat:@"网店平台：%@",platform];
    
    /**
     *  义诊名称下的线
     */
    CGFloat line1Y = CGRectGetMaxY(modelFrame.caseNameF) + YY10HeightMargin;
    self.line1View.frame = CGRectMake(0, line1Y, YYWidthScreen, 0.5);
    //问题
    /**
     *  用户头像ImageView
     */
    
    self.userIconImageView.frame = modelFrame.userIconStrF;
    if (userMessageModel.userIocnImgUrl) {
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userMessageModel.userIocnImgUrl] placeholderImage:[UIImage imageNamed:@"profile_iconmoren"]];
    }
    else{
        self.userIconImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    }
    /**
     *  用户昵称Label
     */
    self.userNameLabel.frame = modelFrame.userNameF;
    self.userNameLabel.text = userMessageModel.userName;
    /**
     *  问题描述Label
     */
    self.questionIntroLabel.frame = modelFrame.questionIntroF;
    self.questionIntroLabel.text = questionIntro;
    self.questionIntroLabel.numberOfLines = 0;
    /**
     *  问题下的线
     */
    CGFloat line2Y = CGRectGetMaxY(modelFrame.questionIntroF) + YY10HeightMargin;
    CGFloat line2W = YYWidthScreen - YY18WidthMargin * 2;
    self.line2View.frame = CGRectMake(YY18WidthMargin, line2Y, line2W, 0.5);
    //回答
    /**
     *  回答者头像ImageView
     */
    self.answerIconImageView.frame = modelFrame.answerIconUrlF;
    self.answerIconImageView.image = [UIImage imageNamed:@"yizhen_answer_iocn"];

    /**
     *  回答者昵称Label
     */
    self.answerNameLabel.frame = modelFrame.answerNameF;
    self.answerNameLabel.text = @"小Pú";
    /**
     *  义诊结果Label
     */
    self.answerResultLabel.frame = modelFrame.answerResultF;
    
    self.answerResultLabel.numberOfLines = 0;
    /**
     *  回答下的线
     */
    CGFloat line3Y = CGRectGetMaxY(modelFrame.answerResultF) + YY10HeightMargin;
    self.line3View.frame = CGRectMake(YY18WidthMargin, line3Y, line2W, 0.5);
    /**
     *  查看详细按钮的Frame
     */
    CGFloat answerBtnW = 90;
    CGFloat answerBtnH = 21;
    CGFloat answerBtnX = YYWidthScreen - YY18WidthMargin - answerBtnW;
    CGFloat answerBtnY = line3Y + YY12HeightMargin;
    self.seeBtn.frame = CGRectMake(answerBtnX, answerBtnY, answerBtnW, answerBtnH);

}

#pragma 查看详细按钮被点击
- (void)seeBtnClick{
    
    YYClinicModel *model = self.modelFrame.model;
    if ([self.delegate respondsToSelector:@selector(seeBtnClickWithModel:)]) {
        [self.delegate seeBtnClickWithModel:model];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
