//
//  YYInformationController.h
//  pugongying
//
//  Created by wyy on 16/3/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

//推荐的资讯控制器

#import <UIKit/UIKit.h>

@class YYInformationModel, YYInformationController;
@protocol YYInformationControllerDelegate <NSObject>

@required

- (void)newsCellClickWithModel:(YYInformationModel *)model;

@end

@interface YYInformationController : UITableViewController

@property (nonatomic, weak) id<YYInformationControllerDelegate> delegate;

@end
