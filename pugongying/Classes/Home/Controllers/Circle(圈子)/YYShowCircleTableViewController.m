//
//  YYShowCircleTableViewController.m
//  pugongying
//
//  Created by wyy on 16/5/31.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYShowCircleTableViewController.h"
#import "YYShowCircleCell.h"
#import "YYShowCircleModel.h"


@interface YYShowCircleTableViewController ()<YYShowCircleCellDelegate>{
    NSMutableArray *_showCircleArray;
}

@end

@implementation YYShowCircleTableViewController
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /**
     *  初始化数据
     */
    [self installData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark 初始化数据
/**
 *  初始化数据
 */
- (void)installData{

    _showCircleArray = [NSMutableArray array];
    YYShowCircleModel *model = [[YYShowCircleModel alloc] init];
    model.iconUrl = @"12";
    model.circleTitle = @"装修设计圈";
    model.circleIntro = @"装修设计圈装修设计圈";
    model.circleJoin = @"加入";
    model.circleHot = @"热";
    
    [_showCircleArray addObject:model];
    [_showCircleArray addObject:model];
    [_showCircleArray addObject:model];
    [_showCircleArray addObject:model];
    [_showCircleArray addObject:model];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showCircleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYShowCircleCell *cell = [YYShowCircleCell showCircleCellWithTableView:tableView];
    cell.delegate = self;
    
    cell.circlemodel = _showCircleArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.circleCellClickBlock) {
        YYShowCircleModel *circleModel = _showCircleArray[indexPath.row];
        self.circleCellClickBlock(circleModel);
    }
}
#pragma mark YYShowCircleCellDelegate代理方法
- (void)goCircleChatWithShowCircleModel:(YYShowCircleModel *)showCircleModel{
    
}
@end
