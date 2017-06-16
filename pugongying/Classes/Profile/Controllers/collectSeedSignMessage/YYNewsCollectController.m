//
//  YYNewsCollectController.m
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYNewsCollectController.h"
#import "YYCollectNewsFrame.h"
#import "YYCollectNewsCell.h"
#import "YYInformationModel.h"
#import "YYWebViewController.h"

#import "YYNewsViewController.h"
#import "YYHomeDataBaseManager.h"

@interface YYNewsCollectController ()<YYCollectNewsCellDelegate>{
    /**
     * 已收藏资讯的数组
     */
    NSMutableArray *_collectArray;
    /**
     *  纪录返回到收藏页面的时候是否需要刷新数据,yes表示需要刷新，no不需要
     */
    BOOL _collectRefresh;
    int _page;
    
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshGifHeader *_header;
    
    /**
     *  断网时的View
     */
    YYNoNetViewBtn *_noNetBtnView;
    /**
     *  加载数据时的View
     */
    YYLoadingView *_loadingView;
    /**
     *  资讯收藏表名
     */
    NSString *_newsCollectTable;
}

@property (nonatomic, strong) NSArray *refreshImages;

/**
 *  暂无收藏课程的View
 */
@property (nonatomic, strong) UIView *noCollectCourseView;

@end

@implementation YYNewsCollectController
#pragma mark 获取资讯列表
- (void)refreshInfomationsArrayWithPage:(int)page{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"15";
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    int index = (page-1)*10;
//    YYLog(@"刷新时%d",page);
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_footer endRefreshing];
        [_header endRefreshing];
        if (error) {
            YYLog(@"有错误%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            if (page == 1) {
                [self.view addSubview:self.noCollectCourseView];
                self.tableView.scrollEnabled = NO;
                _collectRefresh = YES;
            }
            
            [_footer endRefreshingWithNoMoreData];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            
            [_loadingView removeFromSuperview];
            [self.noCollectCourseView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            
            if (page == 1) {//如果是上拉刷新或者第一次刷新的话
                //清空数组
                [_collectArray removeAllObjects];
                [database removeAllCoursesAtCourseTable:_newsCollectTable];
            }
            NSArray *retArray = responseObject[@"ret"];
            
            if (retArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            
            if (retArray.count > 0) {
                _collectRefresh = NO;
            }
            //已经没有新的数据
            if (retArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            
            [self getFrameArrayFromdataArray:retArray];
            [self.tableView reloadData];
        }

    }];
}
#pragma mark 解析资讯数组获取frame数组
- (void)getFrameArrayFromdataArray:(NSArray *)retArray{
    
    NSMutableArray *modelsArray = [NSMutableArray array];
    
    for (NSDictionary *dic in retArray) {
//        YYLog(@"%@",dic);
        YYInformationModel *model = [[YYInformationModel alloc] initWithTag:1];
        [model setValuesForKeysWithDictionary:dic];
        YYCollectNewsFrame *modelFrame = [[YYCollectNewsFrame alloc] init];
        modelFrame.model = model;
        [_collectArray addObject:modelFrame];
        
        model.userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
        [modelsArray addObject:model];
    }
    
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    [database addNews:modelsArray andNewsTableName:_newsCollectTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_collectRefresh) {
        YYLog(@"viewWillAppear");
        _page = 1;
        [self refreshInfomationsArrayWithPage:_page];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章收藏";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化参数
    [self installData];
    
    [self baseOnInterAndDataBaseLoadData];
    
    [self setMJRefreshHeader];
    
    [self footerRefresh];
    
}
/**
 *  初始化参数
 */
- (void)installData{
    _collectArray = [NSMutableArray array];
    _page = 1;
    _collectRefresh = NO;
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    _noNetBtnView.y = -64;
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _newsCollectTable = @"t_newsCollectTable";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _collectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCollectNewsCell *cell = [YYCollectNewsCell collectNewsCellWithTableView:tableView];
    
    YYCollectNewsFrame *modelFrame = _collectArray[indexPath.row];
    
    cell.modelFrame = modelFrame;
    
    cell.delegate = self;
    
    return cell;
}
#pragma mark tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCollectNewsFrame *modelFrame = _collectArray[indexPath.row];
    
    return modelFrame.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCollectNewsFrame *modelFrame = _collectArray[indexPath.row];
    
    YYWebViewController *newsController = [[YYWebViewController alloc] initWithModel:modelFrame.model andnewsCategoryID:modelFrame.model.categoryid];
    [self.navigationController pushViewController:newsController animated:YES];
}
#pragma mark YYCollectNewsCellDelegate的代理方法
- (void)cancelCollectNewsBtnClickWithFrame:(YYCollectNewsFrame *)newsFrame{
    [MBProgressHUD showMessage:@"正在取消收藏该资讯"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"31";
    parameters[@"newsid"] = newsFrame.model.newsID;
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    request.HTTPBody = data;
    
    if (error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"取消收藏资讯失败"];
        return;
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"取消收藏资讯失败"];
            return ;
        }
        //        YYLog(@"%@",data);
        NSError *dicError = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
        if (dicError) {
            [MBProgressHUD showError:@"取消收藏资讯失败"];
            return ;
        }
        YYLog(@"返回值%@",dict);
        if ([dict[@"msg"] isEqualToString:@"ok"]) {//删除成功
            [_collectArray removeObject:newsFrame];
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database removeNewsWithID:newsFrame.model.newsID andTableName:_newsCollectTable];
            
            [MBProgressHUD showSuccess:@"已取消收藏"];
            if (_collectArray.count == 0) {
                [self.view addSubview:self.noCollectCourseView];
                self.tableView.scrollEnabled = NO;
                _collectRefresh = YES;
            }
            [self.tableView reloadData];
            
        }
    }];

}
- (void)seeNewsBtnClickWithFrame:(YYCollectNewsFrame *)newsFrame{

    YYWebViewController *newsController = [[YYWebViewController alloc] initWithModel:newsFrame.model andnewsCategoryID:newsFrame.model.categoryid];
    [self.navigationController pushViewController:newsController animated:YES];
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
    
    if (_collectArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"没有更多收藏的资讯" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = _footer;
}

- (UIView *)noCollectCourseView{
    if (!_noCollectCourseView) {
        _noCollectCourseView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _noCollectCourseView.backgroundColor = [UIColor whiteColor];
        
        CGFloat viewW = YYWidthScreen;
        CGFloat viewH = 72 + YY10HeightMargin + 20 + YY10HeightMargin + 25;
        CGFloat viewX = 0;
        CGFloat viewY = (YYHeightScreen - viewH)/2.0 - 64;
        
        UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        [_noCollectCourseView addSubview:superView];
        
        
        CGFloat imageW = 71.5;
        CGFloat imageH = 72;
        CGFloat imageX = (YYWidthScreen - imageW)/2.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 0, imageW, imageH)];
        [superView addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"profile_nocollect"];
        
        
        //增加暂无课程收藏的label
        CGFloat labelY = imageH + YY10HeightMargin;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, YYWidthScreen, 20)];
        [superView addSubview:label];
        label.text = @"暂无资讯收藏";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:209/255.0 green:218/255.0 blue:225/255.0 alpha:1.0];
        
        //增加去课程按钮
        CGFloat courseBtnY = labelY + 20 + YY10HeightMargin;
        UIButton *courseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, courseBtnY, YYWidthScreen, 25)];
        [superView addSubview:courseBtn];
        [courseBtn setTitle:@"点击这里去收藏资讯吧" forState:UIControlStateNormal];
        [courseBtn setTitleColor:[UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [courseBtn setTitleColor:YYGrayTextColor forState:UIControlStateHighlighted];
        courseBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [courseBtn addTarget:self action:@selector(gotoSeeNews) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noCollectCourseView;
}
- (void)gotoSeeNews{
    YYNewsViewController *news = [[YYNewsViewController alloc] init];
    [self.navigationController pushViewController:news animated:YES];
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
    [self refreshInfomationsArrayWithPage:_page];
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager newsListFromTableName:_newsCollectTable];
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
            [self refreshInfomationsArrayWithPage:_page];
        }
    }
    //数据库有数据
    else {
        /**
         *  判断数据库中的是否是该用户的id
         */
        YYInformationModel *model = [models firstObject];
        NSString *lastUserID = model.userID;
        //数据库中的用户ID与现在的相同
        if ([lastUserID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]]){
            [self getClooectCoursesFromDataBase];
            //加载数据
            [self refreshInfomationsArrayWithPage:_page];
        }
        else{
            //清空数据库
            [dataManager removeAllCoursesAtCourseTable:_newsCollectTable];
            [self.view addSubview:_loadingView];
            _loadingView.y = -64;
            //加载数据
            [self refreshInfomationsArrayWithPage:_page];
        }
    }
}
#pragma mark 从本地数据库获取课程数据
- (void)getClooectCoursesFromDataBase{
    YYLog(@"从本地数据库获取课程数据");
    YYHomeDataBaseManager *homeData = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    [_collectArray removeAllObjects];
    
    NSArray *retArray = [homeData newsListFromTableName:_newsCollectTable];
    //    YYLog(@"%@",retArray);
    for (YYInformationModel *model in retArray) {
        YYCollectNewsFrame *modelFrame = [[YYCollectNewsFrame alloc] init];
        modelFrame.model = model;
        [_collectArray addObject:modelFrame];
    }
    [self.tableView reloadData];
}

@end
