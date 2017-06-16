//
//  YYMovieCollectionViewController.m
//  pugongying
//
//  Created by wyy on 16/4/27.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMovieCollectionViewController.h"


#import "YYCourseCollectionCellModel.h"
#import "YYCourseViewController.h"

#import "YYHomeDataBaseManager.h"
#import "YYCourseListController.h"
//一个课程CollectionViewcell
#import "YYCourseCollectionViewCell.h"
//课程组的HeaderView
#import "YYCourseCollectionHeaderView.h"
#import "YYCourseCollectionFirstHeaderView.h"

//课程分类模型
#import "YYCourseCategoryModel.h"

#import "YYCourseHistoryViewController.h"


@interface YYMovieCollectionViewController ()<YYCourseCollectionHeaderViewDelegate, YYCourseCollectionFirstHeaderViewDelegate>{
    
    /**
     *  存放课程分类，每个分类里面包含该课程4个课程
     */
    NSMutableArray *_categoryCourseArray;
    /**
     *  课程分类数组
     */
    NSMutableArray *_categoryArray;
    
    MJRefreshGifHeader *_headerRefresh;

    /**
     *  第一个组头的高度
     */
    CGFloat _firstHeaderH;
    /**
     *  其他组头的高度
     */
    CGFloat _otherHeaderH;
    /**
     *  顶部Scroller View的高度
     */
    CGFloat _topScrollerViewH;
    /**
     *  课程选择按钮条的高度
     */
    CGFloat _courseCategoryBtnsViewH;
    /**
     *  断网时的View
     */
    YYNoNetViewBtn *_noNetBtnView;
    /**
     *  加载数据时的View
     */
    YYLoadingView *_loadingView;
    /**
     * 课程视频展示界面表名
     */
    NSString *coursesCollectionTable;
}

@property (nonatomic, strong) NSArray *refreshImages;



@end

@implementation YYMovieCollectionViewController

static NSString * const courseCollectionViewID = @"courseCollectionViewID";
static NSString * const courseCollectionHeaderViewID = @"courseCollectionHeaderViewID";
static NSString * const courseCollectionFirstHeaderViewID = @"courseCollectionFirstHeaderViewID";

#pragma mark 获取数据
- (void)getDatasFromIntner{
    YYLog(@"从网络获取数据");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"211";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        //停止刷新
        [_headerRefresh endRefreshing];
        if (error) {
            YYLog(@"错误信息：%@",error);
            return;
        }
        NSString *msg = responseObject[@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            
            [_loadingView removeFromSuperview];
            
            YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [dataManager removeAllCoursesAtCourseTable:coursesCollectionTable];
            
            //移除所有数据
            [_categoryCourseArray removeAllObjects];
            //删除分类数组
            [_categoryArray removeAllObjects];
            //解析课程分类数组
            [self analysisCategoryArray:responseObject[@"ret_category"]];
            
            //有几个分类创建几个数组
            for (int i = 0; i < _categoryArray.count; i++) {
                NSMutableArray *array = [NSMutableArray array];
                [_categoryCourseArray addObject:array];
            }
            
            //获取课程数组
            NSArray *coursesArray = responseObject[@"ret"];
            //                YYLog(@"获取成功%@",coursesArray);
            
            NSMutableArray *allArray = [NSMutableArray array];
            
            for (NSDictionary *courseDic in coursesArray) {
                
                NSString *courseID = courseDic[@"id"];
                //课程分类ID
                NSString *categoryID = courseDic[@"categoryid"];
                NSInteger categoryid = categoryID.intValue;
                
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
                
                //把模型加入所有数据的数组
                [allArray addObject:model];
                
                //把模型加入对应的分类数组，分类从1开始
                [_categoryCourseArray[categoryid - 1] addObject:model];
                
            }
            //            YYLog(@"%@",_categoryCourseArray);
            [dataManager addCourses:allArray toCourseTable:coursesCollectionTable];
            
            [self.collectionView reloadData];
    }
    }];
}
/**
 * 解析课程分类数组
 */
- (void)analysisCategoryArray:(NSArray *)categoryArray{
    //    YYLog(@"%@",categoryArray);
    
    for (NSDictionary *dic in categoryArray) {
        //分类id
        NSString *categoryID = dic[@"id"];
        //类名
        NSString *categoryName = dic[@"name"];
        //图标地址
        NSString *categoryIcon = dic[@"iconimgurl"];
        //拥有的课程数
        NSString *categoryCourseNum = dic[@"coursenum"];
        
        YYCourseCategoryModel *model = [[YYCourseCategoryModel alloc] initWithCategoryID:categoryID categoryName:categoryName categoryIcon:categoryIcon categoryCourseNum:categoryCourseNum];
        
        [_categoryArray addObject:model];
    }
    
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:YYCourseCategoryArrayPath];
    
    [NSKeyedArchiver archiveRootObject:_categoryArray toFile:categoryPath];
    
}
#pragma mark 从本地数据库获取课程数据
- (void)getCoursesFromDataBase{
    YYLog(@"从本地数据库获取课程数据");
    YYHomeDataBaseManager *homeData = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    NSArray *retArray = [homeData coursesListFromCourseTable:coursesCollectionTable];
    //    YYLog(@"%@",retArray);
    
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:YYCourseCategoryArrayPath];
    _categoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryPath];
    //有几个分类创建几个数组
    for (int i = 0; i < _categoryArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [_categoryCourseArray addObject:array];
    }
    
    [retArray enumerateObjectsUsingBlock:^(YYCourseCollectionCellModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *categoryID = obj.categoryID;
        int category = categoryID.intValue;
        
        //把模型加入对应的分类数组，分类从1开始
        [_categoryCourseArray[category - 1] addObject:obj];
       
    }];
    [self.collectionView reloadData];
 
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"看视频";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home_course_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(courseHistoryBtnClick)];
    //初始化控件
    [self setupAllDatas];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[YYCourseCollectionViewCell class] forCellWithReuseIdentifier:courseCollectionViewID];
    [self.collectionView registerClass:[YYCourseCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:courseCollectionHeaderViewID];
    [self.collectionView registerClass:[YYCourseCollectionFirstHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:courseCollectionFirstHeaderViewID];
    [self setMJRefresh];
    [self baseOnInterAndDataBaseLoadData];
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager coursesListFromCourseTable:coursesCollectionTable];
    
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
            [self getDatasFromIntner];
        }
        
    }
//    数据库有数据
    else {
        [self getCoursesFromDataBase];
        //加载数据
        [self getDatasFromIntner];
    }
}

#pragma mark 历史按钮被点击
- (void)courseHistoryBtnClick{
    
    YYCourseHistoryViewController *history = [[YYCourseHistoryViewController alloc] init];
    [self.navigationController pushViewController:history animated:YES];
}
#pragma mark 初始化控件
/**
 *  初始化控件
 */
- (void)setupAllDatas{
    _categoryCourseArray = [NSMutableArray array];
    _categoryArray = [NSMutableArray array];
    _otherHeaderH = (12 + 40)/667.0 *YYHeightScreen;
    _courseCategoryBtnsViewH = 75/667.0 *YYHeightScreen;
    _topScrollerViewH = 145/667.0*YYHeightScreen;
    _firstHeaderH = _otherHeaderH + _courseCategoryBtnsViewH + _topScrollerViewH;
    
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    coursesCollectionTable = @"t_coursesCollectionTable";
    
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

    [self getDatasFromIntner];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _categoryCourseArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *array = _categoryCourseArray[section];
    return array.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    YYCourseCollectionViewCell *cell = [YYCourseCollectionViewCell courseCollectionCellWithCollectionView:collectionView andReuseIdentifier:courseCollectionViewID andIndexPath:indexPath];
    
    NSMutableArray *array = _categoryCourseArray[indexPath.section];
    YYCourseCollectionCellModel *model = array[indexPath.row];
    cell.model = model;


    
    return cell;
}
//设置每组headerView的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {

//            NSArray *array = [NSArray array];
            
            YYCourseCollectionFirstHeaderView *firstHeaderView = [YYCourseCollectionFirstHeaderView firstHeaderViewWithCollectionView:collectionView kind:kind reuseIdentifier:courseCollectionFirstHeaderViewID indexPath:indexPath imagesArray:@[@"home_course",@"home_course1"]];
            
            firstHeaderView.delegate = self;
            reusableView = firstHeaderView;
        }
        else{
            YYCourseCollectionHeaderView *headerView = [YYCourseCollectionHeaderView headerViewWithCollectionView:collectionView kind:kind reuseIdentifier:courseCollectionHeaderViewID indexPath:indexPath];
            
            headerView.delegate = self;
            reusableView = headerView;
        }
        
    }
    
    return reusableView;
}
//设置每组headerView的高度
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(YYWidthScreen, _firstHeaderH);
    }
    
    return CGSizeMake(YYWidthScreen, _otherHeaderH);
}
#pragma mark UICollectionView代理方法
//某个item被选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    YYLog(@"组：%ld \n item:%ld",(long)indexPath.section,(long)indexPath.item);
    
    NSMutableArray *array = _categoryCourseArray[indexPath.section];
    YYCourseCollectionCellModel *model = array[indexPath.item];
    
    YYCourseViewController *courseController = [[YYCourseViewController alloc] initWithCourseModel:model];
    [self.navigationController pushViewController:courseController animated:YES];
    
    return YES;
}
#pragma mark 除了第一组以外的更多被点击
/**
 *  除了第一组以外的更多被点击
 */
- (void)headerViewMoreBtnClickWithModel:(YYCourseCategoryModel *)categoryModel{
    
    YYCourseListController *listController = [[YYCourseListController alloc] initWithCourseCategoryModel:categoryModel andTableViewStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:listController animated:YES];
}
#pragma mark firstHeaderView的代理方法
#pragma mark 第一组更多被点击
/**
 *  第一组更多被点击
 */
- (void)firstHeaderViewMoreBtnClickWithModel:(YYCourseCategoryModel *)categoryModel{
    YYCourseListController *listController = [[YYCourseListController alloc] initWithCourseCategoryModel:categoryModel andTableViewStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:listController animated:YES];
}
/**
 *  顶部的ScrollerView被点击
 */
- (void)topScrollerViewClick{
    YYLog(@"顶部的ScrollerView被点击");
}
/**
 *  上面的分类按钮被点击
 */
- (void)courseCategoryBtnClickWithModel:(YYCourseCategoryModel *)categoryModel{
    YYCourseListController *list = [[YYCourseListController alloc] initWithCourseCategoryModel:categoryModel andTableViewStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:list animated:YES];
    
}
#pragma mark 设置刷新控件
- (void)setMJRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _headerRefresh = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        YYLog(@"刷新数据");
        [self getDatasFromIntner];
    }];
    
    // 设置普通状态的动画图片
    [_headerRefresh setImages:self.refreshImages forState:MJRefreshStateIdle];
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [_headerRefresh setImages:self.refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [_headerRefresh setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    // 设置header
    _headerRefresh.lastUpdatedTimeLabel.hidden = YES;
    _headerRefresh.stateLabel.hidden = YES;
    self.collectionView.mj_header = _headerRefresh;
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

@end
