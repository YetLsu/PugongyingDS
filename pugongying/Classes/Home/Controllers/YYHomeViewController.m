//
//  YYHomeViewController.m
//  pugongying
//
//  Created by wyy on 16/4/21.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  八个按钮的tag值从0到7
 *  三个按钮的tag值为 10,11,12
 */
#import "YYHomeViewController.h"
#import "WYYSearchBar.h"
#import "YYHomeSearchViewController.h"
#import "FFScrollView.h"
#import "YYNavigationController.h"


#import "YYMovieCollectionViewController.h"
#import "YYNewsViewController.h"
#import "YYSignInController.h"
#import "YYCelebritiesTableViewController.h"
#import "YYMySeedTableViewController.h"
#import "YYWriteCommentViewController.h"
#import "YYLoginRegisterViewController.h"
#import "YYCourseViewController.h"
#import "YYCircleViewController.h"

//课程模型
#import "YYCourseCollectionCellModel.h"
#import "YYCourseListTableViewCell.h"

#import "YYTitleImageBtn.h"

#import "UIImage+GIF.h"

#import "YYHomeDataBaseManager.h"
#import "YYNavigationController.h"

@interface YYHomeViewController ()<UITextFieldDelegate, FFScrollViewDelegate>{
    NSMutableArray *_showCoursesArray;
    MJRefreshGifHeader *_headerRefresh;
    
    CGFloat _bannerH;
    CGFloat _eightBtnViewH;
    CGFloat _threeBtnViewH;
    CGFloat _tableViewTitleH;
    
    /**
     *  UICollectionView的布局
     */
    UICollectionViewFlowLayout *_layout;
    /**
     *  课程推荐列表
     */
    NSString *_coursesRecommendTable;
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
 *  功能没有时的遮挡View
 */
@property (nonatomic, strong) UIView *noFunctionView;

@property (nonatomic, strong) NSArray *refreshImages;
/**
 *  headerView
 */
@property (nonatomic, weak) UIView *headerView;
/**
 *  三张图中的第一张图
 */
@property (nonatomic, weak) UIButton *firstBtnImageView;
/**
 *  换一批的图
 */
@property (nonatomic, weak) UIImageView *changeImageView;
@end

@implementation YYHomeViewController
#pragma mark获取推荐课程
- (void)getShowCourses{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"2";
    parameters[@"module"] = @"course";
    parameters[@"limit"] = @"5";
    parameters[@"rand"] = @"1";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        YYLog(@"%@",downloadProgress);
    } completionHandler:^(NSDictionary *responseObj, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        YYLog(@"%@",responseObj);
        NSString *msg = responseObj[@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            [_loadingView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            //删除数据库和数组中的数据
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database removeAllCoursesAtCourseTable:_coursesRecommendTable];
            [_showCoursesArray removeAllObjects];

            self.changeImageView.image = [UIImage imageNamed:@"home_huanyipi"];

            NSArray *coursesArray = responseObj[@"ret"];
            //            YYLog(@"获取成功%@",coursesArray);
            NSMutableArray *array = [self analysisArrayWithGetArray:coursesArray];
            //存入数据库
            [database addCourses:array toCourseTable:_coursesRecommendTable];

            [_showCoursesArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
        }
    }];
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
#pragma mark 从数据库加载数据
/**
 *  从数据库加载数据
 */
- (void)getShowCourseFromDataBase{
    
    [_showCoursesArray removeAllObjects];
    
    YYHomeDataBaseManager *manager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *courseArray = [manager coursesListFromCourseTable:_coursesRecommendTable];
    
    [_showCoursesArray addObjectsFromArray:courseArray];
    
    [self.tableView reloadData];
}
#pragma mark 懒加载功能没有时的遮挡View
- (UIView *)noFunctionView{
    if (!_noFunctionView) {
        _noFunctionView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _noFunctionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        //上面460，下面520
        //564,352
        CGFloat bgImageViewW = 282;
        CGFloat bgImageViewH = 176;
        CGFloat bgImageViewY = (YYHeightScreen -  bgImageViewH)/2.0;
        CGFloat bgImageViewX = (YYWidthScreen - bgImageViewW)/2.0;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
        [_noFunctionView addSubview:bgView];
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:bgView.bounds];
        [bgView addSubview:bgImage];
        bgImage.image = [UIImage imageNamed:@"home_welcome"];
        //增加按钮
        CGFloat btnW = 105;
        CGFloat btnH = 29;
        CGFloat btnX = (bgImageViewW - btnW)/2.0;
        CGFloat btnY = 118;
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        UIButton *btn = [YYPugongyingTool createBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH) superView:bgView backgroundImage:[UIImage imageNamed:@"home_welcome_btn"] titleColor:[UIColor whiteColor] title:@"朕知道了"];
        [btn addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _noFunctionView;
}
/**
 *  知道了按钮被点击
 */
- (void)knowBtnClick{
    [self.noFunctionView removeFromSuperview];
}
#pragma mark 懒加载headerView
- (UIView *)headerView{
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, _bannerH + _eightBtnViewH + _threeBtnViewH + _tableViewTitleH)];
        self.tableView.tableHeaderView = headerView;
        _headerView = headerView;
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
#pragma mark 在headerView中增加顶部的scroller View和三个按钮
/**
 *   在headerView中增加顶部的scroller View
 */
- (void)addScrollerViewWithpageNumber:(NSInteger)pageNumber{
    CGRect superFrame = self.headerView.bounds;
    FFScrollView *scroll = [[FFScrollView alloc]initPageViewWithFrame:CGRectMake(superFrame.origin.x, superFrame.origin.y, superFrame.size.width, _bannerH) views:@[@"home_course",@"home_news1",@"home_yizhen"]];
    
    scroll.pageViewDelegate = self;
    [self.headerView addSubview:scroll];
}
/**
 *  在headerView上增加八个按钮的View
 */
#pragma mark 在headerView上增加八个按钮的View
- (void)addEightBtnsView{
    CGFloat eightViewY = _bannerH;
    UIView *eightView = [[UIView alloc] initWithFrame:CGRectMake(0, eightViewY, YYWidthScreen, _eightBtnViewH)];
    [self.headerView addSubview:eightView];
    
    //增加按钮
    CGFloat btnH = _eightBtnViewH/2.0;
    CGFloat btnW = YYWidthScreen/4.0;

    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(0, 0, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_study"] andTag:0 andTitle:@"学习"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(btnW * 1, 0, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_news"] andTag:1 andTitle:@"资讯"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(btnW * 2, 0, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_tao"] andTag:2 andTitle:@"淘大"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(btnW * 3, 0, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_signIn"] andTag:3 andTitle:@"签到"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(0, btnH, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_weike"] andTag:4 andTitle:@"微课"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(btnW * 1, btnH, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_zhibo"] andTag:5 andTitle:@"直播"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(btnW * 2, btnH, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_circle"] andTag:6 andTitle:@"圈子"];
    
    [self addBtnToEightBtnsView:eightView andFrame:CGRectMake(btnW * 3, btnH, btnW, btnH) andImage:[UIImage imageNamed:@"home_eightBtn_fankui"] andTag:7 andTitle:@"反馈"];
}
- (void)addBtnToEightBtnsView:(UIView *)btnsView andFrame:(CGRect)btnFrame andImage:(UIImage *)norImage andTag:(NSInteger)btnTag andTitle:(NSString *)btnTitle{
    YYTitleImageBtn *btn = [[YYTitleImageBtn alloc] initWithNorImage:norImage andSelImage:norImage andFrame:btnFrame andTitle:btnTitle];

    [btnsView addSubview:btn];
    
    btn.tag = btnTag;
    
    [btn addTarget:self action:@selector(eightBtnOneClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)eightBtnOneClickWithBtn:(UIButton *)btn{
    YYLog(@"按钮被点击%ld",(long)btn.tag);
    if (btn.tag == 0) {
        
        YYMovieCollectionViewController *movieController = [[YYMovieCollectionViewController alloc] initWithCollectionViewLayout:_layout];
        [self.navigationController pushViewController:movieController animated:YES];
    }
    else if (btn.tag == 1){
        YYNewsViewController *newsController = [[YYNewsViewController alloc] init];
        [self.navigationController pushViewController:newsController animated:YES];
    }
    else if (btn.tag == 2){
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.noFunctionView];
    }
    else if (btn.tag == 3){
        //判断用户是否存在
        if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
            [self registerLoginBtnClick];
            return;
        }
        YYSignInController *signIn = [[YYSignInController alloc] init];
        [self.navigationController pushViewController:signIn animated:YES];
    }
    else if (btn.tag == 6){
        YYCircleViewController *circleController = [[YYCircleViewController alloc] init];
        [self.navigationController pushViewController:circleController animated:YES];
    }
    else if (btn.tag == 7){
        //判断用户是否存在
        if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
            [self registerLoginBtnClick];
            return;
        }
        
        YYWriteCommentViewController *write = [[YYWriteCommentViewController alloc] initWithOpinion];
        [self.navigationController pushViewController:write animated:YES];
    }
    else{
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.noFunctionView];
    }
}
/**
 *  在headerView上增加三个按钮的View
 */
#pragma mark 在headerView上增加三个按钮的View
- (void)addThreeBtnsView{
    CGFloat btnsViewY = _bannerH + _eightBtnViewH;
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, btnsViewY, YYWidthScreen, _threeBtnViewH)];
    btnsView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    [self.headerView addSubview:btnsView];
    //246,333
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat firstW = 123 * scale;
    CGFloat firstH = 167 * scale;
    //406,155
    CGFloat twoW = 203 * scale;
    CGFloat twoH = 77.5 *scale;
    
    CGFloat Xmargin = (YYWidthScreen - firstW - twoW)/(3 * 2 + 2) *scale;
    CGFloat Ymargin = (_threeBtnViewH - twoH * 2)/3.0 * scale;
    
    //增加第一张图
    UIButton *firstImageView = [[UIButton alloc] initWithFrame:CGRectMake(Xmargin * 3, Ymargin, firstW, firstH)];
    [btnsView addSubview:firstImageView];
    self.firstBtnImageView = firstImageView;
    [firstImageView setImage:[UIImage imageNamed:@"home_threeBtn_first"] forState:UIControlStateNormal];
    [firstImageView addTarget:self action:@selector(threeBtnViewsOneBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    firstImageView.tag = 10;
    
    //增加第二张图
    UIButton *secondImageView = [[UIButton alloc] initWithFrame:CGRectMake(Xmargin * 5 + firstW, Ymargin, twoW, twoH)];
    [btnsView addSubview:secondImageView];
    [secondImageView setImage:[UIImage imageNamed:@"home_threeBtn_second"] forState:UIControlStateNormal];
    [secondImageView addTarget:self action:@selector(threeBtnViewsOneBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    secondImageView.tag = 11;
    
    //增加第三张图
    UIButton *thirdImageView = [[UIButton alloc] initWithFrame:CGRectMake(Xmargin * 5 + firstW, Ymargin * 2 + twoH, twoW, twoH)];
    [btnsView addSubview:thirdImageView];
    [thirdImageView setImage:[UIImage imageNamed:@"home_threeBtn_third"] forState:UIControlStateNormal];
    [thirdImageView addTarget:self action:@selector(threeBtnViewsOneBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    thirdImageView.tag = 12;
}
/**
 *  三张图的按钮被点击
 */
- (void)threeBtnViewsOneBtnClickWithBtn:(UIButton *)btn{
    if (btn.tag == 10) {
        YYNewsViewController *news = [[YYNewsViewController alloc] initWithIndex:1];
        [self.navigationController pushViewController:news animated:YES];
    }
    else if (btn.tag == 11){
        YYCelebritiesTableViewController * someone = [[YYCelebritiesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:someone animated:YES];
    }
    else if (btn.tag == 12){
        YYMySeedTableViewController *myseed = [[YYMySeedTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:myseed animated:YES];
    }
}
/**
 *  在headerView上增加tableView的title
 */
#pragma mark 在headerView上增加tableView的title
/**
 *  在headerView上增加tableView的title
 */
- (void)addTableViewTitleView{
    CGFloat tableViewTitleY = _bannerH + _eightBtnViewH + _threeBtnViewH;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewTitleY, YYWidthScreen, _tableViewTitleH)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:titleView];
    
    //增加左边的一竖线
    CGFloat lineH = 20;
    CGFloat lineW = 5;
    CGFloat lineY = (_tableViewTitleH - lineH)/2.0;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, lineW, lineH)];
    [titleView addSubview:lineView];
    lineView.backgroundColor = YYBlueTextColor;
    //增加为您推荐Label
    UILabel *weininLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, lineY, 90, lineH)];
    [titleView addSubview:weininLabel];
    weininLabel.text = @"为您推荐";
    //27,27
    //换一批三个字label
    CGFloat huanLabelW = 45;
    CGFloat huanLabelX = YYWidthScreen - huanLabelW - YY18WidthMargin;
    UILabel *huanLabel = [[UILabel alloc] initWithFrame:CGRectMake(huanLabelX, lineY, huanLabelW, lineH)];
    huanLabel.textColor = YYBlueTextColor;
    huanLabel.text = @"换一批";
    [titleView addSubview:huanLabel];
    huanLabel.font = [UIFont systemFontOfSize:15];
    //增加换一批左侧的图
    CGFloat imageW = 13.5;
    CGFloat imageH = 13.5;
    CGFloat imageX = YYWidthScreen - huanLabelW - 5 - imageW - YY18WidthMargin;
    CGFloat imageY = (_tableViewTitleH - imageH)/2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];

    [titleView addSubview:imageView];
    self.changeImageView = imageView;
    self.changeImageView.image = [UIImage imageNamed:@"home_huanyipi"];
    
    //在换一批和图形上加一个按钮
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageX, 0, YYWidthScreen - imageX, _tableViewTitleH)];
    [titleView addSubview:changeBtn];
    [changeBtn addTarget:self action:@selector(changeCourseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //加横xian
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, _tableViewTitleH - 0.5, YYWidthScreen, 0.5) andView:titleView];
}

/**
 *  换一批按钮被点击
 */
- (void)changeCourseBtnClick{
    
    NSString  *name = @"home_changeShowCourse.gif";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    self.changeImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    
    [self getShowCourses];
//    YYLog(@"换一批按钮被点击");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self installData];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];

    //在headerView上增加banner图
    [self addScrollerViewWithpageNumber:2];
    //在headerView上增加八个按钮的View
    [self addEightBtnsView];
    
    //增加三个按钮的View
    [self addThreeBtnsView];
    
    //在headerView上增加tableView的title
    [self addTableViewTitleView];
    
    //设置控制器的titleView
    [self setControllerTitleView];
    
       //设置tableView没有下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //根据网络状态设置界面
    [self baseOnInterAndDataBaseLoadData];
    
   
}
#pragma mark 初始化数据
/**
 *  初始化数据
 */
- (void)installData{
    _bannerH = 145/667.0 * YYHeightScreen;
    
    CGFloat scale = YYWidthScreen / 375.0;
    _eightBtnViewH = (12 * 4 + 75 * 2) * scale;
    _threeBtnViewH = 190 * scale;
    _tableViewTitleH = 45 * scale;
    
    _showCoursesArray = [NSMutableArray array];
    _coursesRecommendTable = @"t_coursesRecommendTable";
    
    /**
     *  设置一个Item的长宽
     */
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
    
    _noNetBtnView = [[YYNoNetViewBtn alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[YYLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];


}

#pragma mark 设置控制器的titleView
/**
 *  设置控制器的titleView
 */
- (void)setControllerTitleView{
    WYYSearchBar *searchBar = [WYYSearchBar searchBarWithPlaceholderText:@"搜索课程"];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;//676,55
    searchBar.height = 27.5;
    searchBar.width = 338 /375.0 * YYWidthScreen;
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
    return _showCoursesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseListTableViewCell *cell = [YYCourseListTableViewCell courseListTableViewCellWithTableView:tableView];
    
    YYCourseCollectionCellModel *model = _showCoursesArray[indexPath.row];
    
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
#pragma mark tableView的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseCollectionCellModel *model = _showCoursesArray[indexPath.row];
    YYCourseViewController *courseViewController = [[YYCourseViewController alloc] initWithCourseModel:model];
    
    [self.navigationController pushViewController:courseViewController animated:YES];
}
#pragma mark uitextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    YYHomeSearchViewController *controller = [[YYHomeSearchViewController alloc] initWithSearchQuestion:@"搜索课程"];
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:^{
        [controller.searchBar becomeFirstResponder];
    }];
    YYLog(@"开始输入");
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -64) {
        scrollView.contentOffset = CGPointMake(0, -64);
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
    
    [self getShowCourses];
    
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *dataManager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [dataManager coursesListFromCourseTable:_coursesRecommendTable];
    //数据库没有数据
    if (models.count == 0) {
        //判断网络状态
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == 0) {//断网，显示断网的View
            _noNetBtnView.y = -64;
            [self.view addSubview:_noNetBtnView];
            self.tableView.scrollEnabled = NO;
        }
        else{
            [self.view addSubview:_loadingView];
            self.tableView.scrollEnabled = NO;
            //加载数据
            [self getShowCourses];
        }
        
    }
    //    数据库有数据
    else {
        [self getShowCourseFromDataBase];
        //加载数据
        [self getShowCourses];
    }
}
#pragma mark 登陆注册按钮被点击 触发登录动作
/**
 *  登陆注册按钮被点击 触发登录动作
 */
- (void)registerLoginBtnClick{
    
    YYLoginRegisterViewController *loginRegister = [[YYLoginRegisterViewController alloc] init];
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:loginRegister];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
