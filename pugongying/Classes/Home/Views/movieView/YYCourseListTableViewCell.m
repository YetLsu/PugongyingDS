//
//  YYCourseListTableViewCell.m
//  pugongying
//
//  Created by wyy on 16/4/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseListTableViewCell.h"
#import "YYCourseCollectionCellModel.h"


#define starH 12.5
#define starW 13.5
#define starMargin 5
@interface YYCourseListTableViewCell()
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
@property (nonatomic, weak) UILabel *courseSortLabel;
/**
 *  收藏量Label
 */
@property (nonatomic, weak) UILabel *collectNumberLabel;
/**
 *  线View
 */
@property (nonatomic, weak) UIView *lineView;
@end

static NSString *ID = @"YYCourseListTableViewCell";

@implementation YYCourseListTableViewCell
+ (instancetype)courseListTableViewCellWithTableView:(UITableView *)tableView{
    YYCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCourseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self addSubViews];
        
        //添加约束
        [self addconstraints];

    }
    return self;
}
#pragma mark 添加子控件
- (void)addSubViews{
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
    self.courseNameLabel.adjustsFontSizeToFitWidth = YES;
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
    UILabel *courseSortLabel = [[UILabel alloc] init];
    [self.contentView addSubview:courseSortLabel];
    self.courseSortLabel = courseSortLabel;
    self.courseSortLabel.font = [UIFont systemFontOfSize:13.0];
    self.courseSortLabel.textColor = YYGrayTextColor;
    /**
     *  收藏量Label
     */
    UILabel *collectNumberLabel = [[UILabel alloc] init];
    [self.contentView addSubview:collectNumberLabel];
    self.collectNumberLabel = collectNumberLabel;
    self.collectNumberLabel.font = [UIFont systemFontOfSize:13.0];
    self.collectNumberLabel.textColor = YYGrayTextColor;
    /**
     *  线View
     */
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    self.lineView.backgroundColor = YYGrayLineColor;
    
}
#pragma mark 添加子控件的约束
- (void)addconstraints{
    
    __weak typeof(self) weakSelf = self;
    /**
     *  课程图片
     */
    CGFloat xMargin = YY18WidthMargin;
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat courseImageViewW = 160 * scale;
    CGFloat courseImageViewH = 90 * scale;
    
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(courseImageViewW, courseImageViewH));
        make.left.equalTo(weakSelf.contentView).with.offset(xMargin);
        make.top.equalTo(weakSelf.contentView).with.offset(10);
        
    }];
    /**
     *  课程名称Label
     */
    
    CGFloat courseSortH = 15;
    CGFloat courseNameLabelW = YYWidthScreen - courseImageViewW - 10 - xMargin * 2;
    CGFloat courseNameLabelH = 20;
    CGFloat labelMargin = (courseImageViewH - courseNameLabelH - starH - courseSortH)/5.0;
    
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(courseNameLabelW, courseNameLabelH));
        make.right.equalTo(weakSelf.contentView).with.offset(-xMargin);
        make.top.equalTo(weakSelf.courseImageView).with.offset(labelMargin);

    }];
   
    
    /**
     *  五颗星星空的imageView
     */
    CGFloat starNoW = starW * 5 + starMargin *4;
    [self.noFiveStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(starNoW, starH));
        make.leading.equalTo(weakSelf.courseNameLabel);
        make.top.equalTo(weakSelf.courseNameLabel.mas_bottom).with.offset(labelMargin);
    }];
    /**
     *  课程分类Label
     */
    CGFloat courseSortW = courseNameLabelW * 0.6;
    [self.courseSortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(courseSortW, courseSortH));
        make.leading.equalTo(weakSelf.courseNameLabel);
        make.top.equalTo(weakSelf.noFiveStarImageView.mas_bottom).with.offset(labelMargin);
    }];
    /**
     *  收藏量Label
     */
    CGFloat courseNumberW = courseNameLabelW * 0.4;
    [self.collectNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(courseNumberW, courseSortH));
        make.trailing.equalTo(weakSelf.courseNameLabel);
        make.top.equalTo(weakSelf.courseSortLabel);
    }];

    //线View
    CGFloat lineW = YYWidthScreen - xMargin * 2;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lineW, 0.5));
        make.leading.equalTo(weakSelf.courseImageView);
        make.top.equalTo(weakSelf.courseImageView.mas_bottom).with.offset(10);
    }];
}
- (void)setModel:(YYCourseCollectionCellModel *)model{
   
    __weak typeof(self) weakSelf = self;
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat courseImageViewH = 90 * scale;
    CGFloat courseNameLabelH = 20;
    CGFloat courseSortH = 15;
    CGFloat labelMargin = (courseImageViewH - courseNameLabelH - starH - courseSortH)/5.0;
    _model = model;
    //课程图片
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseListimgurl] placeholderImage:[UIImage imageNamed:@"course_load3"]];
    
    //课程名称Label
    self.courseNameLabel.text = model.courseTitle;
    /**
    *  课程分类Label
    */
    if ([model.categoryID isEqualToString:@"1"]) {
        self.courseSortLabel.text = @"阿里课程";
    }
    else if ([model.categoryID isEqualToString:@"2"]){
        self.courseSortLabel.text = @"淘宝课程";
    }
    else if ([model.categoryID isEqualToString:@"3"]){
        self.courseSortLabel.text = @"美工课程";
    }
    //收藏量Label
    self.collectNumberLabel.text = [NSString stringWithFormat:@"收藏：%@", model.courseCollectionNum];
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
    
    self.haveFiveStarImageView.clipsToBounds  = YES;//切掉多余部分
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
