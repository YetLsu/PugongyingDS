//
//  YYCourseCollectionHeaderView.m
//  pugongying
//
//  Created by wyy on 16/4/28.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCollectionHeaderView.h"

#import "YYCourseCategoryModel.h"

@implementation YYCourseCollectionHeaderView
NSInteger _YYCourseCollectionHeaderViewSection = 0;

+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind reuseIdentifier:(NSString *)ID indexPath:(NSIndexPath *)indexPath{
    
    _YYCourseCollectionHeaderViewSection = indexPath.section;
    
    YYCourseCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ID forIndexPath:indexPath];
    
    return headerView;

}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        /**
         *  组头的高度
         */
        CGFloat otherHeaderH = (12 + 40)/667.0 *YYHeightScreen;
        //添加课程标题和更多按钮
        [self addCourseCategoryNameWithFrame:CGRectMake(0, 0, YYWidthScreen, otherHeaderH)];
    }
    return self;
}

/**
 *  添加课程标题和更多按钮
 */
- (void)addCourseCategoryNameWithFrame:(CGRect)categoryViewFrame{
    UIView *categoryView = [[UIView alloc] initWithFrame:categoryViewFrame];
    [self addSubview:categoryView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, YY12HeightMargin)];
    grayView.backgroundColor = YYGrayBGColor;
    [categoryView addSubview:grayView];
    
    //增加下面的横线
    CGFloat lineW = YYWidthScreen - YY18WidthMargin * 2;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, categoryViewFrame.size.height - 0.5, lineW, 0.5) andView:categoryView];
    
    //获取当前课程的分类模型
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults]objectForKey:YYCourseCategoryArrayPath];
    
    NSMutableArray *categoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
    
    YYCourseCategoryModel *categoryModel = categoryArray[_YYCourseCollectionHeaderViewSection];
    
    //增加课程名称Label
    CGFloat nameLabelW = lineW / 2.0;
    CGFloat nameLabelH = categoryViewFrame.size.height - YY12HeightMargin - 0.5;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, YY12HeightMargin, nameLabelW, nameLabelH)];
    [categoryView addSubview:nameLabel];
    nameLabel.text = categoryModel.categoryName;
    nameLabel.textColor = YYGrayTextColor;
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    
    //增加更多Label
    CGFloat btnX = YYWidthScreen - YY18WidthMargin - nameLabelW;
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnX, YY12HeightMargin, nameLabelW, nameLabelH)];
    [categoryView addSubview:moreLabel];
    moreLabel.text = @"更多";
    moreLabel.textColor = YYGrayTextColor;
    moreLabel.font = [UIFont systemFontOfSize:16.0];
    moreLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:moreLabel.frame];
    [categoryView addSubview:btn];
    [btn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 *  更多按钮被点击
 */
- (void)moreBtnClick{
    //获取当前课程的分类模型
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults]objectForKey:YYCourseCategoryArrayPath];
    
    NSMutableArray *categoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
    
    YYCourseCategoryModel *categoryModel = categoryArray[_YYCourseCollectionHeaderViewSection];
    
    if ([self.delegate respondsToSelector:@selector(headerViewMoreBtnClickWithModel:)]) {
        [self.delegate headerViewMoreBtnClickWithModel:categoryModel];
    }
}

@end
