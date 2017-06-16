//
//  YYOntherNewsTableViewController.m
//  pugongying
//
//  Created by wyy on 16/4/12.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYOntherNewsTableViewController.h"
#import "YYInformationFrame.h"
#import "YYInformationModel.h"
#import "YYInformationTableViewCell.h"
#import "YYWebViewController.h"
#import "YYHomeDataBaseManager.h"

@interface YYOntherNewsTableViewController (){
    MJRefreshAutoNormalFooter *_footer;
    int _page;

    MJRefreshGifHeader *_header;
    /**
     *  资讯数组
     */
    NSMutableArray *_newsArray;
    NSString *_categoryID;
    /**
     *  资讯表名
     */
    NSString *_newsTable;
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
 *  资讯数组
 */
@property (nonatomic, strong) NSArray *refreshImages;
@end

@implementation YYOntherNewsTableViewController
- (instancetype) initWithStyle:(UITableViewStyle)style andCategoryID:(NSString *)categoryID{
    if (self = [super initWithStyle:style]) {
        _categoryID = categoryID;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
#pragma mark 获取资讯列表
- (void)refreshInfomationsArrayWithPage:(int)page{
    YYLog(@"从网络获取");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"31";
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    int index = (page-1)*10;
//    YYLog(@"刷新时%d",page);
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];
    parameters[@"categoryid"] = _categoryID;
//    YYLog(@"%@",_categoryID);
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_footer endRefreshing];
        [_header endRefreshing];
        if (error) {
            YYLog(@"有错误：%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            [_footer endRefreshingWithNoMoreData];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            
            YYHomeDataBaseManager *dataBaseManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [_loadingView removeFromSuperview];
            
            if (page == 1) {//如果是上拉刷新或者第一次刷新的话
                //清空数组
                [_newsArray removeAllObjects];
                [dataBaseManager removeAllNewsAtTableName:_newsTable];
            }
            NSArray *retArray = responseObject[@"ret"];
            
            if (retArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            
            //已经没有新的数据
            if (retArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            [self getFrameArrayFromdataArray:retArray];
            
            [self.tableView reloadData];
        }

    }];
    
}
#pragma mark  从数据库读取资讯列表
/**
 *  从数据库读取资讯列表
 */
- (void)getInformationsFromDataBase{
    YYLog(@"从数据库读取资讯列表");
    YYHomeDataBaseManager *dataBaseManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    NSArray *retArray = [dataBaseManager newsListFromTableName:_newsTable];
    [_newsArray removeAllObjects];
    
    [retArray enumerateObjectsUsingBlock:^(YYInformationModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YYInformationFrame *modelFrame = [[YYInformationFrame alloc] init];
        
        modelFrame.model = obj;
        
        [_newsArray addObject:modelFrame];
    }];
    [self.tableView reloadData];
}

#pragma mark 解析资讯数组获取frame数组
- (void)getFrameArrayFromdataArray:(NSArray *)retArray{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in retArray) {

        YYInformationModel *model = [[YYInformationModel alloc] initWithTag:0];
        [model setValuesForKeysWithDictionary:dic];
        YYInformationFrame *modelFrame = [[YYInformationFrame alloc] init];
        modelFrame.model = model;
        [_newsArray addObject:modelFrame];
        
        [array addObject:model];
    }
    YYHomeDataBaseManager *dataBaseManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    [dataBaseManager addNews:array andNewsTableName:_newsTable];
    
}
#pragma mark 初始化控件
- (void)installDatas{
    
    _newsTable = @"t_newsTable";
    _page = 1;
    _newsArray = [NSMutableArray array];

    
    [self refreshInfomationsArrayWithPage:1];
    //下拉刷新
    [self setMJRefreshHeader];
    //    上拉加载
    [self footerRefresh];
    
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self installDatas];
    
    [self baseOnInterAndDataBaseLoadData];
    
    [self setMJRefreshHeader];
    //    上拉加载
    [self footerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _newsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYInformationTableViewCell *cell = [YYInformationTableViewCell informationCellWithTableView:tableView];
    
    YYInformationFrame *modelFrame = _newsArray[indexPath.row];
    
    cell.informationFrame = modelFrame;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}
#pragma mark - Table view的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYInformationFrame *modelFrame = _newsArray[indexPath.row];
    
    return modelFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
/**
 *  单元格被点击
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYInformationFrame *modelFrame = _newsArray[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(newsOtherCellClickWithModel:andCategoryID:)]) {
        [self.delegate newsOtherCellClickWithModel:modelFrame.model andCategoryID:_categoryID];
    }
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
#pragma mark 设置上拉下拉
- (void)setMJRefreshHeader{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
   _header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
       _page = 1;
       [_footer resetNoMoreData];
       [self refreshInfomationsArrayWithPage:_page];

   }];
    // 设置普通状态的动画图片
    [_header setImages:self.refreshImages forState:MJRefreshStateIdle];
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [_header setImages:self.refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [_header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    // 设置header
    _header.lastUpdatedTimeLabel.hidden = YES;
    _header.stateLabel.hidden = YES;
    self.tableView.mj_header = _header;
}
- (void)footerRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        YYLog(@"上拉刷新");
        _page++;
        [self refreshInfomationsArrayWithPage:_page];
    }];
    
    if (_newsArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"没有更多新的资讯" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = _footer;
}
#pragma mark 断网的时候界面被点击
- (void)noNetWorkClick{
    YYLog(@"断网的时候界面被点击");
    //判断网络状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == 0) {//断网
        [MBProgressHUD showError:@"网络错误，请连接网络"];
        return;
    }
    
    [_noNetBtnView removeFromSuperview];
    _loadingView.x = 0;
    _loadingView.y = -64;
    [self.view addSubview:_loadingView];
    
    _page = 1;
    [self refreshInfomationsArrayWithPage:_page];
    
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager newsListFromTableName:_newsTable];
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
            [self refreshInfomationsArrayWithPage:_page];
        }
        
    }
    //    数据库有数据
    else {
        [self getInformationsFromDataBase];
        //加载数据
        [self refreshInfomationsArrayWithPage:_page];
    }
}

@end
