//
//  YYDetailCourseCell.m
//  pugongying
//
//  Created by wyy on 16/5/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYDetailCourseCell.h"
#import "YYDetailCourseCellFrame.h"
#import "YYCourseCollectionCellModel.h"
#import "YYTeacherModel.h"

#define starH 12.5
#define starW 13.5
#define starMargin 5

@interface YYDetailCourseCell ()
/**
 *  讲师上面标题的View
 */
@property (nonatomic, weak) UIView *teacherTitleView;
/**
 讲师头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 讲师名字
 */
@property (nonatomic,weak) UILabel *nameLabel;
/**
 讲师介绍
 */
@property (nonatomic, weak) UILabel *introduceLabel;
/**
 *  中间灰色的ViewF
 */
@property (nonatomic, weak) UIView *grayView;

/**
 *  课程上面标题的View
 */
@property (nonatomic, weak) UIView *courseTitleView;
/**
 *  评分的View
 */
@property (nonatomic, weak) UIView *commentScoreView;
/**
 *  五颗星星实的imageView
 */
@property (nonatomic, weak) UIImageView *haveFiveStarImageView;
/**
 *  课程目标
 */
@property (nonatomic, weak) UILabel *courseAimLabel;
/**
 *  学习特色
 */
@property (nonatomic, weak) UILabel *coursefFeatureLabel;
/**
 *  适合人群
 */
@property (nonatomic, weak) UILabel *courseSuitPeopleLabel;
/**
 *  课程节数
 */
@property (nonatomic, weak) UILabel *courseNumberLabel;
/**
 *  课程详情
 */
@property (nonatomic, weak)UILabel *courseIntroduceLabel;

@end

@implementation YYDetailCourseCell

+ (instancetype)detailCourseCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYDetailCourseCell";
    YYDetailCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYDetailCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建上面部分的讲师信息View
        [self addTopTeacherView];
        /**
         *  中间灰色的View
         */
        UIView *grayView = [[UIView alloc] init];
        [self.contentView addSubview:grayView];
        self.grayView = grayView;
        self.grayView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
        
        //创建下面部分课程详情的View
        [self addCourseMessageView];
    }
    return self;
}
#pragma mark 创建上面部分的讲师信息View
/**
 *  创建上面部分的讲师信息View
 */
- (void)addTopTeacherView{
    //讲师上面标题的View
    UIView *teacherTitleView = [self createTitleViewWithTitle:@"讲师简介"];
    [self.contentView addSubview:teacherTitleView];
    self.teacherTitleView = teacherTitleView;
    //讲师头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    //讲师名字
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    //讲师介绍
    UILabel *introduceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:introduceLabel];
    self.introduceLabel = introduceLabel;
    self.introduceLabel.font = [UIFont systemFontOfSize:15];
    self.introduceLabel.numberOfLines = 0;
}
#pragma mark 创建下面部分课程详情的View
/**
 *  创建下面部分课程详情的View
 */
- (void)addCourseMessageView{
    /**
     *  课程上面标题的View
     */
    UIView *courseTitleView = [self createTitleViewWithTitle:@"课程详情"];
    [self.contentView addSubview:courseTitleView];
    self.courseTitleView = courseTitleView;
    //评分View
    UIView *commentScoreView = [[UIView alloc] init];
    [self.contentView addSubview:commentScoreView];
    self.commentScoreView = commentScoreView;
    [self addCommentScore];
    /**
     *  课程目标
     */
    UILabel *courseAimLabel = [[UILabel alloc] init];
    [self.contentView addSubview:courseAimLabel];
    self.courseAimLabel = courseAimLabel;
    self.courseAimLabel.font = [UIFont systemFontOfSize:15];
    /**
     *  学习特色
     */
    UILabel *coursefFeatureLabel = [[UILabel alloc] init];
    [self.contentView addSubview:coursefFeatureLabel];
    self.coursefFeatureLabel = coursefFeatureLabel;
    self.coursefFeatureLabel.font = [UIFont systemFontOfSize:15];
    /**
     *  适合人群
     */
    UILabel *courseSuitPeopleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:courseSuitPeopleLabel];
    self.courseSuitPeopleLabel = courseSuitPeopleLabel;
    self.courseSuitPeopleLabel.font = [UIFont systemFontOfSize:15];
    /**
     *  课程节数
     */
    UILabel *courseNumberLabel = [[UILabel alloc] init];
    [self.contentView addSubview:courseNumberLabel];
    self.courseNumberLabel = courseNumberLabel;
    self.courseNumberLabel.font = [UIFont systemFontOfSize:15];
    /**
     *  课程详情
     */
    UILabel *courseIntroduceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:courseIntroduceLabel];
    self.courseIntroduceLabel = courseIntroduceLabel;
    self.courseIntroduceLabel.font = [UIFont systemFontOfSize:15];
    self.courseIntroduceLabel.numberOfLines = 0;
}
#pragma mark 创建带标题的View
/**
 *  创建带标题的View
 */
- (UIView *)createTitleViewWithTitle:(NSString *)title{
    UIView *titleView = [[UIView alloc] init];
    //增加左边的竖线
    CGFloat blueLineViewH = 16;
    UIView *blueLineView = [[UIView alloc] initWithFrame:CGRectMake(YY18WidthMargin, YY12HeightMargin, 1, blueLineViewH)];
    blueLineView.backgroundColor = YYBlueTextColor;
    [titleView addSubview:blueLineView];
    
    CGFloat titleLabelX = YY18WidthMargin + 1 + 8/375.0*YYWidthScreen;
    CGFloat titleLabelW = YYWidthScreen - titleLabelX- 2 *YY18WidthMargin;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, YY12HeightMargin, titleLabelW, blueLineViewH)];
    [titleView addSubview:titleLabel];
    titleLabel.text = title;
    titleLabel.textColor = YYGrayTextColor;
    
    return titleView;
}
#pragma mark 重写模型frame的setter方法
/**
 *  重写模型frame的setter方法
 */
- (void)setModelFrame:(YYDetailCourseCellFrame *)modelFrame{
    _modelFrame = modelFrame;
    //设置讲师介绍的Frame和内容
    [self setTeacherFrameAndContent];
    
    //设置灰线的frame
    self.grayView.frame = _modelFrame.grayViewF;
    
    //设置下面课程信息的Frame和内容
    [self setCourseMessageFrameAndContent];
    
}
#pragma mark 设置讲师介绍的Frame和内容
/**
 *  设置讲师介绍的Frame和内容
 */
- (void)setTeacherFrameAndContent{
    
    self.teacherTitleView.frame = _modelFrame.teacherTitleViewF;
    
    self.iconImageView.frame = _modelFrame.iconImageViewF;
    self.nameLabel.frame = _modelFrame.nameLabelF;
    self.introduceLabel.frame = _modelFrame.introduceLabelF;
    
    self.iconImageView.layer.cornerRadius = _modelFrame.iconImageViewF.size.width/2.0;//设置圆的半径
    self.iconImageView.layer.masksToBounds = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_modelFrame.teacherModel.teacherIconUrl] placeholderImage:[UIImage imageNamed:@"news_load1"]];
    
    self.nameLabel.text = _modelFrame.teacherModel.teacherName;
    
    //设置讲师简介
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_modelFrame.teacherModel.teacherIntroduce attributes:attr];
    self.introduceLabel.attributedText = attributedString;
}
#pragma  mark 设置下面课程信息的Frame和内容
/**
 *  设置下面课程信息的Frame和内容
 */
- (void)setCourseMessageFrameAndContent{
    
    YYCourseCollectionCellModel *courseModel = _modelFrame.courseModel;
    
    self.courseTitleView.frame = _modelFrame.courseTitleViewF;

    CGFloat yMargin = 10/667.0*YYHeightScreen;
    CGFloat cellH = 13;
    CGFloat cellX = YY18WidthMargin;
    CGFloat cellW = YYWidthScreen - YY18WidthMargin * 2;
    
    //设置课程评分
    CGFloat commentScoreY = CGRectGetMaxY(self.courseTitleView.frame);
    self.commentScoreView.frame = CGRectMake(cellX, commentScoreY, cellW, cellH);
    
    CGFloat starNumber = _modelFrame.courseModel.courseScore.floatValue;
    
    NSInteger marginNumber = (NSInteger)starNumber;
    CGFloat starHaveW = starW * starNumber + starMargin * marginNumber;
    
    self.haveFiveStarImageView.contentMode = UIViewContentModeLeft;
    self.haveFiveStarImageView.width = starHaveW;
    
    [self.haveFiveStarImageView setContentScaleFactor:2];
    
    self.haveFiveStarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;//根据你的需求
    
    self.haveFiveStarImageView.clipsToBounds  = YES;//切掉多余部分
    
    /**
     *  课程目标
     */
    CGFloat courseAimLabelY =  CGRectGetMaxY(self.commentScoreView.frame) + yMargin;
    self.courseAimLabel.frame = CGRectMake(cellX, courseAimLabelY, cellW, cellH);
    
    self.courseAimLabel.text = [NSString stringWithFormat:@"课程目的: %@", courseModel.courseTitle];
    /**
     *  学习特色
     */
    CGFloat coursefFeatureLabelY =  CGRectGetMaxY(self.courseAimLabel.frame) + yMargin;
    self.coursefFeatureLabel.frame = CGRectMake(cellX, coursefFeatureLabelY, cellW, cellH);
    self.coursefFeatureLabel.text = [NSString stringWithFormat:@"学习特色: %@", courseModel.coursefFeature];
    /**
     *  适合人群
     */
    CGFloat courseSuitPeopleLabelY =  CGRectGetMaxY(self.coursefFeatureLabel.frame) + yMargin;
    self.courseSuitPeopleLabel.frame = CGRectMake(cellX, courseSuitPeopleLabelY, cellW, cellH);
    self.courseSuitPeopleLabel.text = [NSString stringWithFormat:@"适合人群: %@", courseModel.courseCrowd];
    /**
     *  课程节数
     */
    CGFloat courseNumberLabelY =  CGRectGetMaxY(self.courseSuitPeopleLabel.frame) + yMargin;
    self.courseNumberLabel.frame = CGRectMake(cellX, courseNumberLabelY, cellW, cellH);
    self.courseNumberLabel.text = [NSString stringWithFormat:@"课程节数: %@节", courseModel.courseSeriesNum];
    /**
     *  课程详情
     */
    CGFloat courseIntroduceLabelY =  CGRectGetMaxY(self.courseNumberLabel.frame) + yMargin;
    self.courseIntroduceLabel.frame = CGRectMake(cellX, courseIntroduceLabelY, cellW, _modelFrame.courseIntroH);
    //设置课程详情的文字
    NSString *courseIntro = [NSString stringWithFormat:@"课程详情: %@", courseModel.courseIntroduce];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    
    NSAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:courseIntro attributes:attr];
    self.courseIntroduceLabel.attributedText = attributeString;
}

#pragma mark 增加课程评分的行
/**
 *  增加课程评分的行
 */
- (void)addCommentScore{
    CGFloat labelHeight = 13;
    UILabel *label = [[UILabel alloc] init];
    label.x = 0;
    label.y = 0;
    label.height = labelHeight;
    [self.commentScoreView addSubview:label];
    
    NSString *labelText = @"课程评分: ";
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    
    CGFloat labelWidth = [labelText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
    
    label.width = labelWidth;
    
    label.font = [UIFont systemFontOfSize:15];
    label.text = labelText;

    //增加5个空的星星labelH13,starH12.5
    CGFloat starsViewX = CGRectGetMaxX(label.frame);
    CGFloat starsViewY = (labelHeight - starH)/2.0;
    CGFloat starsViewW = starW * 5 + starMargin * 4;
    UIImageView *noStarsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(starsViewX, starsViewY, starsViewW, starH)];
    [self.commentScoreView addSubview:noStarsImageView];
    noStarsImageView.image = [UIImage imageNamed:@"small_noFiveStar"];
    
    //增加5个实的星星
    UIImageView *haveFiveStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(starsViewX, starsViewY, 0, starH)];
    [self.commentScoreView addSubview:haveFiveStarImageView];
    haveFiveStarImageView.image = [UIImage imageNamed:@"small_haveFiveStar"];
    self.haveFiveStarImageView = haveFiveStarImageView;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
