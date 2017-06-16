//
//  YYProfileFirstViewCell.h
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYProfileFirstViewCellModel;

@interface YYProfileFirstViewCell : UITableViewCell

@property (nonatomic, strong) YYProfileFirstViewCellModel *model;

@property (nonatomic, weak) UIImageView *dianImageView;

+ (instancetype)profileFirstViewCellWithTable:(UITableView *)tableView;

@end
