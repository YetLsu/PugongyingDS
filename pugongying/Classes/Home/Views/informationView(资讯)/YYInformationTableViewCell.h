//
//  YYInformationTableViewCell.h
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYInformationFrame;
@interface YYInformationTableViewCell : UITableViewCell

/**
 *  frame模型
 */
@property (nonatomic, strong) YYInformationFrame *informationFrame;


+ (instancetype)informationCellWithTableView:(UITableView *)tableView;
@end
