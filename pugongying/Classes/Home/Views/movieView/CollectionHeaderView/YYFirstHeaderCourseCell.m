//
//  YYFirstHeaderCourseCell.m
//  pugongying
//
//  Created by wyy on 16/4/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYFirstHeaderCourseCell.h"
#import "YYCourseCategoryModel.h"

@interface YYFirstHeaderCourseCell ()
/**
 *  课程分类图片
 */
@property (nonatomic, weak) UIImageView *categoryImageView;
/**
 * 课程分类名称
 */
@property (nonatomic, weak) UILabel *categoryNameLabel;

@end

@implementation YYFirstHeaderCourseCell
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView andReuseIdentifier:(NSString *)reuseIdentifier andIndexPath:(NSIndexPath *)indexPath{
    YYFirstHeaderCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
//        CGFloat collectionItemH = 75/667.0 *YYHeightScreen;
//        CGFloat collectionItemW = 95/375.0 * YYWidthScreen;
        CGFloat itemH = frame.size.height;
        /**
         * 课程分类名称
         */
        UILabel *categoryNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:categoryNameLabel];
        self.categoryNameLabel = categoryNameLabel;
        CGFloat labelH = 15;
        CGFloat labelY = itemH - YY10HeightMargin - labelH;
        CGFloat labelW = frame.size.width;
        self.categoryNameLabel.frame = CGRectMake(0, labelY, labelW, labelH);
        self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
        self.categoryNameLabel.font = [UIFont systemFontOfSize:16.0];
        self.categoryNameLabel.textColor = YYBlueTextColor;
        /**
         *  课程分类图片
         */
        UIImageView *categoryImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:categoryImageView];
        self.categoryImageView = categoryImageView;
        CGFloat imageViewH = labelY;
        self.categoryImageView.frame = CGRectMake(0, 0, labelW, imageViewH);
        self.categoryImageView.contentMode = UIViewContentModeCenter;
        
    }
    return self;
}
- (void)setCategoryModel:(YYCourseCategoryModel *)categoryModel{
    _categoryModel = categoryModel;
    
    /**
     *  课程分类图片
     */
    [self.categoryImageView sd_setImageWithURL:[NSURL URLWithString:categoryModel.categoryIcon]];
    /**
     * 课程分类名称
     */
    self.categoryNameLabel.text = categoryModel.categoryName;
}
@end
