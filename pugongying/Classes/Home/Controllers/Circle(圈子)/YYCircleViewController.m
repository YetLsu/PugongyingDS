//
//  YYCircleViewController.m
//  pugongying
//
//  Created by wyy on 16/5/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCircleViewController.h"
#import "UIButton+Create.h"
#import "YYShowCircleTableViewController.h"
#import "YYJoinCircleTableViewController.h"
#import "YYCircleChatTableViewController.h"
#import "YYShowCircleModel.h"

@interface YYCircleViewController (){
    /**
     *  推荐圈子控制器
     */
    YYShowCircleTableViewController *_showCircleController;
    /**
     *  已加入圈子控制器
     */
    YYJoinCircleTableViewController *_joinCircleController;
}
@property (nonatomic, weak) UIButton *showCircleBtn;

@property (nonatomic, weak) UIButton *joinBtn;

@property (nonatomic, weak) UIScrollView *scrollerView;
@end

@implementation YYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    [self setNavBar];
    [self showCircleBtnClick];
    
    //增加ScrollerView
    [self addScrollerView];
}
#pragma mark 设置导航栏
/**
 * 设置导航栏
 */
- (void)setNavBar{
    UIView *navBarView = [[UIView alloc] init];
    navBarView.tintColor = YYBlueTextColor;
    navBarView.backgroundColor = YYBlueTextColor;
    [self.view addSubview:navBarView];
    __weak __typeof(&*self)weakSelf = self;
    [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(64);
    }];
    //增加左边的返回按钮
    UIButton *gobackBtn = [[UIButton alloc] init];
    [gobackBtn setImage:[UIImage imageNamed:@"navigation_previous"] forState:UIControlStateNormal];
    gobackBtn.imageView.contentMode = UIViewContentModeCenter;
    [navBarView addSubview:gobackBtn];
    [gobackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(weakSelf.view);
        make.height.width.mas_equalTo(44);
    }];
    [gobackBtn addTarget:self action:@selector(gobackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加顶部中间的两个按钮
    UIButton *leftBtn = [UIButton btnWithBGNorImgae:[UIImage imageNamed:@"home_circle_left_nor"] bgHighImage:[UIImage imageNamed:@"home_circle_left_sel"] titleNorColor:[UIColor whiteColor] titleSelColor:YYBlueTextColor title:@"推荐圈"];
    [navBarView addSubview:leftBtn];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"home_circle_left_nor"] forState:UIControlStateHighlighted];
    self.showCircleBtn = leftBtn;
    
    CGFloat leftBtnW = 80;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.width/2 - leftBtnW);
        make.top.mas_equalTo(27);
        make.width.mas_equalTo(leftBtnW);
        make.height.mas_equalTo(30);
    }];
    [leftBtn addTarget:self action:@selector(showCircleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加右边已加入
    UIButton *rightBtn = [UIButton btnWithBGNorImgae:[UIImage imageNamed:@"home_circle_right_nor"] bgHighImage:[UIImage imageNamed:@"home_circle_right_sel"] titleNorColor:[UIColor whiteColor] titleSelColor:YYBlueTextColor title:@"已加入"];
    [navBarView addSubview:rightBtn];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"home_circle_right_nor"] forState:UIControlStateHighlighted];
    self.joinBtn = rightBtn;
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.width/2);
        make.top.mas_equalTo(leftBtn);
        make.size.mas_equalTo(leftBtn);
    }];
    [rightBtn bk_addEventHandler:^(id sender) {
        YYLog(@"已加入被点击");
        rightBtn.selected = YES;
        leftBtn.selected = NO;
    } forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 增加ScrollerView
/**
 *  增加ScrollerView
 */
- (void)addScrollerView{
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollerView];
    self.scrollerView = scrollerView;
    __weak __typeof(&*self)weakSelf = self;
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(weakSelf.view);
    }];
    
    scrollerView.contentSize = CGSizeMake(YYWidthScreen * 2, YYHeightScreen - 64);
    scrollerView.pagingEnabled = YES;
//    scrollerView.showsVerticalScrollIndicator = NO;
//    scrollerView.showsHorizontalScrollIndicator = NO;
    
    //增加推荐圈子控制器的View
    _showCircleController = [[YYShowCircleTableViewController alloc] init];
    UITableView *showCircleTableView = _showCircleController.tableView;

    [scrollerView addSubview:showCircleTableView];
    [showCircleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(scrollerView);
        make.width.mas_equalTo(YYWidthScreen);
        make.bottom.mas_equalTo(weakSelf.view);
    }];
   
    _showCircleController.circleCellClickBlock = ^(YYShowCircleModel *circleModel){
        YYCircleChatTableViewController *circleChat = [[YYCircleChatTableViewController alloc] initWithModel:circleModel];
        [weakSelf.navigationController pushViewController:circleChat animated:YES];
    };
//
//    //增加已加入圈子控制器的View
//    _joinCircleController = [[YYJoinCircleTableViewController alloc] init];
    
    
    
}
/**
 * 推荐圈被点击
 */
- (void)showCircleBtnClick{
    self.showCircleBtn.selected = YES;
    self.joinBtn.selected = NO;
    YYLog(@"推荐圈被点击");
}
/**
 *  返回按钮被点击
 */
- (void)gobackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
