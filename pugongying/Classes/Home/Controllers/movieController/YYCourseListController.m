//
//  YYCourseListController.m
//  pugongying
//
//  Created by wyy on 16/4/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseListController.h"
#import "YYCourseCollectionCellModel.h"
#import "YYCourseListTableViewCell.h"
#import "YYCourseViewController.h"

#import "YYCourseCategoryModel.h"

#import "YYHomeDataBaseManager.h"

@interface YYCourseListController (){
    NSMutableArray *_courseArray;
    MJRefreshGifHeader *_headerRefresh;

    MJRefreshAutoNormalFooter *_footer;
    
    YYCourseCategoryModel *_courseCategoryModel;
    
    int _page;
    /**
     *  课程所有列表
     */
    NSString *_coursesAllListTable;
    /**
     *  断网时的View
     */
    YYNoNetViewBtn *_noNetBtnView;
    /**
     *  加载数据时的View
     */
    YYLoadingView *_loadingView;
}
@property (nonatomic, strong) NSArray *refreshImages;
@end

@implementation YYCourseListController
/**
 *  分类课程列表创建方法
 */
- (instancetype)initWithCourseCategoryModel:(YYCourseCategoryModel *)categoryModel andTableViewStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        _courseArray = [NSMutableArray array];
        _page = 1;
        
        _courseCategoryModel = categoryModel;
        _coursesAllListTable = @"coursesAllListTable";
        _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
        _noNetBtnView.y = -64;
        _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.title = categoryModel.categoryName;
        
        //根据网络状况以及数据库中的数据加载页面
        [self baseOnInterAndDataBaseLoadData];
        //设置课程分类列表下拉刷新
        [self setMJRefresh];
        //设置课程分类列表上拉刷新
        [self setFooter];
        
    }
    return self;
}
/**
 *  课程搜索列表创建方法
 */
- (instancetype)initWithSearchListWithArray:(NSArray *)modelsArray{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _courseArray = [NSMutableArray array];
        _page = 2;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.title = @"搜索结果";
        [_courseArray addObjectsFromArray:modelsArray];
    }
    return self;
}
#pragma mark 加载课程分类列表数据
/**
 *  加载课程分类列表数据
 */
- (void)getCourseListArrayWithPage:(int)page{
    YYLog(@"从网络获取课程数据");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"21";
    parameters[@"categoryid"] = _courseCategoryModel.categoryID;
    parameters[@"param"] = @"id";
    int index = (page-1)*10;
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        //停止刷新
        [_headerRefresh endRefreshing];
        [_footer endRefreshing];
        if (error) {
            YYLog(@"有错误");
            return;
        }
        
        NSString *msg = responseObject[@"msg"];
        if ([msg isEqualToString:@"error"]) {
            [_footer endRefreshingWithNoMoreData];
        }
        else if ([msg isEqualToString:@"ok"]) {
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [_loadingView removeFromSuperview];
            if (page == 1) {//如果是上拉刷新或者第一次刷新的话
                //清空数组
                [_courseArray removeAllObjects];
                //删除数据库中该分类的模型
                for (YYCourseCollectionCellModel *model in _courseArray) {
                    [database removeCourseWithID:model.courseID andCourseTable:_coursesAllListTable];
                }
            }
            
            NSArray *coursesArray = responseObject[@"ret"];
            
            if (coursesArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            
            if (coursesArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            
            NSMutableArray *array = [self analysisArrayWithGetArray:coursesArray];
            //在数据库加入该分组
            [database addCourses:array toCourseTable:_coursesAllListTable];
            
            [_courseArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
        
        }
    }];
}
#pragma mark 从本地数据库获取课程数据
- (void)getCoursesFromDataBase{
    YYLog(@"从本地数据库获取课程数据");
    YYHomeDataBaseManager *homeData = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    NSArray *retArray = [homeData coursesListFromCourseTable:_coursesAllListTable];
    //    YYLog(@"%@",retArray);
    for (YYCourseCollectionCellModel *model in retArray) {
        if ([model.categoryID isEqualToString:_courseCategoryModel.categoryID]) {
            [_courseArray addObject:model];
        }
    }
    [self.tableView reloadData];
}
/**
 *  解析获取到的数组
 */
- (NSMutableArray *)analysisArrayWithGetArray:(NSArray *)coursesArray{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *courseDic in coursesArray) {
        
        NSString * courseID = courseDic[@"id"];
        //课程分类ID
        NSString *categoryID = courseDic[@"categoryid"];
        
        NSString *courseTeacherID = courseDic[@"teacherid"];
        
        NSString *courseName = courseDic[@"title"];
        
        NSString *courseIntro = courseDic[@"intro"];
        
        // 分块四个四个显示时的图片
        NSString *courseimgurl = courseDic[@"imgurl"];
        // 课程信息中顶部的图
        NSString *showImgurl = courseDic[@"showimgurl"];
        // 列表展示图地址
        NSString *listImgurl = courseDic[@"listimgurl"];
        // 标签关键字
        NSString *tags = courseDic[@"tags"];
        //学习特色
        NSString *courseFeatures = courseDic[@"features"];
        //适合人群
        NSString *courseCrowd = courseDic[@"crowd"];
        //课件数量
        NSString *courseNumber = courseDic[@"seriesnum"];
        //收藏数量
        NSString *collectionNum = courseDic[@"collectionnum"];
        //评论数
        NSString *commentNum = courseDic[@"commentnum"];
        //课程评分
        NSString *score = courseDic[@"score"];
        
        
        YYCourseCollectionCellModel *model = [[YYCourseCollectionCellModel alloc] initWithcourseID:courseID categoryID:categoryID teacherID:courseTeacherID title:courseName introduce:courseIntro  courseimgurl:courseimgurl showImgurl:showImgurl listImgurl:listImgurl tags:tags feature:courseFeatures crowd:courseCrowd seriesNum:courseNumber collectionNum:collectionNum commentNum:commentNum score:score];
        
        [array addObject:model];
    }
    
    return array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseListTableViewCell *cell = [YYCourseListTableViewCell courseListTableViewCellWithTableView:tableView];
    
    YYCourseCollectionCellModel *model = _courseArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat courseImageViewH = 90 * scale;
    return courseImageViewH + 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseCollectionCellModel *model = _courseArray[indexPath.row];
    
    YYCourseViewController *courseController = [[YYCourseViewController alloc] initWithCourseModel:model];
    
    [self.navigationController pushViewController:courseController animated:YES];
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
#pragma mark 课程分类列表上下拉刷新
/**
 *  课程分类列表上下拉刷新
 */
- (void)setMJRefresh{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getCourseListArrayWithPage:_page];
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
- (void)setFooter{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getCourseListArrayWithPage:_page];
        YYLog(@"上拉刷新%d",_page);
    }];
    
    _footer = footer;
    
    if (_courseArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"视频已加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager coursesListFromCourseTable:_coursesAllListTable];
    //数据库没有数据
    BOOL haveData = NO;
    if (models.count != 0) {
        for (YYCourseCollectionCellModel *model in models) {
            if ([model.categoryID isEqualToString:_courseCategoryModel.categoryID]) {
                haveData = YES;
            }
        }
    }
    if (!haveData) {
        //判断网络状态
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == 0) {//断网，显示断网的View
            [self.view addSubview:_noNetBtnView];
        }
        else{
            [self.view addSubview:_loadingView];
            //加载数据
            [self getCourseListArrayWithPage:_page];
        }
        
    }
    //    数据库有数据
    else {
        [self getCoursesFromDataBase];
        //加载数据
        [self getCourseListArrayWithPage:_page];
        [self setMJRefresh];
    }
}
#pragma mark 断网的时候界面被点击
- (void)noNetWorkClick{
    YYLog(@"断网的时候界面被点击");
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:YYNetworkState] == 0) {
        [MBProgressHUD showError:@"网络错误，请连接网络"];
        return;
    }
    [_noNetBtnView removeFromSuperview];
    _loadingView.x = 0;
    _loadingView.y = -64;
    [self.view addSubview:_loadingView];
    
    
    [self getCourseListArrayWithPage:_page];
}

@end
