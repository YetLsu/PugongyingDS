//
//  YYCollectNewsCell.h
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCollectNewsFrame, YYCollectNewsCell;

@protocol YYCollectNewsCellDelegate <NSObject>

@optional

- (void)cancelCollectNewsBtnClickWithFrame:(YYCollectNewsFrame *)newsFrame;
- (void)seeNewsBtnClickWithFrame:(YYCollectNewsFrame *)newsFrame;
@end

@interface YYCollectNewsCell : UITableViewCell

@property (nonatomic, strong) YYCollectNewsFrame *modelFrame;

@property (nonatomic, weak) id<YYCollectNewsCellDelegate> delegate;

+ (instancetype)collectNewsCellWithTableView:(UITableView *)tableView;
@end
