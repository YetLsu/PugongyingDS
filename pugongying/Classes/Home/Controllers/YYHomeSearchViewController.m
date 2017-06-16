//
//  YYHomeSearchViewController.m
//  pugongying
//
//  Created by wyy on 16/4/21.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYHomeSearchViewController.h"
#import "WYYSearchBar.h"
#import "YYCourseListController.h"
#import "YYCourseCollectionCellModel.h"


@interface YYHomeSearchViewController ()<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>{
    CGFloat _yMargin;
    CGFloat _itemH;
    
    NSMutableArray *_itemsArray;
    NSString *_ID;
    NSString *_question;
    
}
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation YYHomeSearchViewController
/**
 *  获取热门搜索关键词
 */
- (void)getSearchTerms{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"28";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSDictionary *responseObject, NSError *error) {
        
        if (error) {
            YYLog(@"error:%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSArray *ret = responseObject[@"ret"];
            
            for (NSDictionary *dic in ret) {
                NSString *name = dic[@"name"];
                [_itemsArray addObject:name];
            }
            [self.collectionView reloadData];
        }
    }];
}

- (instancetype)initWithSearchQuestion:(NSString *)question{
    if (self = [super init]) {
        _itemH = 40 / 667.0 * YYHeightScreen;
        _yMargin = YY12HeightMargin;
        _itemsArray = [NSMutableArray array];
        _ID = @"YYHomeSearchViewControllerCell";
        _question = question;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self getSearchTerms];
        //增加热门搜索的label
        CGFloat lableY = 64 + YY12HeightMargin;
        CGFloat labelW = YYWidthScreen - YY18WidthMargin * 2;
        CGFloat labelH = 40 / 667.0 * YYHeightScreen;
        [self addTitleLabelWithFrame:CGRectMake(YY18WidthMargin, lableY, labelW, labelH)];
        //增加热门搜索内容的CollectionView
        CGFloat collectionViewY = lableY + labelH;
        CGFloat collectionViewH = _itemH * 3 + 2 *_yMargin;
        [self addCollectionViewWithFrame:CGRectMake(0, collectionViewY, YYWidthScreen, collectionViewH)];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //增加顶部的导航栏
    [self addNavBarWithHeight:64];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
/**
 *  增加顶部的导航栏
 */
- (void)addNavBarWithHeight:(CGFloat)height{
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, height)];
    [self.view addSubview:navBar];
    navBar.backgroundColor = YYBlueTextColor;
    
    //添加右边的取消按钮
    CGFloat cancelW = 40;
    CGFloat cancelX = YYWidthScreen - cancelW - YY18WidthMargin;
    CGFloat cancelY = 20;
    CGFloat cancelH = height - 20;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
    [navBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加搜索框
    CGFloat searchBarX = YY18WidthMargin;
    CGFloat searchBarW = YYWidthScreen - searchBarX - cancelW - 5 - YY18WidthMargin;
    CGFloat searchBarH = 27.5;
    CGFloat searchBarY = (height - 20 - searchBarH)/2.0 + 20;
    WYYSearchBar *searchBar = [WYYSearchBar searchBarWithPlaceholderText:_question];
    searchBar.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
    [navBar addSubview:searchBar];
    self.searchBar = searchBar;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;

}
/**
 *  增加热门搜索的label
 */
- (void)addTitleLabelWithFrame:(CGRect)labelFrame{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"热门搜索";
    label.textColor = YYGrayText140Color;
    label.font = [UIFont systemFontOfSize:14.0];
    
    [self.view addSubview:label];
}
/**
 *  //增加热门搜索内容的CollectionView
 */
- (void)addCollectionViewWithFrame:(CGRect)collectionViewFrame{
    
    CGFloat Xmargin = 38 / 375.0 *YYWidthScreen;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (YYWidthScreen - YY18WidthMargin * 2 - Xmargin)/2.0;
    layout.itemSize = CGSizeMake(itemW, _itemH);
    layout.sectionInset = UIEdgeInsetsMake(0, YY18WidthMargin, 0, YY18WidthMargin);
    layout.minimumLineSpacing = _yMargin;
    layout.minimumInteritemSpacing = Xmargin;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    collectionView.scrollEnabled = NO;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionView];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_ID];
    
   self.collectionView = collectionView;
}
#pragma mark collection 数据源方法
/**
 *  collection 数据源方法
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_itemsArray.count < 6) {
        return _itemsArray.count;
    }
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_ID forIndexPath:indexPath];
    
    NSString *searchName = _itemsArray[indexPath.item];
    //设置单元格
    [self setCell:cell andSearchName:searchName];
    
    return cell;
}
- (void)setCell:(UICollectionViewCell *)cell andSearchName:(NSString *)searchName{
    UIButton *btn = [[UIButton alloc] initWithFrame:cell.bounds];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_searchtermsBG"] forState:UIControlStateNormal];
    [btn setTitle:searchName forState:UIControlStateNormal];
    [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    
    UIFont *oldFont = [UIFont systemFontOfSize:16.0];
    
    btn.titleLabel.font = oldFont;
    
    cell.backgroundView = btn;
}
#pragma mark collection 代理方法
/**
 *  collection 代理方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = _itemsArray[indexPath.item];
    [self searchCourseWithKeyWord:str];
}
- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    YYLog(@"开始搜索");
    NSString *searchKeyWord = self.searchBar.text;
    YYLog(@"%@",searchKeyWord);
    if (searchKeyWord.length == 0) {
        [MBProgressHUD showError:@"请输入搜索关键字"];
    }
    [self searchCourseWithKeyWord:searchKeyWord];
    
    return YES;
}
/**
 *  正在搜索课程
 */
- (void)searchCourseWithKeyWord:(NSString *)keyword{
    [MBProgressHUD showMessage:@"正在搜索"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"3";
    parameters[@"module"] = @"course";
    parameters[@"keyword"] = keyword;
    parameters[@"index"] = @"0";
    parameters[@"page"] = @"0";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            YYLog(@"错误信息：%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            [MBProgressHUD showError:@"搜索不到与该关键字相关的课程"];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"ok"]){
            NSArray *ret = responseObject[@"ret"];
            YYLog(@"%@",ret);
            NSMutableArray *array = [self analysisArrayWithGetArray:ret];
            YYCourseListController *list = [[YYCourseListController alloc] initWithSearchListWithArray:array];
            [self.navigationController pushViewController:list animated:YES];
        }
        else{
            [MBProgressHUD showError:@"搜索失败"];
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

@end
