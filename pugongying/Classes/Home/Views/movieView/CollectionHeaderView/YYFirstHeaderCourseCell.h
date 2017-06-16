//
//  YYFirstHeaderCourseCell.h
//  pugongying
//
//  Created by wyy on 16/4/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YYCourseCategoryModel;

@interface YYFirstHeaderCourseCell : UICollectionViewCell

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView andReuseIdentifier:(NSString *)reuseIdentifier andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) YYCourseCategoryModel *categoryModel;
@end
