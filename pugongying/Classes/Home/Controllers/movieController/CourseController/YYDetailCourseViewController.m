//
//  YYDetailCourseViewController.m
//  pugongying
//
//  Created by wyy on 16/5/17.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYDetailCourseViewController.h"
#import "YYCourseCollectionCellModel.h"
#import "YYTeacherModel.h"
#import "YYHomeDataBaseManager.h"

#import "YYDetailCourseCell.h"
#import "YYDetailCourseCellFrame.h"

#define starH 12.5
#define starW 13.5
#define starMargin 5

@interface YYDetailCourseViewController ()<UITableViewDelegate, UITableViewDataSource>{
 
    YYDetailCourseCellFrame *_modelFrame;
}
@property (nonatomic, assign) CGFloat rowheight;
/**
 *  讲师的数据模型
 */
@property (nonatomic, strong) YYTeacherModel *teacherModel;
/**
 *  课程详情数据模型
 */
@property (nonatomic,strong) YYCourseCollectionCellModel *courseModel;

/**
 讲师的View
 */
@property (nonatomic, strong) UIView *teacherView;

/**
 讲师头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;
/**
 讲师名字
 */
@property (nonatomic,weak) UILabel *nameLabel;
/**
 讲师介绍
 */
@property (nonatomic, weak) UILabel *introduceLabel;

//课程详细
/**
 课程详细的view
 */
@property(nonatomic, strong) UIView* courseMessageView;
/**
 *  五颗星星实的imageView
 */
@property (nonatomic, weak) UIImageView *haveFiveStarImageView;
/**
 *  五颗星星空的imageView
 */
@property (nonatomic, weak) UIImageView *noFiveStarImageView;

/**
 *  课程目标
 */
@property (nonatomic, weak) UILabel *courseAimLabel;
/**
 *  学习特色
 */
@property (nonatomic, weak) UILabel *coursefFeatureLabel;
/**
 *  适合人群
 */
@property (nonatomic, weak) UILabel *courseSuitPeopleLabel;
/**
 *  课程节数
 */
@property (nonatomic, weak) UILabel *courseNumberLabel;
/**
 *  课程详情
 */
@property (nonatomic, weak)UILabel *courseIntroduceLabel;
@end

@implementation YYDetailCourseViewController
- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)courseModel andStyle:(UITableViewStyle)style andFrame:(CGRect)detailTableViewFrame{
    if (self = [super init]) {
        self.courseModel = courseModel;
        //创建详情tableView
        [self createDetailTableViewWithStyle:style andFrame:detailTableViewFrame];
       
    }
    return self;
}
/**
 *  创建详情tableView
 */
- (void)createDetailTableViewWithStyle:(UITableViewStyle)style andFrame:(CGRect)detailTableViewFrame{
    UITableView *detailTableView = [[UITableView alloc] initWithFrame:detailTableViewFrame style:UITableViewStyleGrouped];
    [self.view addSubview:detailTableView];
    self.detailTableView = detailTableView;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
}
#pragma mark 获取该课程讲师的详细信息
- (void)getThisCourseTeacherMessage{
    YYLog(@"显示网络的讲师信息");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"24";
    parameters[@"teacherid"] = _courseModel.courseTeacherID;
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *teacherDic = responseObject[@"ret"];
            NSString *teacherIDStr = teacherDic[@"id"];
            
            NSString *teacherIcon = teacherDic[@"headimgurl"];
            NSString *teacherName = teacherDic[@"name"];
            NSString *teacherintro = teacherDic[@"intro"];
            
            //创建讲师模型
            YYTeacherModel *model = [[YYTeacherModel alloc] initWithTeacherID:teacherIDStr andIconURL:teacherIcon andName:teacherName andIntroduce:teacherintro];
            self.teacherModel = model;
            
            //把讲师模型放入数据库
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database addTeacherModel:model];
            
            YYDetailCourseCellFrame *modelFrame = [[YYDetailCourseCellFrame alloc] init];
            modelFrame.teacherModel = self.teacherModel;
            modelFrame.courseModel = self.courseModel;
            _modelFrame = modelFrame;
            
            [self.detailTableView reloadData];
        }

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self installDatas];
    
    //获取讲师信息
    [self getThisCourseTeacherMessage];
    //先查询数据库是否有该讲师
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    YYTeacherModel *model = [database teacherModelWithTeacherID:_courseModel.courseTeacherID];
    if (model) {
        //显示数据库的信息
        YYLog(@"显示数据库的讲师信息");
        self.teacherModel = model;
        YYDetailCourseCellFrame *modelFrame = [[YYDetailCourseCellFrame alloc] init];
        modelFrame.teacherModel = self.teacherModel;
        modelFrame.courseModel = self.courseModel;
        _modelFrame = modelFrame;

        [self.detailTableView reloadData];
        //获取讲师信息
        [self getThisCourseTeacherMessage];
    }
    else{
        //获取讲师信息
        [self getThisCourseTeacherMessage];
    }
}
/**
 *  初始化数据
 */
- (void)installDatas{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYDetailCourseCell *cell = [YYDetailCourseCell detailCourseCellWithTableView:tableView];
    if (self.teacherModel) {
        cell.modelFrame = _modelFrame;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    YYLog(@"%f",_modelFrame.rowHeight);
    return _modelFrame.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
@end
