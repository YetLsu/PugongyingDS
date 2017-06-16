//
//  YYQuestionStateCell.m
//  pugongying
//
//  Created by wyy on 16/3/1.
//  Copyright © 2016年 WYY. All rights reserved.
//

#define YYGrayTextThisColor [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1]
#import "YYQuestionStateCell.h"
#import "YYQuestionStateCellFrame.h"
#import "YYQuestionStateModel.h"

@interface YYQuestionStateCell ()
/**
 *  头像ImageView
 */
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 *  昵称Label
 */
@property (nonatomic, weak) UILabel *userNameLabel;

/**
 *  正文Label
 */
@property (nonatomic, weak) UILabel *contentTextLabel;
/**
 *  时间Label
 */
@property (nonatomic, weak) UILabel *dateTextLabel;
/**
 *  回答人数Label
 */
@property (nonatomic, weak) UILabel *answerNumberLabel;
///**
// *  金币View
// */
//@property (nonatomic, weak) UIView *coinView;
///**
// *  悬赏值Label
// */
//@property (nonatomic, weak) UILabel *rewardNumberLabel;
/**
 *  状态Label
 */
@property (nonatomic, weak) UILabel *stateLabel;
/**
 *  标签Label
 */
@property (nonatomic, weak) UILabel *markLabel;
/**
 *  标签ImageView
 */
@property (nonatomic, weak) UIImageView *markImageView;
/**
 *  回答人数ImageView
 */
@property (nonatomic, weak) UIImageView *answerNumberImageView;
/**
 *  灰色块
 */
@property (nonatomic, weak) UIView *grayView;
@end

@implementation YYQuestionStateCell
+ (instancetype) questionCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYQuestionStateCell";
    YYQuestionStateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYQuestionStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //增加头像imageView
        CGFloat iconViewY = YY12HeightMargin;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(YY18WidthMargin, iconViewY, 35, 35)];
        [self.contentView addSubview:iconView];
        self.iconImageView = iconView;
        
        
        //增加昵称label
        CGFloat nameLabelX = YY18WidthMargin + 35 + 8;
        CGFloat nameLabelY = iconViewY;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, YYWidthScreen - nameLabelX - YY18WidthMargin * 2, 35)];
        [self.contentView addSubview:nameLabel];
        self.userNameLabel = nameLabel;
        nameLabel.textColor = YYGrayTextThisColor;
//        /**
//         *  状态Label
//         */
        CGFloat stateLabelW = 50;
        CGFloat stateLabelH = 20;
        CGFloat stateLabelX = YYWidthScreen - YY18WidthMargin - stateLabelW;
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateLabelX, YY10HeightMargin +10, stateLabelW, stateLabelH)];
        [self.contentView addSubview:stateLabel];
        self.stateLabel = stateLabel;
        self.stateLabel.font = [UIFont systemFontOfSize:15];
 
        //增加内容label
        CGFloat textLabelY = iconViewY + 35 + YY12HeightMargin;
        CGFloat textLabelW = YYWidthScreen - 2*YY18WidthMargin;
        UILabel *contentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, textLabelY, textLabelW, 0)];
        contentTextLabel.numberOfLines = 0;
        [self.contentView addSubview:contentTextLabel];
        self.contentTextLabel = contentTextLabel;
        
        /**
         *  标签Label和标签图片
         */
        CGFloat markImageW = 13;
        UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY18WidthMargin, 0, markImageW, markImageW)];
        [self.contentView addSubview:markImageView];
        markImageView.image = [UIImage imageNamed:@"home_question_5"];
        self.markImageView = markImageView;
        
        CGFloat markLabelX = YY18WidthMargin + 13 + 8;
        CGFloat markLabelW = YYWidthScreen - YY18WidthMargin - markLabelX;
        UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(markLabelX, 0, markLabelW, 14)];
        [self.contentView addSubview:markLabel];
        self.markLabel = markLabel;
        markLabel.textColor = YYGrayTextThisColor;
        markLabel.font = [UIFont systemFontOfSize:15];
        
        /**
         *  时间Label
         */
        CGFloat dateLabelH = 14;
        CGFloat dateLabelW = YYWidthScreen/2 - YY18WidthMargin;
        UILabel *dateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, 0, dateLabelW, dateLabelH)];
        [self.contentView addSubview:dateTextLabel];
        self.dateTextLabel = dateTextLabel;
        /**
         *  回答人数Label和图片
         */
        CGFloat answerLabelAndImageViewW = 65;
        
        CGFloat answerIVW = 16;
        CGFloat answerIVX = YYWidthScreen - YY18WidthMargin - answerLabelAndImageViewW;
        UIImageView *answerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(answerIVX, 0, answerIVW, answerIVW)];
        [self.contentView addSubview:answerImageView];
        answerImageView.image = [UIImage imageNamed:@"home_question_4"];
        self.answerNumberImageView = answerImageView;
        
        CGFloat answerLabelX = answerIVX + answerIVW;
        CGFloat ansWerLabelH = 16;
        CGFloat answerLabelW = answerLabelAndImageViewW - answerIVW;
        UILabel *answerNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(answerLabelX, 0, answerLabelW, ansWerLabelH)];
        [self.contentView addSubview:answerNumberLabel];
        self.answerNumberLabel = answerNumberLabel;
        self.answerNumberLabel.textAlignment = NSTextAlignmentRight;
        
//        //加下面的灰色块
//        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, YY12HeightMargin)];
//        [self.contentView addSubview:grayView];
//        self.grayView = grayView;
//        self.grayView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    }
    return self;
}

- (void)setQuestionCellFrame:(YYQuestionStateCellFrame *)questionCellFrame{
    _questionCellFrame = questionCellFrame;
    YYQuestionStateModel *model = questionCellFrame.model;
    /**
     *  头像ImageView
     */
    self.iconImageView.image = [UIImage imageNamed:@"home_4"];
    /**
     *  昵称Label
     */
    self.userNameLabel.text = model.userName;
    
    /**
     *  正文Label
     */
    self.contentTextLabel.text = model.contentText;
    
    //设置正文高度以及下面控件的y值
    self.contentTextLabel.height = questionCellFrame.contentHeight;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    self.contentTextLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:model.contentText];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, model.contentText.length)];
    
    self.contentTextLabel.attributedText = attributedStr;
    /**
     *  YY12HeightMargin + 35 + YY12HeightMargin + self.contentHeight + YY10HeightMargin + 14 + YY10HeightMargin + YY10HeightMargin + 16 + YY10HeightMargin + YY12HeightMargin;
     
     */
    /**
     *  标签
     *
     */
    CGFloat markImageViewY = YY12HeightMargin + 35 + YY12HeightMargin + questionCellFrame.contentHeight + YY10HeightMargin;
    self.markImageView.y = markImageViewY;
    self.markLabel.y = self.markImageView.y;
    self.markLabel.text = model.markText;
    
    /**
     *  线
     */
    CGFloat lineY = markImageViewY + 14 + YY10HeightMargin;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, lineY, YYWidthScreen, 0.5) andView:self.contentView];
    /**
     *  时间Label
     */
    self.dateTextLabel.text = model.dateText;
    CGFloat dateTextLabelY = lineY + YY10HeightMargin;
    self.dateTextLabel.y = dateTextLabelY;
    self.dateTextLabel.textColor = YYGrayTextThisColor;
    self.dateTextLabel.font = [UIFont systemFontOfSize:15];
    /**
     *  回答人数Label
     */
    self.answerNumberImageView.y = dateTextLabelY;
    self.answerNumberLabel.text = model.answerNumber;
    self.answerNumberLabel.y = dateTextLabelY;
    self.answerNumberLabel.textColor = YYGrayTextThisColor;
    self.answerNumberLabel.font = [UIFont systemFontOfSize:15];
    /**
     *  状态Label
     */
    if (model.state == YYQuestionStateFinshed) {//已解决
        self.stateLabel.text = @"已解决";
        self.stateLabel.textColor = [UIColor colorWithRed:197/255.0 green:100/255.0 blue:208/255.0 alpha:1];
    }
    else if (model.state == YYQuestionStateProgress){//进行中
        self.stateLabel.text = @"进行中";
        self.stateLabel.textColor = [UIColor colorWithRed:219/255.0 green:147/255.0 blue:23/255.0 alpha:1];
    }
    else if (model.state == YYQuestionStateDisable){//失效
        self.stateLabel.text = @"已失效";
        self.stateLabel.textColor = YYGrayTextThisColor;
    }

    /**
     *  灰色View
     */
    CGFloat grayViewY = dateTextLabelY + 16 + YY10HeightMargin;
    self.grayView.y = grayViewY;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

