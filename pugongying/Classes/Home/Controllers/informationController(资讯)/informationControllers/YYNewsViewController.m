//
//  YYNewsViewController.m
//  pugongying
//
//  Created by wyy on 16/4/12.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  上面按钮的tag值为0，1，2，3
 */
#import "YYNewsViewController.h"
#import "YYInformationController.h"
#import "YYOntherNewsTableViewController.h"
#import "YYWebViewController.h"
#import "YYHomeDataBaseManager.h"
#import "YYNewsCategoryModel.h"

@interface YYNewsViewController ()<UIScrollViewDelegate, YYInformationControllerDelegate, YYOntherNewsTableViewControllerDelegate>{
    NSMutableArray *_newsCategoryArray;
    
    NSMutableArray *_controllerArray;
    
    int _index;
    
    
    /**
     *  断网时的View
     */
    YYNoNetViewBtn *_noNetBtnView;
    /**
     *  加载数据时的View
     */
    YYLoadingView *_loadingView;
    
}
/**
 *  顶部多个按钮的View
 */
@property (nonatomic, weak) UIView *topBtnsView;
/**
 *  第一个按钮
 */
@property (nonatomic, weak) UIButton *firstBtn;
@property (nonatomic, weak) UIButton *secondBtn;
@property (nonatomic, weak) UIScrollView *scrollerView;


@end

@implementation YYNewsViewController
#pragma mark 查询资讯分类
/**
 *  查询资讯分类
 */
- (void)getNewsCategory{
    YYLog(@"查询资讯分类");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"1";
    parameters[@"module"] = @"news";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误:%@",error);
            return;
        }
        YYLog(@"%@",responseObject);
        [_loadingView removeFromSuperview];
        
        NSArray *array = responseObject[@"ret"];
        for (NSDictionary *dic in array) {
            NSString *categoryID = dic[@"id"];
            NSString *categoryNewNum = dic[@"newsnum"];
            NSString *categoryName = dic[@"name"];
            
            YYNewsCategoryModel *model = [[YYNewsCategoryModel alloc] initWithnewsCategoryID:categoryID newsCategoryName:categoryName newsCategoryNewsNum:categoryNewNum];
            
            [_newsCategoryArray addObject:model];
        }
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:YYNewsCategoryArrayPath];
        [NSKeyedArchiver archiveRootObject:_newsCategoryArray toFile:path];
        [self setTopViewAndScrollerView];

    }];
}
#pragma mark 分类信息
/**
 *  根据分类信息设置顶部的View以及ScrollerView
 */
- (void)baseOnNewsCategorysSetTopViewAbdScrollerView{
   
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:YYNewsCategoryArrayPath];
        
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
    //获取到分类信息后创建顶部的分类按钮View
    if (!array) {//还未查询到资讯分类
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == 0) {
            [self.view addSubview:_noNetBtnView];
        }
        else{
            [self.view addSubview:_loadingView];
            [self getNewsCategory];
        }
        
    }
    else{
        _newsCategoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
        [self setTopViewAndScrollerView];
    }
}
#pragma mark 设置顶部的View以及ScrollerView
/**
 *  设置顶部的View以及ScrollerView
 */
- (void)setTopViewAndScrollerView{
    CGFloat topBtnsViewH= 40;
    [self addTopBtnsViewWithFrame:CGRectMake(0, 64, YYWidthScreen, topBtnsViewH)];
    
    //增加下面的Scroller View
    CGFloat scrollerViewY = topBtnsViewH + 64;
    CGFloat scrollerViewH = YYHeightScreen - scrollerViewY;
    [self addScrollerViewWithFrame:CGRectMake(0, scrollerViewY, YYWidthScreen, scrollerViewH)];
    
    //点击第一个推荐按钮
    if (_index == 1) {
        [self btnClickWithBtn:self.secondBtn];
    }
    else{
        [self btnClickWithBtn:self.firstBtn];
    }

}
#pragma mark 初始化数据
- (void)installData{
    _newsCategoryArray = [NSMutableArray array];
    _controllerArray = [NSMutableArray array];
    
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
}
- (instancetype)initWithIndex:(int)index{
    if (self = [super init]) {
        _index = index;
        /**
         *  初始化数据
         */
        [self installData];
        [self baseOnNewsCategorysSetTopViewAbdScrollerView];
        
        self.title = @"资讯";
        
        self.view.backgroundColor = [UIColor whiteColor];

    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        _index = 0;
        /**
         *  初始化数据
         */
        [self installData];
        self.title = @"资讯";
        
        [self baseOnNewsCategorysSetTopViewAbdScrollerView];
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark 增加顶部的四个按钮的View
/**
 *  增加顶部的四个按钮的View
 */
- (void)addTopBtnsViewWithFrame:(CGRect)btnsViewFrame{
    UIView *btnsView = [[UIView alloc] initWithFrame:btnsViewFrame];
    [self.view addSubview:btnsView];
    self.topBtnsView = btnsView;
    
    CGFloat btnXMargin = 20/375.0 * YYWidthScreen;
    //增加按钮
    CGFloat firstBtnX = YY18WidthMargin;
    CGFloat firstBtnW = 55;
    CGFloat firstBtnH = btnsViewFrame.size.height;
    [self addBtnWithBtnFrame:CGRectMake(firstBtnX, 0, firstBtnW, firstBtnH) andTag:0 andBtnTitle:@"推荐"];
    
    for (int i = 1; i <= _newsCategoryArray.count; i++) {
        CGFloat btnX = firstBtnX + (btnXMargin + firstBtnW) * i;
        YYNewsCategoryModel *model = _newsCategoryArray[i - 1];
        [self addBtnWithBtnFrame:CGRectMake(btnX , 0, firstBtnW, firstBtnH) andTag:i andBtnTitle:model.newsCategoryName];
    }

}
- (void)addBtnWithBtnFrame:(CGRect)btnFrame andTag:(NSInteger)tag andBtnTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [self.topBtnsView addSubview:btn];
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    [btn setTitleColor:YYBlueTextColor forState:UIControlStateSelected];
    [btn setTitleColor:YYBlueTextColor forState:UIControlStateHighlighted];
    
    btn.tag = tag;
    if (tag == 0) {
        self.firstBtn = btn;
    }
    else if (tag == 1){
        self.secondBtn = btn;
    }
    
    [btn addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClickWithBtn:(UIButton *)btn{
    
    btn.selected = YES;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    for (UIView *view in self.topBtnsView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)view;
            if (btn.tag != subBtn.tag) {
                subBtn.selected = NO;
                subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            }
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollerView.contentOffset = CGPointMake(btn.tag * YYWidthScreen, 0);
    }];
}
- (void)addScrollerViewWithFrame:(CGRect)scrollerViewFrame{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:scrollerViewFrame];
    [self.view addSubview:scrollerView];
    
    scrollerView.contentSize = CGSizeMake(YYWidthScreen * (_newsCategoryArray.count + 1), scrollerViewFrame.size.height);
    scrollerView.delegate = self;
    
    scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    
    self.scrollerView = scrollerView;
    
    //增加推荐的View
    YYInformationController *firstController = [[YYInformationController alloc] init];
    firstController.delegate = self;
    UITableView *firstTableView = firstController.tableView;
    firstTableView.frame = scrollerView.bounds;
    [scrollerView addSubview:firstTableView];
    [_controllerArray addObject:firstController];
    
    for (int i = 1; i <= _newsCategoryArray.count; i++) {
        
        NSString *categoryID = [NSString stringWithFormat:@"%d",i];
        YYOntherNewsTableViewController *secondController = [[YYOntherNewsTableViewController alloc] initWithStyle:UITableViewStyleGrouped andCategoryID:categoryID];
        secondController.delegate = self;
        UITableView *secondTableView = secondController.tableView;
        secondTableView.frame = scrollerView.bounds;
        secondTableView.x = YYWidthScreen * i;
        [scrollerView addSubview:secondTableView];
        [_controllerArray addObject:secondController];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark scroller View的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x/ YYWidthScreen;
    [self setBtnsStateWithSelectBtnTag:page];

}
/**
 *  设置按钮的选择状态
 */
- (void)setBtnsStateWithSelectBtnTag:(int)tag{
    for (UIView *subView in self.topBtnsView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == tag) {
                subBtn.selected = YES;
                subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
            }
            else {
                subBtn.selected = NO;
                subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            }
        }
    }
}
#pragma mark YYInformationControllerDelegate, YYOntherNewsTableViewControllerDelegate的代理方法
- (void)newsCellClickWithModel:(YYInformationModel *)model{
    YYWebViewController *webViewController = [[YYWebViewController alloc] initWithModel:model andnewsCategoryID:@"0"];
    [self.navigationController pushViewController:webViewController animated:YES];
}
- (void)newsOtherCellClickWithModel:(YYInformationModel *)model andCategoryID:(NSString *)categoryID{
    YYWebViewController *webViewController = [[YYWebViewController alloc] initWithModel:model andnewsCategoryID:categoryID];
    [self.navigationController pushViewController:webViewController animated:YES];
}
#pragma mark 断网的时候界面被点击
- (void)noNetWorkClick{
    YYLog(@"断网的时候界面被点击");
    
    //判断网络状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {
        [MBProgressHUD showError:@"网络错误，请连接网络"];
        return;
    }

    [_noNetBtnView removeFromSuperview];
    _loadingView.y = -64;
    [self.view addSubview:_loadingView];
    
    [self baseOnNewsCategorysSetTopViewAbdScrollerView];
    
}

@end
