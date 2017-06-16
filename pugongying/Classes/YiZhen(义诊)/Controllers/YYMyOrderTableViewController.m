//
//  YYMyOrderTableViewController.m
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMyOrderTableViewController.h"
#import "YYYiZhenTableViewCell.h"
#import "YYYiZhenDetailsViewController.h"

#import "YYOnLineYiZhenViewController.h"

#import "YYYiZhenCaseFrame.h"

#import "YYClinicModel.h"
#import "YYYizhenUserModel.h"
#import "YYClinicDataBaseManager.h"

#define YizhenPostSuccess @"YizhenPostSuccess"

@interface YYMyOrderTableViewController ()<YYYiZhenTableViewCellDelegate>{
    
    MJRefreshGifHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footer;
    int _page;
    /**
     *  义诊案例数据表
     */
    NSString *_myClinicTable;
    /**
     *  断网时的View
     */
    YYNoNetViewBtn *_noNetBtnView;
    /**
     *  加载数据时的View
     */
    YYLoadingView *_loadingView;
    NSMutableArray *_clinicsArray;
}

@property (nonatomic, strong) NSArray *refreshImages;
/**
 *  没有订单时的View
 */
@property (nonatomic, strong) UIView *noOrderView;
@end

@implementation YYMyOrderTableViewController
#pragma mark 获取义诊数组
- (void)getclinicsArrayWithPage:(int)page{
    YYLog(@"从网络获取获取义诊数组");
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[@"mode"] = @"42";
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    attr[@"userid"] = userID;
    attr[@"page"] = [NSString stringWithFormat:@"%d",page];
    attr[@"index"] = [NSString stringWithFormat:@"%d",(page - 1) *10];

    [NSObject GET:YYHTTPSelectGET parameters:attr progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            YYClinicDataBaseManager *database = [YYClinicDataBaseManager shareClinicDataBaseManager];
            
            self.tableView.scrollEnabled = YES;
            NSArray *retArray = responseObject[@"ret"];
            
            if (retArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            //已经没有新的数据
            if (retArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:YYUpdateYizhen];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.noOrderView removeFromSuperview];
            [_loadingView removeFromSuperview];
            if (page == 1) {
                [_clinicsArray removeAllObjects];
                [database removeAllYizhensAtClinicTable:_myClinicTable];
            }
            
            self.tableView.scrollEnabled = YES;
            [self analyzingYizhenCaseWithArray:retArray];
            
            [self.tableView reloadData];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"error"]){
            [_loadingView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            if (page == 1) {
                [self.view addSubview:self.noOrderView];
            }
            else{
                [_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

- (void)getYizhensArray{
    _page = 1;
    [self getclinicsArrayWithPage:_page];
}
#pragma mark 初始化数据
- (void)installDatas{
    _page = 1;
    _myClinicTable = @"t_myClinicTable";
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    _clinicsArray = [NSMutableArray array];
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
    _loadingView.x = 0;
    _loadingView.y = -64;
    [self.view addSubview:_loadingView];
    
    _page = 1;
    [self getclinicsArrayWithPage:_page];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self installDatas];
    self.title = @"我的义诊";
    
    [self baseOnInterAndDataBaseLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getYizhensArray) name:YizhenPostSuccess object:nil];
    
    [self headerRefresh];
    [self footerRefresh];
}
#pragma mark 从本地数据库获取数据
- (void)getClinicsFromDataBase{
    YYLog(@"从本地数据库获取数据");
    YYClinicDataBaseManager *manager = [YYClinicDataBaseManager shareClinicDataBaseManager];
    NSArray *array  = [manager clinicsListFromClinicTable:_myClinicTable];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YYYiZhenCaseFrame *modelFrame = [[YYYiZhenCaseFrame alloc] init];
        modelFrame.model = obj;
        [_clinicsArray addObject:modelFrame];
    }];
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _clinicsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYYiZhenTableViewCell *cell = [YYYiZhenTableViewCell yiZhenTableViewCellWithTableView:tableView andTag:1];
    
    YYYiZhenCaseFrame *modelFrame = _clinicsArray[indexPath.section];
    
    cell.modelFrame = modelFrame;
    
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark tableview的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYYiZhenCaseFrame *modelFrame = _clinicsArray[indexPath.section];
    
    YYClinicModel *model = modelFrame.model;
    
    YYYiZhenDetailsViewController *yizhenDetail = [[YYYiZhenDetailsViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:yizhenDetail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYYiZhenCaseFrame *modelFrame = _clinicsArray[indexPath.section];
    
    return modelFrame.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark 单元格的代理方法
- (void)seeBtnClickWithModel:(YYClinicModel *)model{
    YYYiZhenDetailsViewController *controller = [[YYYiZhenDetailsViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 解析获取到的案例数组
- (void)analyzingYizhenCaseWithArray:(NSArray *)retArray{

    NSMutableArray *array = [NSMutableArray array];
    YYClinicDataBaseManager *dababase = [YYClinicDataBaseManager shareClinicDataBaseManager];
    
    for (NSDictionary *dic in retArray) {
        YYClinicModel *model = [[YYClinicModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        YYYizhenUserModel *userModel = [[YYYizhenUserModel alloc] initWithTag:0];
        [userModel setValuesForKeysWithDictionary:dic];
        model.userModel = userModel;
        
        YYYiZhenCaseFrame *modelFrame = [[YYYiZhenCaseFrame alloc] init];
        modelFrame.model = model;
        
        [array addObject:model];
        [_clinicsArray addObject:modelFrame];
    }
    [dababase addclinics:array andClinicTable:_myClinicTable];
}

- (NSArray *)refreshImages{
    if (!_refreshImages) {
        UIImage *img1 = [UIImage imageNamed:@"tableViewRefresh_1"];
        UIImage *img2 = [UIImage imageNamed:@"tableViewRefresh_2"];
        UIImage *img3 = [UIImage imageNamed:@"tableViewRefresh_3"];
        UIImage *img4 = [UIImage imageNamed:@"tableViewRefresh_4"];
        UIImage *img5 = [UIImage imageNamed:@"tableViewRefresh_5"];
        UIImage *img6 = [UIImage imageNamed:@"tableViewRefresh_6"];
        _refreshImages = @[img1,img2, img3, img4, img5, img6];
    }
    return _refreshImages;
}
#pragma mark 没有订单时的View
- (UIView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _noOrderView.y = -64;
        _noOrderView.backgroundColor = [UIColor whiteColor];
        
        UIView *contentView = [[UIView alloc] init];
        [_noOrderView addSubview:contentView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yizhen_noOrder"]];
        CGFloat imageW = 110;
        CGFloat imageH = 108.5;
        CGFloat imageX = (YYWidthScreen - imageW)/2.0;
        CGFloat imageY = 0;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [contentView addSubview:imageView];
        
        CGFloat labelH = 15;
        CGFloat labelY = imageH + YY12HeightMargin + labelH;
        CGFloat labelX = 0;
        CGFloat labelW = YYWidthScreen;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = @"您当前没有提单信息";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:209/255.0 green:218/255.0 blue:225/255.0 alpha:1.0];
        [contentView addSubview:label];
        //增加提交订单按钮
        CGFloat btnH = 40;
        CGFloat btnY = labelY + labelH;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, YYWidthScreen, btnH)];
        [contentView addSubview:btn];
        [btn setTitle:@"点击这里去申请线上诊断吧" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:YYGrayTextColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [btn addTarget:self action:@selector(gotoOnlineYizhen) forControlEvents:UIControlEventTouchUpInside];

        //设置content View的frame
        CGFloat contentViewH = imageH + labelH + btnH + YY12HeightMargin;
        CGFloat contentViewY = (YYHeightScreen - contentViewH)/2.0;
        contentView.frame = CGRectMake(0, contentViewY, YYWidthScreen, contentViewH);
        
        self.tableView.scrollEnabled = NO;
    }
    return _noOrderView;
}
/**
 *  去义诊
 */
- (void)gotoOnlineYizhen{
    YYLog(@"按钮被点击");
    YYOnLineYiZhenViewController *online = [[YYOnLineYiZhenViewController alloc] init];
    [self.navigationController pushViewController: online animated:YES];
}
#pragma mark 设置刷新控件
- (void)headerRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getclinicsArrayWithPage:_page];
        
        [_headerRefresh endRefreshing];
        YYLog(@"刷新数据");
    }];
    _headerRefresh = header;
    // 设置普通状态的动画图片
    [header setImages:self.refreshImages forState:MJRefreshStateIdle];
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    // 设置header
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;

}
- (void)footerRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
    
    _footer = footer;
    
    if (_clinicsArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"已加载所有提交的义诊" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = footer;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYClinicDataBaseManager *dataManager = [YYClinicDataBaseManager shareClinicDataBaseManager];
    NSArray *models = [dataManager clinicsListFromClinicTable:_myClinicTable];
    _page = 1;
    //数据库没有数据
    if (models.count == 0) {
        //判断网络状态
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == 0) {//断网，显示断网的View
            [self.view addSubview:_noNetBtnView];
        }
        else{
            [self.view addSubview:_loadingView];
            _loadingView.y = -64;
            //加载数据
            [self getclinicsArrayWithPage:_page];
        }
        
    }
    //    数据库有数据
    else {
        /**
         *  判断数据库中的是否是该用户的义诊
         */
        YYClinicModel *model = [models firstObject];
        NSString *lastUserID = model.userModel.userID;
        //数据库中的用户ID与现在的相同
        if ([lastUserID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]]) {
            [self getClinicsFromDataBase];
            //加载数据
            [self getclinicsArrayWithPage:_page];
        }
        else{
            //清空数据库
            [dataManager removeAllYizhensAtClinicTable:_myClinicTable];
            
            [self.view addSubview:_loadingView];
            _loadingView.y = -64;
            //加载数据
            [self getclinicsArrayWithPage:_page];
        }
        
    }
}

@end
