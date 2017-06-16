//
//  YYCourseMessageView.h
//  pugongying
//
//  Created by wyy on 16/4/9.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  课程四个四个显示时的一个View
 */
#import <UIKit/UIKit.h>
@class YYCourseCollectionCellModel;


@interface YYCourseCollectionViewCell : UICollectionViewCell


+ (instancetype)courseCollectionCellWithCollectionView:(UICollectionView *)collectionView andReuseIdentifier:(NSString *)reuseIdentifier andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) YYCourseCollectionCellModel *model;
@end
