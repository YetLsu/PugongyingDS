//
//  YYQuestionStateCell.h
//  pugongying
//
//  Created by wyy on 16/3/1.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYQuestionStateCellFrame;

@interface YYQuestionStateCell : UITableViewCell
@property (nonatomic, strong)YYQuestionStateCellFrame *questionCellFrame;

+ (instancetype) questionCellWithTableView:(UITableView *)tableView;
@end
