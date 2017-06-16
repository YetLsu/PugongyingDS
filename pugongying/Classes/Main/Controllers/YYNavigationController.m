//
//  YYNavigationController.m
//  pugongying
//
//  Created by wyy on 16/2/22.
//  Copyright © 2016年 WYY. All rights reserved.
//


#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]


#import "YYNavigationController.h"
#import <QuartzCore/QuartzCore.h>


@interface YYNavigationController ()

@end

@implementation YYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBarTintColor:YYBlueTextColor];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    navBar.barStyle = UIBarStyleBlackOpaque;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIImage *image = [UIImage imageNamed:@"navigation_previous"];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftBtnClick)];
    }

    [super pushViewController:viewController animated:animated];

    
}

- (void)navigationLeftBtnClick{
    [self popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)popTopViewCOntrollerAndPostViewController:(UIViewController *)viewController{
    [self popToRootViewControllerAnimated:NO];
    
    [self pushViewController:viewController animated:YES];
}

@end
