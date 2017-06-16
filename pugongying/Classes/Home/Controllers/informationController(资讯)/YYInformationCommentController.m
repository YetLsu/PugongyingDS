//
//  YYInformationCommentController.m
//  pugongying
//
//  Created by wyy on 16/3/4.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYInformationCommentController.h"
#import "YYWriteCommentViewController.h"
#import "YYNewsCommentModel.h"
#import "YYNewsCommentFrame.h"
#import "YYNewsCommentCell.h"
#import "YYInformationModel.h"
#import "YYLoginRegisterViewController.h"

#import "YYNavigationController.h"

#define YYAddNewsSuccess @"YYAddNewsSuccess"

@interface YYInformationCommentController (){
    MJRefreshAutoNormalFooter *_footer;
    int _page;
    MJRefreshGifHeader *_header;

}

@property (nonatomic, strong) NSArray *refreshImages;

/**
 *  评论数组
 */
@property (nonatomic, strong) NSMutableArray *commentsArray;
/**
 *资讯模型
 */
@property (nonatomic, strong) YYInformationModel *model;
@end

@implementation YYInformationCommentController

- (void)getCommentsArrayWithPage:(int)page{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"32";
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    int index = (page-1)*10;
//    YYLog(@"%dpage",page);
//    YYLog(@"%dindex",index);
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];
    parameters[@"newsid"] = self.model.newsID;
//    YYLog(@"%@",self.model.informationID);
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_footer endRefreshing];
        [_header endRefreshing];
        if (error) {
            YYLog(@"有错误:%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            [_footer endRefreshingWithNoMoreData];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            
            if (page == 1) {//如果是上拉刷新或者第一次刷新的话
                //清空数组
                [_commentsArray removeAllObjects];
            }
            
            NSArray *retArray = responseObject[@"ret"];
            
            if (retArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            
            //已经没有新的数据
            if (retArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            
            //            YYLog(@"%@",retArray);
            for (NSDictionary *dic in retArray) {
                //                头像的URL字符串
                
                NSString *imageUrl = nil;
                if (dic[@"headimgurl"] != [NSNull null]) {
                    imageUrl = dic[@"headimgurl"];
                }
                //                //                名字
                NSString *nickName = dic[@"nickname"];
                //                //                标题
                //                NSString *title = dic[@"title"];
                //                //                内容
                NSString *content = dic[@"content"];
                //                //                评论ID
                //                NSString *IDStr = dic[@"id"];
                //                NSInteger ID = IDStr.integerValue;
                //时间
                NSString *dateStr = dic[@"create_t"];
                long long dateL = dateStr.longLongValue;
                NSString *date = [self timeWithLastTime:dateL];
                
                YYNewsCommentModel *model = [[YYNewsCommentModel alloc] initWithiconURL:imageUrl userName:nickName commentStr:content dateStr:date];
                YYNewsCommentFrame *modelFrame = [[YYNewsCommentFrame alloc] init];
                modelFrame.model = model;
                [self.commentsArray addObject:modelFrame];
            }
            [self.tableView reloadData];
        }
        else{
            //            [MBProgressHUD showError:@"网络请求失败"];
        } 
    }];
    
}

- (NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}
- (instancetype)initWithStyle:(UITableViewStyle)style andModel:(YYInformationModel *)model{
    if (self = [super initWithStyle:style]) {
        _page = 1;
        self.model = model;
        
        [self setMJRefreshHeader];
        [self footerRefresh];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCommentsArrayWithPage:_page];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"评论";
    
    UIImage *rightImage = [UIImage imageNamed:@"home_information_7"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeBtnClick)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentNotification) name:YYAddNewsSuccess object:nil];
}
/**
 *  成功增加评论
 */
- (void)addCommentNotification{
    [self getCommentsArrayWithPage:1];
}
/**
 *  评论按钮被点击
 */
- (void)writeBtnClick{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        [self registerLoginBtnClick];
        return;
    }
    YYWriteCommentViewController *commentController = [[YYWriteCommentViewController alloc] initWithInformationCommentControllerWithModel:self.model];
    [self.navigationController pushViewController:commentController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYNewsCommentCell *cell = [YYNewsCommentCell newsCommentCellWithTableView:tableView];
    
    YYNewsCommentFrame *modelFrame = self.commentsArray[indexPath.row];
    
    cell.modelFrame = modelFrame;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYNewsCommentFrame *modelFrame = self.commentsArray[indexPath.row];
    
    return modelFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
            
#pragma mark 计算时间
- (NSString *)timeWithLastTime:(long long)lastTime{
    NSString *returnTime;
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    long long nowTimeL = [[NSNumber numberWithDouble:nowTime] longLongValue];
    
    long long detalTime = nowTimeL - lastTime;
    
    if (detalTime < 60) {
        returnTime = [NSString stringWithFormat:@"%lld秒前",detalTime];
    }
    else if (detalTime<3600 & detalTime >=60){
        returnTime = [NSString stringWithFormat:@"%lld分钟前",detalTime/60];
    }
    else if (detalTime >= 3600 & detalTime <86400){
        returnTime = [NSString stringWithFormat:@"%lld小时前",detalTime/60/60];
    }
    else if (detalTime>=86400){
        returnTime = [NSString stringWithFormat:@"%lld天前",detalTime/3600/24];
    }
    return returnTime;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [self getCommentsArrayWithPage:_page];
        
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
        [self getCommentsArrayWithPage:_page];
    }];
    
    if (self.commentsArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"没有更多新的评论" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = _footer;
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
