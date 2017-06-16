//
//  YYYiZhenTableViewCell.h
//  pugongying
//
//  Created by wyy on 16/3/8.
//  Copyright © 2016年 WYY. All rights reserved.
//


#import <UIKit/UIKit.h>
@class YYYiZhenCaseFrame, YYYiZhenTableViewCell, YYClinicModel;

@protocol YYYiZhenTableViewCellDelegate <NSObject>

@optional
- (void)seeBtnClickWithModel:(YYClinicModel *)model;

@end

@interface YYYiZhenTableViewCell : UITableViewCell
@property (nonatomic, strong) YYYiZhenCaseFrame *modelFrame;
@property (nonatomic, weak) id<YYYiZhenTableViewCellDelegate> delegate;

/**
 * tag值为0表示创建义诊案例的单元格，1表示创建我的提单的单元格
 */
+ (YYYiZhenTableViewCell *)yiZhenTableViewCellWithTableView:(UITableView *)tableView andTag:(NSInteger)tag;
@end
