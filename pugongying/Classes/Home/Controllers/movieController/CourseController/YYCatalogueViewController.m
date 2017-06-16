//
//  YYCatalogueViewController.m
//  pugongying
//
//  Created by wyy on 16/5/16.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCatalogueViewController.h"
#import "YYCourseCollectionCellModel.h"
//课程视频的model
#import "YYCourseCellModel.h"
#import "YYCourseTableViewCell.h"
#import "YYHomeDataBaseManager.h"


@interface YYCatalogueViewController ()<UITableViewDelegate, UITableViewDataSource, YYCourseCellModelDelegate>{
    /**
     *  该课程的所有媒体数组
     */
    NSMutableArray *_catalogueArray;
    
    YYCourseCollectionCellModel *_courseModel;
    /**
     *  课件表
     */
    NSString *_catalogueTable;
    
}

@end

@implementation YYCatalogueViewController
- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)courseModel andCatalogueFrame:(CGRect)catalogueFrame{
    if (self = [super init]) {
        _courseModel = courseModel;
        //创建用来显示的tableview
        [self createCatalogueTableViewWithFrame:catalogueFrame];
    }
    return self;
}
#pragma mark 获取该课程的所有媒体
/**
 *  获取该课程的所有媒体
 */
- (void)getThisCourseAllMovie{
    YYLog(@"从网络获取该课程的所有媒体");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mode"] = @"23";
    parameters[@"courseid"] = _courseModel.courseID;
    //    parameters[@"page"] = @"1";
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSArray *courseMessageArray = responseObject[@"ret"];
            //清空数据
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            if ([database courseCatalogueListWithCourseID:_courseModel.courseID andCatalogueTable:_catalogueTable].count == 0){
                NSDictionary *modelDic = [courseMessageArray firstObject];
                YYLog(@"数据库没有课程数据");
                YYCourseCellModel *courseModel = [[YYCourseCellModel alloc] initWithID:modelDic[@"id"] courseID:modelDic[@"courseid"] courseIndex:modelDic[@"number"] courseTitle:modelDic[@"title"] courseMediaURL:modelDic[@"mediaurl"] viewNum:modelDic[@"viewnum"]];
                [self courseTableViewCellPlayClickWithModel:courseModel];
                
            }
            [database removeAllCatalogueWithCourseID:_courseModel.courseID andCatalogueTable:_catalogueTable];
            [_catalogueArray removeAllObjects];
            
            
            //            YYLog(@"%@",courseMessageArray);
            [self analysisArrayWithArray:courseMessageArray];
            
            [database addCourseCatalogueModelsArray:[_catalogueArray copy] toTableView:_catalogueTable];
            
            [self.catalogueTableView reloadData];
        }
    }];
}
/**
 *  解析数组
 */
- (void)analysisArrayWithArray:(NSArray *)array{
    //    YYLog(@"%@",array);
    for (NSDictionary *dic in array) {
        //课件ID
        NSString *ID = dic[@"id"];
        //课程序号
        NSString *courseID = dic[@"courseid"];
        //课件序号
        NSString *courseMediaIndexStr = dic[@"number"];
        //课件标题
        NSString *courseTitle = dic[@"title"];
        // 课程视频的URL字符串
        NSString *courseMediaURLStr = dic[@"mediaurl"];
        //观看人数
        NSString *viewNum = dic[@"viewnum"];
        
        YYCourseCellModel *model = [[YYCourseCellModel alloc] initWithID:ID courseID:courseID courseIndex:courseMediaIndexStr courseTitle:courseTitle courseMediaURL:courseMediaURLStr viewNum:viewNum];
        [_catalogueArray addObject:model];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self installDatas];
    
    [self baseOnInterAndDataBaseLoadData];
}
/**
 *  初始化数据
 */
- (void)installDatas{
    _catalogueArray = [NSMutableArray array];
    
    _catalogueTable = @"t_catalogueTable";
}
/**
 *  创建用来显示的tableview
 */
- (void)createCatalogueTableViewWithFrame:(CGRect)catalogueFrame{
    UITableView *tableView = [[UITableView alloc] initWithFrame:catalogueFrame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.catalogueTableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    self.catalogueTableView.dataSource = self;
    self.catalogueTableView.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _catalogueArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseTableViewCell *cell = [YYCourseTableViewCell courseTableViewCellWithTableView:tableView];
    
    YYCourseCellModel *model = _catalogueArray[indexPath.row];
    
    cell.model = model;
    //设置单元格的代理
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HView = [[UIView alloc] init];
    HView.size = CGSizeMake(YYWidthScreen, 40);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, 0, YYWidthScreen - YY18WidthMargin * 2, 40)];
    titleLabel.textColor = YYGrayTextColor;
    [HView addSubview:titleLabel];
    HView.backgroundColor = [UIColor whiteColor];
    
    titleLabel.text = [NSString stringWithFormat:@"《%@》 共%@节",_courseModel.courseTitle, _courseModel.courseSeriesNum];
    
    return HView;

}
#pragma mark tableView的代理方法被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYLog(@"bofang");
    YYCourseCellModel *model = _catalogueArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(playCourseWithCourseCatalogueModel:)]) {
        [self.delegate playCourseWithCourseCatalogueModel:model];
    }
    YYLog(@"tableView代理方法");
}
#pragma mark YYCourseCellModelDelegate代理方法
- (void)courseTableViewCellPlayClickWithModel:(YYCourseCellModel *)model{
    
    YYLog(@"YYCourseCellModelDelegate代理方法");
    if ([self.delegate respondsToSelector:@selector(playCourseWithCourseCatalogueModel:)]) {
        [self.delegate playCourseWithCourseCatalogueModel:model];
    }
}

#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *models = [database courseCatalogueListWithCourseID:_courseModel.courseID andCatalogueTable:_catalogueTable];
    //数据库没有数据
    if (models.count == 0) {
        //加载数据
        [self getThisCourseAllMovie];
    }
    //    数据库有数据
    else {
        [self getCatalogueWithDataBase];
        //加载数据
        [self getThisCourseAllMovie];
    }
}
/**
 *  从数据库加载
 */
- (void)getCatalogueWithDataBase{
    YYLog(@"从数据库加载该课程的所有媒体");
    [_catalogueArray removeAllObjects];
    
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *catalogueArray = [database courseCatalogueListWithCourseID:_courseModel.courseID andCatalogueTable:_catalogueTable];
    
    [_catalogueArray addObjectsFromArray:catalogueArray];
    [self.catalogueTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
