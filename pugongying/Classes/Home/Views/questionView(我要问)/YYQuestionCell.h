//
//  YYQuestionCell.h
//  pugongying
//
//  Created by wyy on 16/2/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYQuestionCellFrame;
@interface YYQuestionCell : UITableViewCell

@property (nonatomic, strong)YYQuestionCellFrame *questionCellFrame;

+ (instancetype) questionCellWithTableView:(UITableView *)tableView;
@end
