//
//  YYCourseCollectionHeaderView.h
//  pugongying
//
//  Created by wyy on 16/4/28.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYCourseCollectionHeaderView, YYCourseCategoryModel;

@protocol YYCourseCollectionHeaderViewDelegate <NSObject>

@required
/**
 *  更多按钮被点击
 */
- (void)headerViewMoreBtnClickWithModel:(YYCourseCategoryModel *)categoryModel;

@end

@interface YYCourseCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<YYCourseCollectionHeaderViewDelegate> delegate;

+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind reuseIdentifier:(NSString *)ID indexPath:(NSIndexPath *)indexPath;
@end
