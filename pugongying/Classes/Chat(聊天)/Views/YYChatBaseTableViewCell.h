//
//  YYChatBaseTableViewCell.h
//  pugongying
//
//  Created by wyy on 16/6/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYChatBaseTableViewCell : UITableViewCell
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 *  昵称Label
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  时间Label
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  内容按钮
 */
@property (nonatomic, weak) UIButton *contnetBtn;

@end
