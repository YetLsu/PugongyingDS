//
//  YYCerebritiesTableViewCell.h
//  pugongying
//
//  Created by wyy on 16/3/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMagazineModel;

@interface YYMagazineModelTableViewCell : UITableViewCell

@property (nonatomic, strong) YYMagazineModel *model;

+ (instancetype)cerebritiesTableViewCellWithTableView:(UITableView *)tableView;
@end
