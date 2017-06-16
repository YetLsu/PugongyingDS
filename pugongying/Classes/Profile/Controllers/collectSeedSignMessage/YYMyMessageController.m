//
//  YYMyMessageController.m
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMyMessageController.h"
#import "YYMyMessageCell.h"
#import "YYMyMessageFrame.h"
#import "YYMyMessageModel.h"

@interface YYMyMessageController (){
    NSMutableArray *_messagesArray;
    int _page;
    
    MJRefreshGifHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
}
/**
 *  没网时的View
 */
@property (nonatomic, strong) UIButton *noNetBtnView;
/**
 *  加载数据时的View
 */
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) NSArray *refreshImages;

@end

@implementation YYMyMessageController
#pragma mark 获得消息列表
/**
 *  获得消息列表
 */
- (void)getMyMessagesFromInterWithPage:(int)page{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"18";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameters[@"index"] = [NSString stringWithFormat:@"%d",(page - 1) * 10];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_header endRefreshing];
        [_footer endRefreshing];
        if (error) {
            YYLog(@"有错误%@", error);
            [self.loadingView removeFromSuperview];
            [self.view addSubview:self.noNetBtnView];
            self.noNetBtnView.x = 0;
            self.noNetBtnView.y = -64;
            self.tableView.scrollEnabled = NO;

            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            [_footer endRefreshingWithNoMoreData];
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.loadingView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            
            if (page == 1) {
                [_messagesArray removeAllObjects];
            }
            
            NSArray *retArray = responseObject[@"ret"];
            
            //已经没有新的数据
            if (retArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            if (retArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            
            for (NSDictionary *dic in retArray) {
                YYMyMessageModel *model = [[YYMyMessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                
                YYMyMessageFrame *modelFrame = [[YYMyMessageFrame alloc] init];
                modelFrame.model = model;
                [_messagesArray addObject:modelFrame];
            }
            [self.tableView reloadData];
        }
    }];
}
- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    _page = 1;
    _messagesArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self basedOnNetSetView];
    
}
/**
 *  根据网络状态设置界面
 */
- (void)basedOnNetSetView{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == 0) {
        [self.view addSubview:self.noNetBtnView];
        self.noNetBtnView.x = 0;
        self.noNetBtnView.y = -64;
        self.tableView.scrollEnabled = NO;
        
        //        YYLog(@"没有网络连接");
    }
    else{
        //        YYLog(@"有网络连接");
        self.loadingView.x = 0;
        self.loadingView.y = -64;
        [self.view addSubview:self.loadingView];
        self.tableView.scrollEnabled = NO;
        
        [self getMyMessagesFromInterWithPage:_page];
        
        //设置下拉刷新
        [self setMJRefresh];
        [self footerRefresh];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYMyMessageCell *cell = [YYMyMessageCell myMessageCellWithTableView:tableView];
    
    YYMyMessageFrame *modelFrame = _messagesArray[indexPath.row];
    
    cell.modelFrame = modelFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMyMessageFrame *modelFrame = _messagesArray[indexPath.row];
    
    return modelFrame.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
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
#pragma mark 加载数据时的View
- (UIView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat width = 30;
        CGFloat height = width;
        CGFloat activityX = (YYWidthScreen - width)/2.0;
        CGFloat activityY = (YYHeightScreen - height)/2.0;
        activityView.frame = CGRectMake(activityX, activityY, width, height);
        activityView.hidesWhenStopped = YES;
        
        [_loadingView addSubview:activityView];
        self.activityView = activityView;
        
        [activityView startAnimating];
    }
    return _loadingView;
}
#pragma mark 没网时的View
- (UIButton *)noNetBtnView{
    if (!_noNetBtnView) {
        _noNetBtnView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _noNetBtnView.backgroundColor = [UIColor whiteColor];
        
        CGFloat imageW = 109.5;
        CGFloat imageH = 110.5;
        CGFloat imageX = (YYWidthScreen - imageW)/2.0;
        CGFloat imageY = (YYHeightScreen - imageH)/2.0;
        UIImageView *noNetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        noNetImageView.image = [UIImage imageNamed:@"noNet"];
        [_noNetBtnView addSubview:noNetImageView];
        //增加文字label
        CGFloat labelX = 0;
        CGFloat labelY = imageY + imageH + 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, YYWidthScreen, 20)];
        label.text = @"点击屏幕，重新加载";
        label.textColor = YYGrayLineColor;
        [_noNetBtnView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        [_noNetBtnView addTarget:self action:@selector(noNetWorkClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noNetBtnView;
}
#pragma mark 断网的时候界面被点击
- (void)noNetWorkClick{
    YYLog(@"断网的时候界面被点击");
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:YYNetworkState] == 0) {
        [MBProgressHUD showError:@"网络错误，请连接网络"];
        return;
    }
    [self.noNetBtnView removeFromSuperview];
    self.loadingView.x = 0;
    self.loadingView.y = -64;
    [self.view addSubview:self.loadingView];
    
    
    [self getMyMessagesFromInterWithPage:_page];
    
}
#pragma mark 设置刷新控件
- (void)setMJRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getMyMessagesFromInterWithPage:_page];
    }];
    _header = header;
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
- (void)footerRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        YYLog(@"上拉刷新");
        _page++;
        [self getMyMessagesFromInterWithPage:_page];
    }];
    
    if (_messagesArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"没有更多消息" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = _footer;
}

@end
