//
//  YYCelebritiesTableViewController.m
//  pugongying
//
//  Created by wyy on 16/3/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCelebritiesTableViewController.h"
#import "YYMagazineModel.h"
#import "YYMagazineModelTableViewCell.h"
#import "YYBigImageViewController.h"

#import "YYHomeDataBaseManager.h"

@interface YYCelebritiesTableViewController (){
    int _page;
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
 *  名人堂模型数组
 */
@property (nonatomic, strong) NSMutableArray *modelsArray;

@property (nonatomic, strong) NSArray *refreshImages;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshAutoNormalFooter *footer;
@end

@implementation YYCelebritiesTableViewController
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

- (NSMutableArray *)modelsArray{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}
#pragma mark 获取数据
- (void)refreshCelebritiesArrayWithPage:(int)page{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"34";
    
    int index = (page - 1) * 10;
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];

    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            [self.footer endRefreshingWithNoMoreData];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [_loadingView removeFromSuperview];
            YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
            
            if (_page == 1) {
                [dataManager removeAllStorys];
                [self.modelsArray removeAllObjects];
                [self.footer resetNoMoreData];
            }
            
            NSArray *ret = responseObject[@"ret"];
            
            if (ret.count == 0) [self.footer setHidden:YES];
            else [self.footer setHidden:NO];
            
            if (ret.count < 10) {
                [self.footer endRefreshingWithNoMoreData];
            }
            
            //解析数组
            [self analysisArray:ret];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:YYFirstStory];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (_page == 1) {
                [dataManager addStorys:self.modelsArray];
            }
            [self.tableView reloadData];
        }
    }];
}
/**
 *  解析数组
 */
- (void)analysisArray:(NSArray *)retArray{
//    YYLog(@"%@",retArray);
    for (NSDictionary *dic in retArray) {

        //期刊ID
        NSString *magazineID = dic[@"id"];
        //分类（'人物刊','企业刊 '）
        NSString *magazineCategory = dic[@"category"];
        //标题
        NSString *magazineTitle = dic[@"title"];
        //简介
        NSString *magazineIntro = dic[@"intro"];
        //展示图地址
        NSString *magazineShowimgurl = dic[@"showimgurl"];
        // 网页链接
        NSString *magazineWebUrl = dic[@"weburl"];
        //访问人次数
        NSString *magazineVisitNum = dic[@"visitnum"];
        //分享数
        NSString *magazineShareNum = dic[@"sharenum"];
        
        YYMagazineModel *model = [[YYMagazineModel alloc] initWithID:magazineID category:magazineCategory title:magazineTitle intro:magazineIntro showimgurl:magazineShowimgurl weburl:magazineWebUrl visitnum:magazineVisitNum sharenum:magazineShareNum];
        [self.modelsArray addObject:model];
    }

}
#pragma mark  从数据库读取创业故事列表
- (void)getStorysFromDataBase{
    YYHomeDataBaseManager *dataBaseManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    NSArray *array = [dataBaseManager storysList];
    
    [self.modelsArray removeAllObjects];
    
    [array enumerateObjectsUsingBlock:^(YYMagazineModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.modelsArray addObject:obj];
        [self.tableView reloadData];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //根据网络状况以及数据库中的数据加载页面
    [self baseOnInterAndDataBaseLoadData];
    
    //设置下拉刷新
    [self setMJHeader];
    //设置上拉刷新
    [self setMJfooter];
    
    self.title = @"创业故事";
    self.tableView.backgroundColor = [UIColor whiteColor];
}
#pragma mark 断网的时候界面被点击
- (void)noNetWorkClick{
    YYLog(@"断网的时候界面被点击");
    //判断网络状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {//断网，显示断网的View
        [MBProgressHUD showError:@"网络错误，请连接网络"];
        return;
    }

    [_noNetBtnView removeFromSuperview];
    _loadingView.x = 0;
    _loadingView.y = -64;
    [self.view addSubview:_loadingView];
    
    _page = 1;
    [self refreshCelebritiesArrayWithPage:_page];
    
}

#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager storysList];
    
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
            //加载数据
            [self refreshCelebritiesArrayWithPage:_page];
        }
        
    }
    //    数据库有数据
    else {
        [self getStorysFromDataBase];
        //加载数据
        [self refreshCelebritiesArrayWithPage:_page];
       
    }
}

- (void)setMJHeader{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStoryData)];
    self.header = header;
    [header setImages:self.refreshImages forState:MJRefreshStateIdle];
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;

}
- (void)setMJfooter{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self refreshCelebritiesArrayWithPage:_page];
    }];
    self.footer = footer;
    if (self.modelsArray.count == 0) [self.footer setHidden:YES];
    else [self.footer setHidden:NO];
    
    [self.footer setTitle:@"数据加载完毕" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = footer;
}
#pragma mark 重新加载创业故事
- (void)loadNewStoryData{
    YYLog(@"重新加载创业故事");
    _page = 1;
    [self refreshCelebritiesArrayWithPage:_page];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMagazineModelTableViewCell *cell = [YYMagazineModelTableViewCell cerebritiesTableViewCellWithTableView:tableView];
    
    YYMagazineModel *model = self.modelsArray[indexPath.section];
    
    cell.model = model;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark tableView的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMagazineModel *model = self.modelsArray[indexPath.section];
    
    YYBigImageViewController *bigController = [[YYBigImageViewController alloc] initWithModel:model];
    
    [self.navigationController pushViewController:bigController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 图片的ImageView
    CGFloat cereImageViewH = 210/667.0*YYHeightScreen;
    return cereImageViewH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
@end
