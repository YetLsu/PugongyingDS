//
//  YYCourseCollectController.m
//  pugongying
//
//  Created by wyy on 16/4/18.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCollectController.h"
#import "YYCourseCollectionCellModel.h"
#import "YYCollectCourseFrame.h"
#import "YYCollectCourseCell.h"

#import "YYCourseViewController.h"
#import "YYMovieCollectionViewController.h"

#import "YYHomeDataBaseManager.h"

@interface YYCourseCollectController ()<YYCollectCourseCellDelegate>{
    /**
     * 已收藏课程的数组
     */
    NSMutableArray *_collectArray;
    
    MJRefreshAutoNormalFooter *_footer;
    int _page;
    MJRefreshGifHeader *_header;
    /**
     *  纪录返回到收藏页面的时候是否需要刷新数据,yes表示需要刷新，no不需要
     */
    BOOL _collectRefresh;
    
    /**
     *  UICollectionView的布局
     */
    UICollectionViewFlowLayout *_layout;
    /**
     *  断网时的View
     */
    YYNoNetViewBtn *_noNetBtnView;
    /**
     *  加载数据时的View
     */
    YYLoadingView *_loadingView;
    /**
     *  课程收藏列表
     */
    NSString *_coursesCollectTable;
}

@property (nonatomic, strong) NSArray *refreshImages;
/**
 *  暂无收藏课程的View
 */
@property (nonatomic, strong) UIView *noCollectCourseView;
@end

@implementation YYCourseCollectController
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
        label.text = @"暂无课程收藏";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:209/255.0 green:218/255.0 blue:225/255.0 alpha:1.0];
        
        //增加去课程按钮
        CGFloat courseBtnY = labelY + 20 + YY10HeightMargin;
        UIButton *courseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, courseBtnY, YYWidthScreen, 25)];
        [superView addSubview:courseBtn];
        [courseBtn setTitle:@"点击这里去发现你喜欢的课程吧" forState:UIControlStateNormal];
        [courseBtn setTitleColor:[UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [courseBtn setTitleColor:YYGrayTextColor forState:UIControlStateHighlighted];
        courseBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [courseBtn addTarget:self action:@selector(gotoSeeCourse) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noCollectCourseView;
}

#pragma mark 去收藏看视频
- (void)gotoSeeCourse{
    YYMovieCollectionViewController *movie = [[YYMovieCollectionViewController alloc] initWithCollectionViewLayout:_layout];
    [self.navigationController pushViewController:movie animated:YES];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.title = @"课程收藏";
//        self.navigationItem.t
    }
    return self;
}
#pragma mark 加载收藏的数据
- (void)getCollectArrayWithPage:(int)page{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"14";
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"userid"] = userId;
    
    int index = (page-1) * 10;
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_footer endRefreshing];
        [_header endRefreshing];
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        NSString *msg = responseObject[@"msg"];
        if ([msg isEqualToString:@"error"]) {
            if (page == 1) {
                [self.view addSubview:self.noCollectCourseView];
                self.tableView.scrollEnabled = NO;
                _collectRefresh = YES;
            }
            [_footer endRefreshingWithNoMoreData];
        }
        if ([msg isEqualToString:@"ok"]) {
            
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            
            [self.noCollectCourseView removeFromSuperview];
            [_loadingView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            
            if (page == 1) {
                [_collectArray removeAllObjects];
                [database removeAllCoursesAtCourseTable:_coursesCollectTable];
            }
            
            NSArray *coursesArray = responseObject[@"ret"];
            if (coursesArray.count > 0) {
                _collectRefresh = NO;
            }
            //已经没有新的数据
            if (coursesArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            
            NSMutableArray *array = [self analysisArrayWithGetArray:coursesArray];
            [_collectArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
        }
    }];
}
/**
 *  解析获取到的数组
 */
- (NSMutableArray *)analysisArrayWithGetArray:(NSArray *)coursesArray{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *modelsArray = [NSMutableArray array];
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    for (NSDictionary *courseDic in coursesArray) {
        NSString *courseID = courseDic[@"ucid"];
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
        
        YYCollectCourseFrame *modelFrame = [[YYCollectCourseFrame alloc] init];
        modelFrame.model = model;
        
        [array addObject:modelFrame];
        
        model.userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
        [modelsArray addObject:model];
        //增加收藏记录
        [database addCourseID:model.courseID andUserID:model.userID];
    }
    
    [database addCourses:modelsArray toCourseTable:_coursesCollectTable];
    return array;
}
/**
 *  初始化数据
 */
- (void)installDatas{
    
    _collectArray = [NSMutableArray array];
    _page = 1;
    _collectRefresh = NO;
    
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    _noNetBtnView.y = -64;
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _coursesCollectTable = @"t_coursesCollectTable";
    /**
     *  设置一个Item的长宽
     */
    CGFloat scale = YYWidthScreen / 375.0;
    
    CGFloat itemW = 160 * scale;
    //item之间的间距
    CGFloat xItemMargin = (YYWidthScreen - itemW * 2)/3.0;
    CGFloat courseImageViewH = 115.5 * scale;
    CGFloat sortLabelH = 10;
    
    CGFloat starH = 12.5;
    
    CGFloat yMargin = 5 * scale;
    CGFloat courseNameLabelH = 15;
    
    CGFloat itemH = courseImageViewH + courseNameLabelH + starH + sortLabelH + 3 * yMargin;
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(itemW, itemH);
    _layout.minimumLineSpacing = YY10HeightMargin;
    //    _layout.minimumInteritemSpacing = xItemMargin;
    
    _layout.sectionInset = UIEdgeInsetsMake(YY10HeightMargin, xItemMargin, YY10HeightMargin, xItemMargin);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self installDatas];
    
    [self baseOnInterAndDataBaseLoadData];
    
    [self setMJRefreshHeader];
    
    [self footerRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_collectRefresh) {
        YYLog(@"viewWillAppear");
        [self getCollectArrayWithPage:_page];
    }
    
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

    return _collectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCollectCourseCell *cell = [YYCollectCourseCell collectCourseCellWithTableView:tableView];
    
    YYCollectCourseFrame *courseFrame = _collectArray[indexPath.row];
    
    cell.collectFrame = courseFrame;
    
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark 代理方法
/**
 *  取消收藏
 */
- (void)cancelCollectCourseBtnClickWithFrame:(YYCollectCourseFrame *)courseFrame{
    YYLog(@"取消收藏课程Button被点击");
    [MBProgressHUD showMessage:@"正在取消收藏该课程"];
    
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"30";
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"userid"] = userId;
    parameters[@"courseid"] = courseFrame.model.courseID;
    YYLog(@"userid=%@\ncourseid=%@\n",userId,courseFrame.model.courseID);
    
    NSError *error = nil;
    if (error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"取消收藏课程失败"];
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    request.HTTPBody = data;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"取消收藏课程失败"];
            return ;
        }
//        YYLog(@"%@",data);
        NSError *dicError = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
        if (dicError) {
            [MBProgressHUD showError:@"取消收藏课程失败"];
            return ;
        }
//        YYLog(@"返回值%@",dict);
        if ([dict[@"msg"] isEqualToString:@"ok"]) {//删除成功
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            //从数据库删除收藏列表中的课程
            [database removeCourseWithID:courseFrame.model.courseID andCourseTable:_coursesCollectTable];
            //从数据库删除该收藏课程
            [database removeCollectWithCourseID:courseFrame.model.courseID andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
            
            [_collectArray removeObject:courseFrame];
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
/**
 *  查看收藏课程
 */
- (void)seeCourseBtnClickWithFrame:(YYCollectCourseFrame *)courseFrame{
    
    YYCourseViewController *course = [[YYCourseViewController alloc] initWithCourseModel:courseFrame.model];
    [self.navigationController pushViewController:course animated:YES];
    
}
#pragma mark tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCollectCourseFrame *courseFrame = _collectArray[indexPath.section];
    
    return courseFrame.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCollectCourseFrame *courseFrame = _collectArray[indexPath.section];
    
    YYCourseViewController *course = [[YYCourseViewController alloc] initWithCourseModel:courseFrame.model];
    [self.navigationController pushViewController:course animated:YES];
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
        [self getCollectArrayWithPage:_page];
        
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
        [self getCollectArrayWithPage:_page];
    }];
    
    if (_collectArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"没有更多收藏的课程" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = _footer;
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
    
    _page = 1;
    [self getCollectArrayWithPage:_page];
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager coursesListFromCourseTable:_coursesCollectTable];
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
            [self getCollectArrayWithPage:_page];
        }
        
    }
    //数据库有数据
    else {
        /**
         *  判断数据库中的是否是该用户的id
         */
        YYCourseCollectionCellModel *model = [models firstObject];
        NSString *lastUserID = model.userID;
        //数据库中的用户ID与现在的相同
        if ([lastUserID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]]){
            [self getClooectCoursesFromDataBase];
            //加载数据

            [self getCollectArrayWithPage:_page];
        }
        else{
            //清空数据库
            [dataManager removeAllCoursesAtCourseTable:_coursesCollectTable];
            [self.view addSubview:_loadingView];
            _loadingView.y = -64;
            //加载数据
            [self getCollectArrayWithPage:_page];
        }
    }
}
#pragma mark 从本地数据库获取课程数据
- (void)getClooectCoursesFromDataBase{
    YYLog(@"从本地数据库获取课程数据");
    YYHomeDataBaseManager *homeData = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    [_collectArray removeAllObjects];
    
    NSArray *retArray = [homeData coursesListFromCourseTable:_coursesCollectTable];
    //    YYLog(@"%@",retArray);
    for (YYCourseCollectionCellModel *model in retArray) {
        YYCollectCourseFrame *modelFrame = [[YYCollectCourseFrame alloc] init];
        modelFrame.model = model;
        [_collectArray addObject:modelFrame];
    }
    [self.tableView reloadData];
}
@end
