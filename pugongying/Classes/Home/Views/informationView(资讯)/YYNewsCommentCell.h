//
//  YYNewsCommentCell.h
//  pugongying
//
//  Created by wyy on 16/4/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNewsCommentFrame;

@interface YYNewsCommentCell : UITableViewCell

@property (nonatomic, strong)YYNewsCommentFrame *modelFrame;

+ (instancetype)newsCommentCellWithTableView:(UITableView *)tableView;

@end
