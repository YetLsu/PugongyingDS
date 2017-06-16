//
//  YYShowCircleCell.h
//  pugongying
//
//  Created by wyy on 16/5/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowCircleModel, YYShowCircleCellDelegate;

@protocol YYShowCircleCellDelegate <NSObject>

@required
- (void)goCircleChatWithShowCircleModel:(YYShowCircleModel *)showCircleModel;

@end

@interface YYShowCircleCell : UITableViewCell

@property (nonatomic, weak) id<YYShowCircleCellDelegate> delegate;

/**
 *  推荐圈子模型
 */
@property (nonatomic, strong) YYShowCircleModel *circlemodel;


+ (instancetype)showCircleCellWithTableView:(UITableView *)tableView;
@end
