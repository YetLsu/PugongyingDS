//
//  YYWelcomeViewController.m
//  pugongying
//
//  Created by wyy on 16/3/15.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYWelcomeViewController.h"
#import "YYTabBarController.h"
#import "AppDelegate.h"
#import "UIButton+Create.h"

@interface YYWelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation YYWelcomeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //增加启动图
    [self addWelcomeScrollerView];
    //增加pageControl
    [self addPageController];
   
}
- (void)addWelcomeScrollerView{
    UIScrollView *welcomeScrollerView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:welcomeScrollerView];
    welcomeScrollerView.contentSize = CGSizeMake(YYWidthScreen * 3, YYHeightScreen);
    for (int i = 0; i < 3; i++) {
        CGFloat imageViewX = i * YYWidthScreen;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, YYWidthScreen, YYHeightScreen)];
        NSString *imageName = [NSString stringWithFormat:@"welcome_%d", i+1];
      
        imageView.image = [UIImage imageNamed:imageName];
        [welcomeScrollerView addSubview:imageView];
    }
    welcomeScrollerView.delegate = self;
    //在第三页上加按钮
    welcomeScrollerView.backgroundColor = [UIColor whiteColor];
    welcomeScrollerView.pagingEnabled = YES;
    welcomeScrollerView.showsVerticalScrollIndicator = NO;
    welcomeScrollerView.showsHorizontalScrollIndicator = NO;
    
    UIButton *welcomeBtn = [UIButton btnWithBGNorImgae:[UIImage imageNamed:@"welcome_btnbg"] bgHighImage:nil titleColor:[UIColor whiteColor] title:@"开启蒲公英2.0之旅"];
    welcomeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    CGFloat welcomeBtnW = 150;
    CGFloat welcomeBtnH = 40;
    CGFloat welcomeBtnX = (YYWidthScreen - welcomeBtnW)/2.0 + YYWidthScreen * 2;
    CGFloat welcomeBtnY = 1158 /1334.0 * YYHeightScreen;
    welcomeBtn.frame = CGRectMake(welcomeBtnX, welcomeBtnY, welcomeBtnW, welcomeBtnH);
    [welcomeScrollerView addSubview:welcomeBtn];
    [welcomeBtn addTarget:self action:@selector(gotoApp) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)addPageController{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    CGFloat pageControlY = 1160/1334.0 *YYHeightScreen;
    CGFloat pageControlW = 55;
    CGFloat pageControlX = (YYWidthScreen - pageControlW)/2.0;
    CGFloat pageControlH = 20;
    pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    [self.view addSubview:pageControl];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = YYBlueTextColor;
    
    self.pageControl = pageControl;
    
}

- (void)gotoApp{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [[YYTabBarController alloc] init];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offsetSize = scrollView.contentOffset;
    CGFloat offsetX = offsetSize.x + YYWidthScreen/2;
    NSInteger numberPage = offsetX/YYWidthScreen;
    if (numberPage == 2) {
        self.pageControl.hidden = YES;
    }
    else{
        self.pageControl.hidden = NO;
        self.pageControl.currentPage = numberPage;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
