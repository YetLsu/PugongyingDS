//
//  YYCourseCommentCell.m
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCommentCell.h"
#import "YYCourseCommentFrame.h"
#import "YYCourseCommentModel.h"

#define starH 12.5
#define starW 13.5
#define starMargin 5
#define userNameH 14
#define userNameFont [UIFont systemFontOfSize:15]

@interface YYCourseCommentCell ()

/**
 *  用户头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 *  用户昵称
 */
@property (nonatomic, weak) UILabel *userNameLabel;
/**
 *  评论内容
 */
@property (nonatomic, weak) UILabel *commentLabel;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel *dateLabel;
/**
 *  线
 */
@property (nonatomic, weak) UIView *lineView;
/**
 *  五颗星星实的imageView
 */
@property (nonatomic, weak) UIImageView *haveFiveStarImageView;
/**
 *  五颗星星空的imageView
 */
@property (nonatomic, weak) UIImageView *noFiveStarImageView;
@end

static NSString *ID = @"YYCourseCommentCell";
@implementation YYCourseCommentCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)courseCellWithTableView:(UITableView *)tableView{
    YYCourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCourseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:ID]) {
    
//      用户头像
        CGFloat iconViewH = 50;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(YY18WidthMargin, YY12HeightMargin, iconViewH, iconViewH)];
        [self.contentView addSubview:iconView];
        self.iconImageView = iconView;
        self.iconImageView.layer.cornerRadius = iconViewH/2.0;
        self.iconImageView.layer.masksToBounds = YES;
       
        
        //用户昵称
        CGFloat userNameX = YY18WidthMargin + iconViewH + YY12WidthMargin;
        CGFloat userNameY = 16/667.0*YYHeightScreen;
        CGFloat userNameW = YYWidthScreen - iconView.width - 2 *YY18WidthMargin;
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userNameY, userNameW, userNameH)];
        [self.contentView addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
        self.userNameLabel.textColor = YYGrayTextColor;
        self.userNameLabel.font = userNameFont;

        
        //用户评论内容
        CGFloat commentLabelX = userNameX;
        CGFloat commentLabelY = CGRectGetMaxY(userNameLabel.frame) + YY10HeightMargin;
        CGFloat commentLabelW = YYWidthScreen - userNameX - YY18WidthMargin;
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentLabelX, commentLabelY, commentLabelW, 0)];
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        self.commentLabel.numberOfLines = 0;
        
        /**
         *  五颗星星空的imageView
         */
        CGFloat starNoW = starW * 5 + starMargin *4;
        UIImageView *noFiveStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(commentLabelX, 0, starNoW, starH)];
        [self.contentView addSubview:noFiveStarImageView];
        self.noFiveStarImageView = noFiveStarImageView;
        self.noFiveStarImageView.image = [UIImage imageNamed:@"small_noFiveStar"];
        /**
         *  五颗星星实的imageView
         */
        UIImageView *haveFiveStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(commentLabelX, 0, starNoW, starH)];
        [self.contentView addSubview:haveFiveStarImageView];
        self.haveFiveStarImageView = haveFiveStarImageView;
        self.haveFiveStarImageView.image = [UIImage imageNamed:@"small_haveFiveStar"];
        self.haveFiveStarImageView.contentMode =  UIViewContentModeLeft;

        //时间label
        CGFloat timeLabelW = 120;
        CGFloat timeLabelX = YYWidthScreen - timeLabelW - YY18WidthMargin;
        CGFloat timeLabelH = 14;
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, 0, timeLabelW, timeLabelH)];
        [self.contentView addSubview:timeLabel];
        self.dateLabel = timeLabel;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = YYGrayTextColor;
        self.dateLabel.font = [UIFont systemFontOfSize:13];

        //加一条线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(commentLabelX, 0, YYWidthScreen - commentLabelX, 0.5)];
        lineView.backgroundColor = YYGrayLineColor;
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
        

    }
    return self;
}
- (void)setModelFrame:(YYCourseCommentFrame *)modelFrame{
    _modelFrame = modelFrame;
    
    YYCourseCommentModel *model = modelFrame.model;
    
//    YYLog(@"%@",model.iconURLStr);
    if (model.iconURLStr) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconURLStr]];
    }
    else{
        self.iconImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    }
    
    self.userNameLabel.text = model.userName;
    
    self.commentLabel.text = model.commentStr;
    
    //设置评论高度以及线的y值
    self.commentLabel.height = modelFrame.commentLabelH;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.commentStr];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, model.commentStr.length)];
    
    self.commentLabel.attributedText = attributedStr;
    
    //设置星星的Y值
    self.haveFiveStarImageView.y = CGRectGetMaxY(self.commentLabel.frame) + YY10HeightMargin;
    self.noFiveStarImageView.y = self.haveFiveStarImageView.y;
    //设置实的星星的宽度
    CGFloat starNumber = model.commentScore.floatValue;
    
    NSInteger marginNumber = (NSInteger)starNumber;
    CGFloat starHaveW = starW * starNumber + starMargin * marginNumber;
    
    self.haveFiveStarImageView.width = starHaveW;
    
    [self.haveFiveStarImageView setContentScaleFactor:2];
    
    self.haveFiveStarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;//根据你的需求
    
    self.haveFiveStarImageView.clipsToBounds  = YES;//切掉多余部分

    //设置时间的Y值
    self.dateLabel.y = self.haveFiveStarImageView.y;
    self.dateLabel.text = model.dateStr;
    
    self.lineView.y = CGRectGetMaxY(self.dateLabel.frame) + YY12HeightMargin;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
