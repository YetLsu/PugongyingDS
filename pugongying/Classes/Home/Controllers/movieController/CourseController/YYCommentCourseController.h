//
//  YYCommentCourseController.h
//  pugongying
//
//  Created by wyy on 16/5/17.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCourseCollectionCellModel, YYCommentCourseController;

@protocol YYCommentCourseControllerDelegate <NSObject>

@required
/**
 *  评论按钮被点击
 */
- (void)commentCourseBtnClick;

@end

@interface YYCommentCourseController : UIViewController

@property (nonatomic, weak) id<YYCommentCourseControllerDelegate> delegate;
@property (nonatomic, weak) UIView *commentView;

- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)courseModel andFrame:(CGRect)ViewFrame;
@end
