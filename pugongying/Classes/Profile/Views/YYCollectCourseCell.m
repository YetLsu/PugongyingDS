//
//  YYCollectCourseCell.m
//  pugongying
//
//  Created by wyy on 16/3/11.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCollectCourseCell.h"
#import "YYCourseCollectionCellModel.h"
#import "YYCollectCourseFrame.h"
/**
 *  课程分类模型
 */
#import "YYCourseCategoryModel.h"

@interface YYCollectCourseCell ()
/**
 *  课程图片
 */
@property (nonatomic, weak) UIImageView *courseIconImageView;
/**
 *  课程标题Label
 */
@property (nonatomic, weak) UILabel *courseTitleLabel;
/**
 *  课程分类Label
 */
@property (nonatomic, weak) UILabel *courseSortLabel;
/**
 *  课程播放量Label
 */
@property (nonatomic, weak) UILabel *coursePlayNumberLabel;
/**
 *  取消收藏课程Button
 */
@property (nonatomic, weak) UIButton *courseCancelCollectBtn;
/**
 *  查看课程Button
 */
@property (nonatomic, weak) UIButton *courseLookBtn;

@end

@implementation YYCollectCourseCell
+ (instancetype)collectCourseCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYCollectCourseCell";
    
    YYCollectCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYCollectCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         *  课程图片
         */
        UIImageView *courseIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:courseIconImageView];
        self.courseIconImageView = courseIconImageView;
        /**
         *  课程标题Label
         */
        UILabel *courseTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseTitleLabel];
        self.courseTitleLabel = courseTitleLabel;
        self.courseTitleLabel.textColor = YYGrayTextColor;
        /**
         *  课程分类Label
         */
        UILabel *courseSortLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseSortLabel];
        self.courseSortLabel = courseSortLabel;
        self.courseSortLabel.textColor = YYGrayText140Color;
        self.courseSortLabel.font = [UIFont systemFontOfSize:15.0];
        /**
         *  课程播放量Label
         */
        UILabel *coursePlayNumberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:coursePlayNumberLabel];
        self.coursePlayNumberLabel = coursePlayNumberLabel;
        self.coursePlayNumberLabel.textColor = YYGrayText140Color;
        self.coursePlayNumberLabel.font = [UIFont systemFontOfSize:14.0];
        /**
         *  取消收藏课程Button
         */
        UIButton *courseCancelCollectBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(0, 0, 100, 50) superView:self.contentView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:YYGrayTextColor title:@"取消收藏"];
        self.courseCancelCollectBtn = courseCancelCollectBtn;
        [self.courseCancelCollectBtn addTarget:self action:@selector(cancelCollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        courseCancelCollectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        /**
         *  查看课程Button
         */
        UIButton *courseLookBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(0, 0, 100, 50) superView:self.contentView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:YYGrayTextColor title:@"查看课程"];
        self.courseLookBtn = courseLookBtn;
        [self.courseLookBtn addTarget:self action:@selector(seeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        courseLookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setCollectFrame:(YYCollectCourseFrame *)collectFrame{
    _collectFrame = collectFrame;
    
    YYCourseCollectionCellModel *model = collectFrame.model;
    
    /**
     *  课程图片
     */
    self.courseIconImageView.frame = collectFrame.courseIconF;
    [self.courseIconImageView sd_setImageWithURL:[NSURL URLWithString:model.courseListimgurl] placeholderImage:[UIImage imageNamed:@"course_load1"]];
    CGFloat lineY = CGRectGetMaxY(collectFrame.courseIconF) + YY12HeightMargin;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, lineY, YYWidthScreen, 0.5) andView:self.contentView];
    /**
     *  课程标题Label
     */
    self.courseTitleLabel.frame = collectFrame.courseTitleF;
    self.courseTitleLabel.text = model.courseTitle;
    /**
     *  课程分类Label
     */
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:YYCourseCategoryArrayPath];
    NSMutableArray *courseCategoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (courseCategoryArray) {
        self.courseSortLabel.frame = collectFrame.courseSortF;
        int index = model.categoryID.intValue;
 
        YYCourseCategoryModel *categoryModel = courseCategoryArray[index - 1];
        self.courseSortLabel.text = categoryModel.categoryName;
    }
    /**
     *  课程播放量Label
     */
    self.coursePlayNumberLabel.frame = collectFrame.coursePlayNumberF;
    self.coursePlayNumberLabel.text = [NSString stringWithFormat:@"收藏量：%@",model.courseCollectionNum];
    /**
     *  取消收藏课程Button
     */
    self.courseCancelCollectBtn.frame = collectFrame.courseCancelCollectF;
    /**
     *  查看课程Button
     */
    self.courseLookBtn.frame = collectFrame.courseLookF;
}

#pragma mark 取消收藏课程Button被点击
- (void)cancelCollectBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(cancelCollectCourseBtnClickWithFrame:)]) {
        [self.delegate cancelCollectCourseBtnClickWithFrame:self.collectFrame];
    }
}
#pragma mark 查看课程Button被点击
- (void)seeBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(seeCourseBtnClickWithFrame:)]) {
        [self.delegate seeCourseBtnClickWithFrame:self.collectFrame];
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
