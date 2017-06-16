//
//  YYTabBarController.m
//  pugongying
//
//  Created by wyy on 16/2/22.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYTabBarController.h"
#import "YYNavigationController.h"
//#import "YYHomeTableViewController.h"
#import "YYHomeViewController.h"
#import "YYProfileTableViewController.h"
#import "YYYiZhenController.h"


@interface YYTabBarController ()
@property (nonatomic, strong) UIImageView *startImageView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL first;
@end

@implementation YYTabBarController
- (UIImageView *)startImageView{
    if (!_startImageView) {
        _startImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _startImageView.image = [UIImage imageNamed:@"startImage"];
    }
    return _startImageView;
}
/**
 *  定时器时间到
 */
- (void)timerTimeOut{
    [self.startImageView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    YYLog(@"YYTabBarController即将显示");
    if (!self.first) {
        YYHomeViewController *home = [[YYHomeViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildControllerWithChildController:home image:[UIImage imageNamed:@"home"] selectImage:[UIImage imageNamed:@"home_sel"] title:@"首页"];
        
        YYYiZhenController *yizhen = [[YYYiZhenController alloc] init];
        [self addChildControllerWithChildController:yizhen image:[UIImage imageNamed:@"yizhen"] selectImage:[UIImage imageNamed:@"yizhen_sel"] title:@"义诊"];
        
        YYProfileTableViewController *profile = [[YYProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildControllerWithChildController:profile image:[UIImage imageNamed:@"profile"] selectImage:[UIImage imageNamed:@"profile_sel"] title:@"我的"];
        self.first = YES;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.startImageView];
    [self.view bringSubviewToFront:self.startImageView];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTimeOut) userInfo:nil repeats:NO];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildControllerWithChildController:(UIViewController *)vc image:(UIImage *)image selectImage:(UIImage *)selImage title:(NSString *)title{
    YYLog(@"%@",title);
    vc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.title = title;
    
    NSMutableDictionary *attrHigh = [NSMutableDictionary dictionary];
    attrHigh[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [vc.tabBarItem setTitleTextAttributes:attrHigh forState:UIControlStateNormal];
    
    [vc.tabBarItem setTitleTextAttributes:attrHigh forState:UIControlStateSelected];
    
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:vc];
    
    
    [self addChildViewController:nav];
 
}


@end
