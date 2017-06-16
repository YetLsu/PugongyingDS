//
//  YYCatalogueViewController.h
//  pugongying
//
//  Created by wyy on 16/5/16.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCollectionCellModel, YYCatalogueViewController, YYCourseCellModel;

@protocol YYCatalogueViewControllerDelegate <NSObject>

@required
/**
 *  播放视频
 */
- (void)playCourseWithCourseCatalogueModel:(YYCourseCellModel *)catalogueModel;

@end

@interface YYCatalogueViewController : UIViewController
@property (nonatomic, weak) UITableView *catalogueTableView;

@property (nonatomic, weak) id<YYCatalogueViewControllerDelegate> delegate;

- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)courseModel andCatalogueFrame:(CGRect)catalogueFrame;
@end
