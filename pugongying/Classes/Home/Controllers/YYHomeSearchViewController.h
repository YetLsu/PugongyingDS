//
//  YYHomeSearchViewController.h
//  pugongying
//
//  Created by wyy on 16/4/21.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYYSearchBar;

@interface YYHomeSearchViewController : UIViewController
@property (nonatomic, weak) WYYSearchBar *searchBar;

- (instancetype)initWithSearchQuestion:(NSString *)question;
@end
