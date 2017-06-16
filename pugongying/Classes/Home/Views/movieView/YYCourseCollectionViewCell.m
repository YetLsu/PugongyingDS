//
//  YYCourseMessageView.m
//  pugongying
//
//  Created by wyy on 16/4/9.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCollectionViewCell.h"
#import "YYCourseCollectionCellModel.h"

#import "YYCourseCategoryModel.h"

@interface YYCourseCollectionViewCell(){
    
}
/**
 *  课程图片ImageView
 */
@property (nonatomic, weak) UIImageView *courseImageView;
/**
 *  课程图片上的介绍Label
 */
@property (nonatomic, weak) UILabel *courseIntroLabel;
/**
 *  课程名称Label
 */
@property (nonatomic, weak) UILabel *courseNameLabel;
/**
 *  五颗星星实的imageView
 */
@property (nonatomic, weak) UIImageView *haveFiveStarImageView;
/**
 *  课程分类Label
 */
@property (nonatomic, weak) UILabel *courseCategoryLabel;
/**
 *  课程收藏量Label
 */
@property (nonatomic, weak) UILabel *courseCollectNumLabel;
@end

@implementation YYCourseCollectionViewCell

+ (instancetype)courseCollectionCellWithCollectionView:(UICollectionView *)collectionView andReuseIdentifier:(NSString *)reuseIdentifier andIndexPath:(NSIndexPath *)indexPath{
    YYCourseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
   
    return cell;
}
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        CGFloat scale = YYWidthScreen/375.0;
        // item的宽度
        CGFloat itemW = 160 * scale;
        //课程的图片的高度
        CGFloat courseImageViewH = 115.5 * scale;
        //分类和收藏量的label高度
        CGFloat categoryLabelH = 10;
        //垂直方向上的间距
        CGFloat yMargin = 5 * scale;
        //课程名字Label的高度
        CGFloat courseNameLabelH = 15;
        //五颗星星的高度
        CGFloat starH = 12.5;
        CGFloat starW = 13.5;
        CGFloat starMargin = 5;
        
        CGFloat itemH = courseImageViewH + courseNameLabelH + starH + categoryLabelH + 3 * yMargin;
        
        /**
         *  课程图片ImageView
         */
        UIImageView *courseImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:courseImageView];
        self.courseImageView = courseImageView;
        self.courseImageView.frame = CGRectMake(0, 0, itemW, courseImageViewH);
        /**
         *  课程图片上的介绍Label
         */
        UILabel *courseIntroLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseIntroLabel];
        self.courseIntroLabel = courseIntroLabel;
        
        CGFloat courseIntroLabelH = 20;
        CGFloat courseIntroLabelY = courseImageViewH - courseIntroLabelH;
        self.courseIntroLabel.frame = CGRectMake(0, courseIntroLabelY, itemW, courseIntroLabelH);
        
        courseIntroLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        courseIntroLabel.textColor = [UIColor whiteColor];
        courseIntroLabel.font = [UIFont systemFontOfSize:12];
        
        /**
         *  课程名称Label
         */
        UILabel *courseNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseNameLabel];
        self.courseNameLabel = courseNameLabel;
        
        CGFloat courseNameLabelY = courseImageViewH + yMargin;
        self.courseNameLabel.frame = CGRectMake(0, courseNameLabelY, itemW, courseNameLabelH);
        
        self.courseNameLabel.backgroundColor = [UIColor whiteColor];
        self.courseNameLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
        self.courseNameLabel.font = [UIFont systemFontOfSize:13];
        /**
         *  五颗星星空的imageView
         */
        CGFloat starNoY = itemH - categoryLabelH - yMargin - starH;
        CGFloat starNoW = starW * 5 + starMargin *4;
        
        UIImageView *noFiveStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, starNoY, starNoW, starH)];
        [self.contentView addSubview:noFiveStarImageView];
        noFiveStarImageView.image = [UIImage imageNamed:@"small_noFiveStar"];
        
       
        /**
         *  五颗星星实的imageView
         */
        UIImageView *haveFiveStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, starNoY, starNoW, starH)];
        [self.contentView addSubview:haveFiveStarImageView];
        self.haveFiveStarImageView = haveFiveStarImageView;
        haveFiveStarImageView.image = [UIImage imageNamed:@"small_haveFiveStar"];
        haveFiveStarImageView.contentMode =  UIViewContentModeLeft;
        
        /**
         *  课程分类Label
         */
        UILabel *courseCategoryLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseCategoryLabel];
        self.courseCategoryLabel = courseCategoryLabel;
        
        CGFloat categoryLabelY = itemH - categoryLabelH;
        CGFloat categoryLabelW = itemW/2.0;
        self.courseCategoryLabel.frame = CGRectMake(0, categoryLabelY, categoryLabelW, categoryLabelH);
        
        self.courseCategoryLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        self.courseCategoryLabel.font = [UIFont systemFontOfSize:10];

        /**
         *  课程收藏量Label
         */
        UILabel *courseCollectNumLabel = [[UILabel alloc] init];
        [self.contentView addSubview:courseCollectNumLabel];
        self.courseCollectNumLabel = courseCollectNumLabel;
        
        CGFloat courseCollectNumLabelX = categoryLabelW;
        self.courseCollectNumLabel.frame = CGRectMake(courseCollectNumLabelX, categoryLabelY, categoryLabelW, categoryLabelH);
        
        self.courseCollectNumLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        self.courseCollectNumLabel.font = [UIFont systemFontOfSize:10];
        self.courseCollectNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setModel:(YYCourseCollectionCellModel *)model{
    _model = model;
    //五颗星星的宽度以及间距
    CGFloat starW = 13.5;
    CGFloat starMargin = 5;
    /**
     *  课程图片ImageView
     */
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseimgurl] placeholderImage:[UIImage imageNamed:@"course_load1"]];
    /**
     *  课程图片上的介绍Label
     */
    self.courseIntroLabel.text = model.courseIntroduce;
    /**
     *  课程名称Label
     */
    self.courseNameLabel.text = model.courseTitle;
    /**
     *  五颗星星实的imageView
     */
    //设置评分
    CGFloat starNumber = model.courseScore.floatValue;
    NSInteger marginNumber = (NSInteger)starNumber;
    CGFloat starHaveW = starW * starNumber + starMargin * marginNumber;

    [self.haveFiveStarImageView setContentScaleFactor:2.0];
    self.haveFiveStarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.haveFiveStarImageView.width = starHaveW;
    self.haveFiveStarImageView.clipsToBounds = YES;

    /**
     *  课程分类Label
     */
    NSString *courseCategoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:YYCourseCategoryArrayPath];
    NSMutableArray *categoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:courseCategoryPath];
    int category = model.categoryID.intValue;
    YYCourseCategoryModel *categoryModel = categoryArray[category - 1];
    self.courseCategoryLabel.text = categoryModel.categoryName;
       /**
     *  课程收藏量Label
     */
    self.courseCollectNumLabel.text = [NSString stringWithFormat:@"收藏:  %@", model.courseCollectionNum];

}

@end
