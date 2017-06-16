//
//  YYCourseHistoryCell.m
//  pugongying
//
//  Created by wyy on 16/5/5.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseHistoryCell.h"
#import "YYCourseCollectionCellModel.h"


#define starH 12.5
#define starW 13.5
#define starMargin 5

@interface YYCourseHistoryCell ()
/**
 *  课程图片
 */
@property (nonatomic, weak) UIImageView *courseImageView;
/**
 *  课程名称Label
 */
@property (nonatomic, weak) UILabel *courseNameLabel;
/**
 *  五颗星星实的imageView
 */
@property (nonatomic, weak) UIImageView *haveFiveStarImageView;
/**
 *  五颗星星空的imageView
 */
@property (nonatomic, weak) UIImageView *noFiveStarImageView;
/**
 *  课程分类Label
 */
//@property (nonatomic, weak) UILabel *courseSortLabel;
/**
 *  观看时间Label
 */
@property (nonatomic, weak) UILabel *courseSeeTimeLabel;
/**
 * 观看时间左侧图标
 */
@property (nonatomic, weak) UIImageView *timeLeftIconImageView;
/**
 *  线View
 */
@property (nonatomic, weak) UIView *lineView;

@end

@implementation YYCourseHistoryCell
+ (instancetype) courseHistoryCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYCourseHistoryCell";
    YYCourseHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCourseHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  课程图片
         */
        UIImageView *courseImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:courseImageView];
        self.courseImageView = courseImageView;
        /**
         *  课程名称Label
         */
        UILabel *courseNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseNameLabel];
        self.courseNameLabel = courseNameLabel;
        self.courseNameLabel.font = [UIFont systemFontOfSize:16.0];
        courseNameLabel.adjustsFontSizeToFitWidth = YES;
        /**
         *  五颗星星空的imageView
         */
        UIImageView *noFiveStarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:noFiveStarImageView];
        self.noFiveStarImageView = noFiveStarImageView;
        self.noFiveStarImageView.image = [UIImage imageNamed:@"small_noFiveStar"];
        /**
         *  五颗星星实的imageView
         */
        UIImageView *haveFiveStarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:haveFiveStarImageView];
        self.haveFiveStarImageView = haveFiveStarImageView;
        self.haveFiveStarImageView.image = [UIImage imageNamed:@"small_haveFiveStar"];
        self.haveFiveStarImageView.contentMode =  UIViewContentModeLeft;
        /**
         *  课程分类Label
         */
//        UILabel *courseSortLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:courseSortLabel];
//        self.courseSortLabel = courseSortLabel;
//        self.courseSortLabel.font = [UIFont systemFontOfSize:13.0];
//        self.courseSortLabel.textColor = YYGrayTextColor;
        /**
         *  观看时间观看时间Label
         */
        UILabel *courseSeeTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseSeeTimeLabel];
        self.courseSeeTimeLabel = courseSeeTimeLabel;
        self.courseSeeTimeLabel.font = [UIFont systemFontOfSize:13.0];
        self.courseSeeTimeLabel.textColor = YYGrayTextColor;
        self.courseSeeTimeLabel.textAlignment = NSTextAlignmentLeft;
        /**
         * 观看时间左侧图标
         */
        UIImageView *timeLeftIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:timeLeftIconImageView];
        self.timeLeftIconImageView = timeLeftIconImageView;
        self.timeLeftIconImageView.image = [UIImage imageNamed:@"home_courseSeeIcon"];
        self.timeLeftIconImageView.contentMode = UIViewContentModeCenter;
        /**
         *  线View
         */
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        self.lineView.backgroundColor = YYGrayLineColor;
        
        [self addconstraints];
    }
    return self;
}
#pragma mark 添加子控件的约束
- (void)addconstraints{
    
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  课程图片
     */
    CGFloat xMargin = YY18WidthMargin;
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat courseImageViewW = 160 * scale;
    CGFloat courseImageViewH = 90 * scale;
    
    [weakSelf.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(courseImageViewW, courseImageViewH));
        make.left.equalTo(weakSelf.contentView).with.offset(xMargin);
        make.top.equalTo(weakSelf.contentView).with.offset(10);
        
    }];
    /**
     *  课程名称Label
     */
    CGFloat courseSortH = 15;
//    CGFloat courseNameLabelW = YYWidthScreen - courseImageViewW - 10 - xMargin * 2;
    CGFloat courseNameLabelH = 20;
    CGFloat labelMargin = (courseImageViewH - courseNameLabelH - starH - courseSortH)/5.0;
    
    [weakSelf.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(courseNameLabelW, courseNameLabelH));
        make.height.mas_equalTo(courseNameLabelH);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10);
        make.left.equalTo(weakSelf.courseImageView.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.courseImageView).with.offset(labelMargin);
    }];
    
    /**
     *  五颗星星空的imageView
     */
    CGFloat starNoW = starW * 5 + starMargin *4;
    [weakSelf.noFiveStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(starNoW, starH));
        make.leading.equalTo(weakSelf.courseNameLabel);
        make.top.equalTo(weakSelf.courseNameLabel.mas_bottom).with.offset(labelMargin);
    }];
    /**
     *  课程分类Label
     */
//    CGFloat courseSortW = courseNameLabelW * 0.60;
//    [weakSelf.courseSortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(courseSortW, courseSortH));
//        make.leading.equalTo(weakSelf.courseNameLabel);
//        make.top.equalTo(weakSelf.noFiveStarImageView.mas_bottom).with.offset(labelMargin);
//    }];
    /**
     * 观看时间左侧图标,W16,H12
     */
    [weakSelf.timeLeftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, courseSortH));
        make.top.equalTo(weakSelf.noFiveStarImageView.mas_bottom).with.offset(labelMargin);
        make.leading.equalTo(weakSelf.courseNameLabel);
    }];
    /**
     *  观看时间Label
     */
//    CGFloat courseNumberW = courseNameLabelW * 0.4;
    [weakSelf.courseSeeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(courseNumberW, courseSortH));
        make.height.mas_equalTo(courseSortH);
        make.trailing.equalTo(weakSelf.courseNameLabel);
        make.left.equalTo(weakSelf.timeLeftIconImageView.mas_right).with.offset(5);
        make.top.equalTo(weakSelf.timeLeftIconImageView);
    }];
    
    
    //线View
    CGFloat lineW = YYWidthScreen;
    [weakSelf.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lineW, 0.5));
        make.leading.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.courseImageView.mas_bottom).with.offset(10);
    }];
}


- (void)setModel:(YYCourseCollectionCellModel *)model{
    _model = model;
    
    __weak typeof(self) weakSelf = self;
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat courseImageViewH = 90 * scale;
    CGFloat courseNameLabelH = 20;
    CGFloat courseSortH = 15;
    CGFloat labelMargin = (courseImageViewH - courseNameLabelH - starH - courseSortH)/5.0;
 
    //课程图片
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseListimgurl] placeholderImage:[UIImage imageNamed:@"course_load3"]];
    
    //课程名称Label
    self.courseNameLabel.text = model.courseTitle;
    /**
     *  课程分类Label
     */
//    if ([model.categoryID isEqualToString:@"1"]) {
//        self.courseSortLabel.text = @"阿里课程";
//    }
//    else if ([model.categoryID isEqualToString:@"2"]){
//        self.courseSortLabel.text = @"淘宝课程";
//    }
//    else if ([model.categoryID isEqualToString:@"3"]){
//        self.courseSortLabel.text = @"美工课程";
//    }
    /**
     *  观看时间Label
     */
    //计算到当前时间的秒数
    long long lastTimeLong = model.couseSeeTime.longLongValue;
    NSString *time = [self timeWithLastTime:lastTimeLong];
    
    self.courseSeeTimeLabel.text = time;
    /**
     *  五颗星星实的imageView29
     */
    CGFloat starNumber = model.courseScore.floatValue;
    
    NSInteger marginNumber = (NSInteger)starNumber;
    CGFloat starHaveW = starW * starNumber + starMargin * marginNumber;
    
    [self.haveFiveStarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(starHaveW, starH));
        make.leading.equalTo(weakSelf.courseNameLabel);
        make.top.equalTo(weakSelf.courseNameLabel.mas_bottom).with.offset(labelMargin);
    }];
    
    [self.haveFiveStarImageView setContentScaleFactor:2];
    
    self.haveFiveStarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;//根据你的需求
    self.haveFiveStarImageView.clipsToBounds  = YES;    //切掉多余部分
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark 计算时间
- (NSString *)timeWithLastTime:(long long)lastTime{
    NSString *returnTime;
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    long long nowTimeL = [[NSNumber numberWithDouble:nowTime] longLongValue];
    
    long long detalTime = nowTimeL - lastTime;
    
    if (detalTime < 60) {
        returnTime = [NSString stringWithFormat:@"%lld秒前",detalTime];
    }
    else if (detalTime<3600 & detalTime >=60){
        returnTime = [NSString stringWithFormat:@"%lld分钟前",detalTime/60];
    }
    else if (detalTime >= 3600 & detalTime <86400){
        returnTime = [NSString stringWithFormat:@"%lld小时前",detalTime/60/60];
    }
    else if (detalTime>=86400){
        returnTime = [NSString stringWithFormat:@"%lld天前",detalTime/3600/24];
    }
    return returnTime;
}
@end
