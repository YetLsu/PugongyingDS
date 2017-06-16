//
//  YYMySeedCell.h
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMySeedCellFrame;

@interface YYMySeedCell : UITableViewCell

@property (nonatomic, strong) YYMySeedCellFrame *modelFrame;

+ (instancetype)MySeedCellWithTableView:(UITableView *)tableView;
@end
