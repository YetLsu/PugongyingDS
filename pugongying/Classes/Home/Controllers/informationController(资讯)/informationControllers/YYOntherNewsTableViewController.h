//
//  YYOntherNewsTableViewController.h
//  pugongying
//
//  Created by wyy on 16/4/12.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYInformationModel, YYInformationController;
@protocol YYOntherNewsTableViewControllerDelegate <NSObject>

@required

- (void)newsOtherCellClickWithModel:(YYInformationModel *)model andCategoryID:(NSString *)categoryID;

@end

@interface YYOntherNewsTableViewController : UITableViewController

- (instancetype) initWithStyle:(UITableViewStyle)style andCategoryID:(NSString *)categoryID;

@property (nonatomic, weak) id<YYOntherNewsTableViewControllerDelegate> delegate;
@end
