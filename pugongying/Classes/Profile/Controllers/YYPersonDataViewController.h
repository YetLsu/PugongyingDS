//
//  YYPersonDataViewController.h
//  pugongying
//
//  Created by wyy on 16/3/12.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPersonDataViewController;

@protocol YYPersonDataViewControllerDelegate <NSObject>

@optional

- (void)setUserIcon:(UIImage *)image;

@end

@interface YYPersonDataViewController : UIViewController

@property (nonatomic, weak) id<YYPersonDataViewControllerDelegate> delegate;
@end
