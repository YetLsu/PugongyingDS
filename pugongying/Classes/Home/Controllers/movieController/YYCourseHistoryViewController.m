//
//  YYCourseHistoryViewController.m
//  pugongying
//
//  Created by wyy on 16/5/5.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseHistoryViewController.h"

#import "YYCourseCollectionCellModel.h"
#import "YYCourseHistoryCell.h"

#import "YYCourseViewController.h"

#import "YYHomeDataBaseManager.h"

@interface YYCourseHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *_historyArray;
    
    /**
     *  课程历史列表
     */
    NSString *coursesHistoryTable;
    /**
     *  选中有可能删除的课程数组
     */
    NSMutableArray *_tempArray;

}
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UIView *twoBtnsView;
/**
 *  全选按钮
 */
@property (nonatomic, weak) UIButton *allSelectBtn;
/**
 *  删除按钮
 */
@property (nonatomic, weak) UIButton *removeBtn;
@end

@implementation YYCourseHistoryViewController
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
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long timeLong = (long long)time;
        NSString *timeStr = [NSString stringWithFormat:@"%lld",timeLong];
        model.couseSeeTime = timeStr;

        [array addObject:model];
    }
    
    return array;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _historyArray = [NSMutableArray array];
    coursesHistoryTable = @"coursesHistoryTable";
    _tempArray = [NSMutableArray array];
    
    //设置导航栏
    [self setNavBar];
    /**
     *  从数据库获取观看记录
     */
    [self getCourseHistoryFromDataBase];
    
    //增加TableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //增加下面的全选删除按钮
    [self addTwoBtnsView];
}
#pragma mark 设置删除记录的东西
/**
 *  设置导航栏
 */
- (void)setNavBar{
    self.title = @"观看历史";
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = rightBtn;

}
- (void)rightBtnClick{
    YYLog(@"编辑按钮被点击");
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.twoBtnsView.alpha = 1;
        }];
    }
    else{
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.twoBtnsView.alpha = 0;
        } completion:^(BOOL finished) {
            [_tempArray removeAllObjects];
            [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        }];
    }
    NSString *btnTitle = nil;
    if (_tempArray.count == 0) btnTitle = @"删除";
    else  btnTitle = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)_tempArray.count];
    [self.removeBtn setTitle:btnTitle forState:UIControlStateNormal];

}
/**
 *  增加下面的全选删除按钮
 */
- (void)addTwoBtnsView{
    CGFloat btnsViewH = 48/667.0*YYHeightScreen;
    CGFloat btnsViewY = YYHeightScreen - btnsViewH;
    UIView *twoBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, btnsViewY, YYWidthScreen, btnsViewH)];
    [self.view addSubview:twoBtnsView];
    twoBtnsView.backgroundColor = [UIColor colorWithRed:241/255.0 green:240/255.0 blue:239/255.0 alpha:1.0];
    self.twoBtnsView = twoBtnsView;
    self.twoBtnsView.alpha = 0;

    //加线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:twoBtnsView];
    
    CGFloat btnW = YYWidthScreen/2.0;
    CGFloat btnH = btnsViewH;
    CGFloat btnY = 0;
    //增加全选按钮
    UIButton *allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, btnW, btnH)];
    [twoBtnsView addSubview:allSelectBtn];
    self.allSelectBtn = allSelectBtn;
    [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //加线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(btnW - 0.5, 4, 0.5, btnH - 8) andView:allSelectBtn];
    self.allSelectBtn.tag = 0;
    [self.allSelectBtn addTarget:self action:@selector(allSelectBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //增加删除按钮
    UIButton *removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, btnY, btnW, btnH)];
    [twoBtnsView addSubview:removeBtn];
    self.removeBtn = removeBtn;
    [self.removeBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.removeBtn setTitleColor:YYBlueTextColor forState:UIControlStateNormal];
    [self.removeBtn addTarget:self action:@selector(removeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 *  全选按钮被点击
 */
- (void)allSelectBtnClickWithBtn:(UIButton *)btn{
    //点击的是全选
    if ([btn.titleLabel.text isEqualToString:@"全选"]) {
//        YYLog(@"全选按钮被点击");
        for (int i = 0; i < _historyArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
        [_tempArray removeAllObjects];
        [_tempArray addObjectsFromArray:_historyArray];
        [btn setTitle:@"取消全选" forState:UIControlStateNormal];
        
    }
    else{
//        YYLog(@"取消全选按钮被点击");
        for (int i = 0; i < _historyArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        [_tempArray removeAllObjects];
        [btn setTitle:@"全选" forState:UIControlStateNormal];
    }
    NSString *btnTitle = nil;
    if (_tempArray.count == 0) btnTitle = @"删除";
    else  btnTitle = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)_tempArray.count];
    [self.removeBtn setTitle:btnTitle forState:UIControlStateNormal];
    
    
}
/**
 *  删除按钮被点击
 */
- (void)removeBtnClick{
    YYLog(@"删除按钮被点击");
    [_historyArray removeObjectsInArray:_tempArray];
    [self.tableView reloadData];
    self.tableView.editing = NO;
    self.twoBtnsView.alpha = 0;
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    for (YYCourseCollectionCellModel *model in _tempArray) {
        [database removeCourseWithID:model.courseID andCourseTable:coursesHistoryTable];
    }
    
}
#pragma mark  从数据库获取观看记录
/**
 *  从数据库获取观看记录
 */
- (void)getCourseHistoryFromDataBase{
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
//    [database removeAllCoursesAtCourseTable:coursesHistoryTable];
    
    NSArray *array = [database coursesListFromCourseTable:coursesHistoryTable];
    
    [_historyArray addObjectsFromArray:array];
    [self.tableView reloadData];

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
    return _historyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYCourseHistoryCell *cell = [YYCourseHistoryCell courseHistoryCellWithTableView:tableView];
    
    YYCourseCollectionCellModel *model = _historyArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat scale = YYWidthScreen / 375.0;
    CGFloat courseImageViewH = 90 * scale;
    return courseImageViewH + 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        YYCourseCollectionCellModel *model = _historyArray[indexPath.row];
        [_tempArray addObject:model];
        
        NSString *btnTitle = nil;
        if (_tempArray.count == 0) btnTitle = @"删除";
        else  btnTitle = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)_tempArray.count];
        [self.removeBtn setTitle:btnTitle forState:UIControlStateNormal];
        
        return;
    }
    YYCourseCollectionCellModel *model = _historyArray[indexPath.row];
    YYCourseViewController *course = [[YYCourseViewController alloc] initWithCourseModel:model];
    [self.navigationController pushViewController:course animated:YES];
}
//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    YYCourseCollectionCellModel *model = _historyArray[indexPath.row];
    [_tempArray removeObject:model];
    
    NSString *btnTitle = nil;
    if (_tempArray.count == 0) btnTitle = @"删除";
    else  btnTitle = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)_tempArray.count];
    [self.removeBtn setTitle:btnTitle forState:UIControlStateNormal];
    
}

//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选择编辑的方式,按照选择的方式对表进行处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YYLog(@"删除按钮被点击");
        YYCourseCollectionCellModel *model = _historyArray[indexPath.row];
        [_historyArray removeObject:model];
        [self.tableView reloadData];
        
        YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
        [database removeCourseWithID:model.courseID andCourseTable:coursesHistoryTable];
    }
    
}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

@end
