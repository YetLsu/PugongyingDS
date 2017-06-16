//
//  YYCourseCollectionFirstHeaderView.m
//  pugongying
//
//  Created by wyy on 16/4/28.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCollectionFirstHeaderView.h"

#import "FFScrollView.h"

//课程分类模型
#import "YYCourseCategoryModel.h"

#import "YYFirstHeaderCourseCell.h"

@interface YYCourseCollectionFirstHeaderView ()<FFScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, copy) NSString *YYFirstHeaderCourseCellID;
@end
NSArray *_imagesArray;


@implementation YYCourseCollectionFirstHeaderView
+ (instancetype)firstHeaderViewWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind reuseIdentifier:(NSString *)ID indexPath:(NSIndexPath *)indexPath imagesArray:(NSArray *)array{
    
    _imagesArray = array;
    
    YYCourseCollectionFirstHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ID forIndexPath:indexPath];
    
    return headerView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        /**
         *  其他组头的高度
         */
        CGFloat otherHeaderH = (12 + 40)/667.0 *YYHeightScreen;
        /**
         *  课程选择按钮条的高度
         */
        CGFloat courseCategoryBtnsViewH = 75/667.0 *YYHeightScreen;
        /**
         *  顶部Scroller View的高度
         */
        CGFloat topScrollerViewH = 145/667.0*YYHeightScreen;
        
        //添加顶部的ScrollerView
        [self addScrollerViewWithFrame:CGRectMake(0, 0, YYWidthScreen, topScrollerViewH)];
        //添加课程分类按钮View
        [self addCourseCategoryBtnsViewWithFrame:CGRectMake(0, topScrollerViewH, YYWidthScreen, courseCategoryBtnsViewH)];
        //添加课程标题和更多按钮
        [self addCourseCategoryNameWithFrame:CGRectMake(0, topScrollerViewH + courseCategoryBtnsViewH, YYWidthScreen, otherHeaderH)];
    }
    return self;
}
/**
 *  添加顶部的ScrollerView
 */
- (void)addScrollerViewWithFrame:(CGRect)scrollerViewFrame{
    FFScrollView *scroll = [[FFScrollView alloc]initPageViewWithFrame:scrollerViewFrame views:_imagesArray];
    [self addSubview:scroll];
    scroll.pageViewDelegate = self;
}
- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber{
//    YYLog(@"%ld页被点击",(long)pageNumber);
    if ([self.delegate respondsToSelector:@selector(topScrollerViewClick)]) {
        [self.delegate topScrollerViewClick];
    }
}
/**
 *  添加课程分类按钮View
 */
- (void)addCourseCategoryBtnsViewWithFrame:(CGRect)btnsFrame{

    //获取当前课程的分类模型
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults]objectForKey:YYCourseCategoryArrayPath];
    self.categoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
    
    
    //创建Layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat collectionItemW = 95/375.0 * YYWidthScreen;
    layout.itemSize = CGSizeMake(collectionItemW, btnsFrame.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //增加课程分类CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:btnsFrame collectionViewLayout:layout];
    [self addSubview:collectionView];
    self.YYFirstHeaderCourseCellID = @"YYFirstHeaderCourseCellID";
    [collectionView registerClass:[YYFirstHeaderCourseCell class] forCellWithReuseIdentifier:self.YYFirstHeaderCourseCellID];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
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
    
    YYCourseCategoryModel *categoryModel = categoryArray[0];
    
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
    
    YYCourseCategoryModel *categoryModel = categoryArray[0];
    
    if ([self.delegate respondsToSelector:@selector(firstHeaderViewMoreBtnClickWithModel:)]) {
        [self.delegate firstHeaderViewMoreBtnClickWithModel:categoryModel];
    }
}
#pragma mark collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categoryArray.count;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YYFirstHeaderCourseCell *cell = [[YYFirstHeaderCourseCell alloc] initWithCollectionView:collectionView andReuseIdentifier:self.YYFirstHeaderCourseCellID andIndexPath:indexPath];
    
    YYCourseCategoryModel *model = self.categoryArray[indexPath.row];
    cell.categoryModel = model;
//    YYLog(@"%@",model.categoryName);
    
    return cell;
    
}
#pragma mark collectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseCategoryModel *model = self.categoryArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(courseCategoryBtnClickWithModel:)]) {
        [self.delegate courseCategoryBtnClickWithModel:model];
    }
}
@end
