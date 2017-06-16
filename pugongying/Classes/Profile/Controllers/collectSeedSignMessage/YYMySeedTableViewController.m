//
//  YYMySeedTableViewController.m
//  pugongying
//
//  Created by wyy on 16/4/19.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMySeedTableViewController.h"

#import "YYMySeedCell.h"
#import "YYMySeedCellFrame.h"
#import "YYMySeedCellModel.h"

@interface YYMySeedTableViewController (){
    CGFloat _scale;
    CGFloat _headerViewMySeedHeight;
    CGFloat _headerViewHeight;
    CGFloat _headerViewBottomHeight;
    int _page;
    
    /**
     * 种子消息数组
     */
    NSMutableArray *_seedArray;
    
    MJRefreshGifHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
}
/**
 *  种子数量的label
 */
@property (nonatomic, weak) UILabel *seedNumberLabel;
/**
 *  几几年的按钮
 */
@property (nonatomic, weak) UIButton *yearBtn;
/**
 *  几月的按钮
 */
@property (nonatomic, weak) UIButton *monthBtn;
/**
 *  收入的颗数
 */
@property (nonatomic, weak) UILabel *incomeLabel;
/**
 *  支出的颗数
 */
@property (nonatomic, weak) UILabel *payLabel;
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

@implementation YYMySeedTableViewController

- (void)getSeedsFromInterWithPage:(int)page{
//    mode=17&userid=1&page=0&index=0
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"17";
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
                [_seedArray removeAllObjects];
            }
            
            NSArray *retArray = responseObject[@"ret"];
            
            //已经没有新的数据
            if (retArray.count < 10) {
                [_footer endRefreshingWithNoMoreData];
            }
            if (retArray.count == 0) [_footer setHidden:YES];
            else [_footer setHidden:NO];
            
            for (NSDictionary *dic in retArray) {
                YYMySeedCellModel *model = [[YYMySeedCellModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                
                YYMySeedCellFrame *modelFrame = [[YYMySeedCellFrame alloc] init];
                modelFrame.model = model;
                [_seedArray addObject:modelFrame];
            }
            [self.tableView reloadData];
            
            /**
             *  关于seed信息的数据
             */
            NSDictionary *seedDic = responseObject[@"ret_seed"];
            [self setSeedWithSeedDic:seedDic];
        }
    }];
}
/**
 *  设置关于seed的信息
 */
- (void)setSeedWithSeedDic:(NSDictionary *)seedDic{
    
    //设置总颗数
    NSString *seedNum = [NSString stringWithFormat:@"%@ 颗",seedDic[@"seed"]];
    
    NSRange range = [seedNum rangeOfString:@"颗"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString: seedNum];
    
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:range];
    
    self.seedNumberLabel.text = seedNum;
    self.seedNumberLabel.attributedText = attribute;

    /**
     *  收入的颗数
     */
    self.incomeLabel.text = seedDic[@"sum1"];
    /**
     *  支出的颗数
     */
    self.payLabel.text = seedDic[@"sum2"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installData];
    
    //设置导航栏
    [self setNavBar];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置headerView
    [self setTableViewHeaderView];
    
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
        
        [self getSeedsFromInterWithPage:_page];
        
        //设置下拉刷新
        [self setMJRefresh];
        [self footerRefresh];
    }
}
/**
 *  设置导航栏
 */
- (void)setNavBar{
    self.title = @"我的种子";
    
//    UIImage *image = [UIImage imageNamed:@"profile_myseed_message"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(mySeedMessageBtnClick)];
}
/**
 *  我的种子具体信息被点击
 */
- (void)mySeedMessageBtnClick{
    YYLog(@"我的种子具体信息被点击");
}
/**
 *  初始化变量
 */
- (void)installData{
    _scale = YYHeightScreen / 667.0;
    _headerViewMySeedHeight = 140 * _scale;
    
    _headerViewBottomHeight = 65 * _scale;
    
    _headerViewHeight = _headerViewMySeedHeight + YY12HeightMargin + _headerViewBottomHeight;
    
    _seedArray = [NSMutableArray array];
    _page = 1;
    

}

#pragma mark 设置headerView
/**
 *  设置headerView
 */
- (void)setTableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, _headerViewHeight)];
    headerView.backgroundColor = YYGrayBGColor;
    self.tableView.tableHeaderView = headerView;
    
    //增加上面的种子图片和种子数量的Label
    UIView *topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, _headerViewMySeedHeight)];
    topHeaderView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:topHeaderView];
    
    [self addSeedImageAndSeedNumberWithTopHeaderView:topHeaderView];
    
    //增加下面部分的View
    CGFloat bottomHeaderViewY = _headerViewMySeedHeight + YY12HeightMargin;
    UIView *bottomHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomHeaderViewY, YYWidthScreen, _headerViewBottomHeight)];
    bottomHeaderView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bottomHeaderView];
    
    [self addBottomHeaderViewWithBottomView:bottomHeaderView];
}
/**
 *  增加上面的种子图片和种子数量的Label
 */
-(void)addSeedImageAndSeedNumberWithTopHeaderView:(UIView *)topHeaderView{
        CGFloat seedW = 88 * _scale;
    CGFloat seedH = 61 * _scale;
    CGFloat seedX = (YYWidthScreen - seedW)/2.0;
    
    CGFloat labelH = 28;
    CGFloat yMargin = (_headerViewMySeedHeight - labelH - seedH)/5;
    
    UIImageView *seedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(seedX, 2 * yMargin, seedW, seedH)];
    [topHeaderView addSubview:seedImageView];
    seedImageView.image = [UIImage imageNamed:@"profile_seed_big"];
    
    UILabel *seedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3 * yMargin + seedH, YYWidthScreen, labelH)];
    [topHeaderView addSubview:seedLabel];
    self.seedNumberLabel = seedLabel;
    self.seedNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.seedNumberLabel.font = [UIFont systemFontOfSize:22.0];
    //    self.seedNumberLabel.textColor = [UIColor colorWithRed:166/255.0 green:179/255.0 blue:74/255.0 alpha:1.0];
    self.seedNumberLabel.textColor = [UIColor blackColor];
    
    NSString *string = @"100 颗";
    
    NSRange range = [string rangeOfString:@"颗"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString: string];
    //    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    //    attr[NSForegroundColorAttributeName]
    //    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:range];
    
    self.seedNumberLabel.text = string;
    self.seedNumberLabel.attributedText = attribute;
}

/**
 *  增加下面部分的View
 */
- (void)addBottomHeaderViewWithBottomView:(UIView *)bottomView{
    CGFloat label1H = 14;
    CGFloat label2H = 16;
    CGFloat yMargin = (_headerViewBottomHeight - label1H - label2H)/3.0;
    
    //后面两部分的宽度是前面的2.75倍
    CGFloat firstViewW = YYWidthScreen / 3.75;
    //增加年月两个按钮
    [self addYearMonthBtnsWithSuperView:bottomView andFirstViewW:firstViewW];
    
    //增加收入部分两个label
    CGFloat labelW = 2.75/2*firstViewW;
    self.incomeLabel = [self addLabelWithTopLabelFrame:CGRectMake(firstViewW, yMargin, labelW, label1H) andSuperView:bottomView andTitle:@"收入 (颗)"];
    
    //增加支出部分两个label
    self.payLabel = [self addLabelWithTopLabelFrame:CGRectMake(firstViewW + labelW, yMargin, labelW, label1H) andSuperView:bottomView andTitle:@"支出 (颗)"];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, _headerViewBottomHeight - 0.5, YYWidthScreen, 0.5) andView:bottomView];
}
/**
 *  增加收入或者支出部分
 */
- (UILabel *)addLabelWithTopLabelFrame:(CGRect)labelFrame andSuperView:(UIView *)bottomView andTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    CGFloat label1H = 14;
    CGFloat label2H = 16;
    CGFloat yMargin = (_headerViewBottomHeight - label1H - label2H)/3.0;
    
    label.text = title;
    label.font = [UIFont systemFontOfSize:15.0];
    [bottomView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    
    //增加数量label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelFrame.origin.x, yMargin * 2 + label1H, labelFrame.size.width, label2H)];
    [bottomView addSubview:numberLabel];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    return numberLabel;
}
/**
 *  增加年月两个按钮
 */
- (void)addYearMonthBtnsWithSuperView:(UIView *)bottomView andFirstViewW:(CGFloat)firstViewW{
    
    CGFloat label1H = 14;
    CGFloat label2H = 16;
    CGFloat yMargin = (_headerViewBottomHeight - label1H - label2H)/3.0;

    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    UIButton *yearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yMargin, firstViewW, label1H)];
    NSString *year = [NSString stringWithFormat:@"%@年",[currentTime substringToIndex:4]];
    [yearBtn setTitle:year forState:UIControlStateNormal];
    [yearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yearBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [bottomView addSubview:yearBtn];
    self.yearBtn = yearBtn;
    
    NSString *month = [NSString stringWithFormat:@"%@月",[currentTime substringWithRange:NSMakeRange(4, 2)]];
    UIButton *monthBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yMargin * 2 + label1H, firstViewW, label2H)];
    [monthBtn setTitle:month forState:UIControlStateNormal];
    [monthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [bottomView addSubview:monthBtn];
    self.monthBtn = monthBtn;
    
    //增加右侧的线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(firstViewW - 0.5, yMargin, 0.5, _headerViewBottomHeight - 2 * yMargin) andView:bottomView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view数据库
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _seedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMySeedCell *cell = [YYMySeedCell MySeedCellWithTableView:tableView];
    
    YYMySeedCellFrame *modelFrame = _seedArray[indexPath.row];
    cell.modelFrame = modelFrame;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMySeedCellFrame *modelFrame = _seedArray[indexPath.row];
    
    return modelFrame.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
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
    
    
    [self getSeedsFromInterWithPage:_page];
    
}
#pragma mark 设置刷新控件
- (void)setMJRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getSeedsFromInterWithPage:_page];
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
        [self getSeedsFromInterWithPage:_page];
    }];
    
    if (_seedArray.count == 0) [_footer setHidden:YES];
    else [_footer setHidden:NO];
    
    [_footer setTitle:@"没有更多消息" forState:MJRefreshStateNoMoreData];
    // 设置尾部
    self.tableView.mj_footer = _footer;
}

@end
