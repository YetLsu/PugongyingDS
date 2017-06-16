//
//  YYCourseCollectionFirstHeaderView.h
//  pugongying
//
//  Created by wyy on 16/4/28.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYCourseCollectionFirstHeaderView, YYCourseCategoryModel;

@protocol YYCourseCollectionFirstHeaderViewDelegate <NSObject>

@required
/**
 *  更多按钮被点击
 */
- (void)firstHeaderViewMoreBtnClickWithModel:(YYCourseCategoryModel *)categoryModel;
/**
 *  顶部的ScrollerView被点击
 */
- (void)topScrollerViewClick;
/**
 *  上面的分类按钮被点击
 */
- (void)courseCategoryBtnClickWithModel:(YYCourseCategoryModel *)categoryModel;

@end



@interface YYCourseCollectionFirstHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<YYCourseCollectionFirstHeaderViewDelegate> delegate;

+ (instancetype)firstHeaderViewWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind reuseIdentifier:(NSString *)ID indexPath:(NSIndexPath *)indexPath imagesArray:(NSArray *)array;
@end
