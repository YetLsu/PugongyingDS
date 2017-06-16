//
//  YYMyMessageCell.h
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMyMessageFrame;

@interface YYMyMessageCell : UITableViewCell

@property (nonatomic, strong) YYMyMessageFrame *modelFrame;

+ (instancetype)myMessageCellWithTableView:(UITableView *)tableView;
@end
