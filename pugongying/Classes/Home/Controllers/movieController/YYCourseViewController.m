//
//  YYCourseViewController.m
//  pugongying
//
//  Created by wyy on 16/2/25.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseViewController.h"
#import "YYCourseCollectionCellModel.h"

//课程目录控制器
#import "YYCatalogueViewController.h"
#import "YYDetailCourseViewController.h"
#import "YYCommentCourseController.h"

#import "YYCourseCellModel.h"

//提交问题的控制器
#import "YYMoviePostCommentController.h"

#import "YYLoginRegisterViewController.h"
/**
 *  ZFPlayer需要的头文件
 */
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "masonry.h"
#import "ZFPlayer.h"
#import "YYNavigationController.h"

#import "YYHomeDataBaseManager.h"

#define YYAddCourseCommentSuccess @"YYAddCourseCommentSuccess"
#define YYCourseSuccessComment @"YYCourseSuccessComment"

@interface YYCourseViewController ()<UIScrollViewDelegate, YYCatalogueViewControllerDelegate, YYCommentCourseControllerDelegate>{
    int _page;
    
    MJRefreshGifHeader *_headerRefreshComment;
    MJRefreshAutoNormalFooter *_footerComment;
    /**
     *  课程历史列表
     */
    NSString *_coursesHistoryTable;
    /**
     *  目录控制器
     */
    YYCatalogueViewController *_catalogueController;
    /**
     *  详情控制器
     */
    YYDetailCourseViewController *_detailController;
    /**
     *  评论控制器
     */
    YYCommentCourseController *_commentController;
    /**
     *  课件表
     */
    NSString *_catalogueTable;
}

/**
 *  课程信息
 */
@property (nonatomic, strong) YYCourseCollectionCellModel *model;
/**
 *  三个按钮
 */
@property (nonatomic, weak) UIButton *firstBtn;
@property (nonatomic, weak) UIButton *secondBtn;
@property (nonatomic, weak) UIButton *threeBtn;

/**
 *  按钮下方滚动的线条
 */
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic,weak) UILabel *courseLabel;
@property (nonatomic,weak) UIView *peoplesView;
/**
 *  scroller View
 */
@property (nonatomic, weak) UIScrollView *scrollerView;
/**
 *  报名按钮
 */
@property (nonatomic, weak) UIButton *applyBtn;
/**
 *  下面部分的View
 */
@property (nonatomic, weak) UIView *bottomView;

@property (weak, nonatomic) ZFPlayerView *playerView;

@end

@implementation YYCourseViewController

#pragma mark 查询是否收藏该课程
- (void)selectCollectThisCourse{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"261";
    parameters[@"courseid"] = self.model.courseID;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    if (!userID) {//没有登录的用户
        [self.applyBtn setImage:[UIImage imageNamed:@"home_movie_6"] forState:UIControlStateNormal];
        return;
    }
    parameters[@"userid"] = userID;
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        YYLog(@"%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"已收藏该课程");
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database addCourseID:self.model.courseID andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
            self.applyBtn.enabled = NO;
        }
        else if ([responseObject[@"msg"] isEqualToString:@"error"]){
            self.applyBtn.enabled = YES;
            
            YYLog(@"未收藏该课程");
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database removeCollectWithCourseID:self.model.courseID andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
        }
    }];
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 34, YYWidthScreen/3.0, 1)];
        _bottomLine.backgroundColor = YYBlueTextColor;
    }
    return _bottomLine;
}
#pragma mark 把该课程加入到历史纪录
/**
 *  把该课程加入到历史纪录
 */
- (void)addCourseToDataBaseWithModel:(YYCourseCollectionCellModel *)model{
    YYHomeDataBaseManager *manager = [YYHomeDataBaseManager shareHomeDataBaseManager];
    
    double date = [[NSDate date] timeIntervalSince1970];
    long long nowDate = [[NSNumber numberWithDouble:date] longLongValue];
    model.couseSeeTime = [NSString stringWithFormat:@"%lld",nowDate];
    [manager addCourses:@[model] toCourseTable:_coursesHistoryTable];
    
}
- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)model{
    if (self = [super init]) {
        
        _page = 1;
        _coursesHistoryTable = @"coursesHistoryTable";
        _catalogueTable = @"t_catalogueTable";
        self.title = @"课程";
        
        self.model = model;
        self.view.backgroundColor = [UIColor whiteColor];
        //把该课程加入到历史纪录
        [self addCourseToDataBaseWithModel:model];

        //增加上面部分显示课程信息的View
        [self addTopCourseMessageViewWithFrame:CGRectMake(0, 64, YYWidthScreen, 145/667.0*YYHeightScreen)];
        
        //增加下面部分的View
        CGFloat viewY = 64 + 145/667.0 *YYHeightScreen;
        CGFloat viewH = YYHeightScreen - viewY;
        [self addbottomCourseViewWithFrame:CGRectMake(0, viewY, YYWidthScreen, viewH)];
        
     }
    return self;
}
#pragma mark 增加上面部分显示课程信息的View
/**
 *  增加上面部分显示课程信息的View
 */
- (void)addTopCourseMessageViewWithFrame:(CGRect)topViewFrame{
    
     UIView *topView = [[UIView alloc] init];
     topView.backgroundColor = [UIColor blackColor];
     [self.view addSubview:topView];
     [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
         make.height.mas_offset(20);
     }];
     
    ZFPlayerView *playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:playerView];
    self.playerView = playerView;
    __weak __typeof(&*self)weakSelf = self;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(20);
        make.left.right.equalTo(weakSelf.view);
         // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.mas_equalTo(topViewFrame.size.height + 44);
    }];
  
    /**
     *  从数据库拿出目录中第一个数据
     */
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    NSArray *catalogueArray = [database courseCatalogueListWithCourseID:self.model.courseID andCatalogueTable:_catalogueTable];
    if (catalogueArray.count == 0) {
        self.playerView.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1452570579119"];
    }
    else{
        YYCourseCellModel *catalogueModel = [catalogueArray firstObject];
        self.playerView.videoURL = [NSURL URLWithString:catalogueModel.courseMediaURL];
    }

    // （可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    // 打开断点下载功能（默认没有这个功能）
//    self.playerView.hasDownload = YES;
    
    // 如果想从xx秒开始播放视频
    //self.playerView.seekTime = 15;
    self.playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.bottomView.hidden = NO;
        
        CGFloat topHeight = 145/667.0 * YYWidthScreen + 44;
//        YYLog(@"%f\n%@",YYWidthScreen, [UIDevice currentDevice].systemVersion);
        if([UIDevice currentDevice].systemVersion.integerValue < 8){
            topHeight = 145/667.0 * YYHeightScreen + 44;
        }
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view).offset(20);
             make.height.mas_equalTo(topHeight);
             
         }];
         
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        YYLog(@"%f",YYWidthScreen);
        self.bottomView.hidden = YES;
        CGFloat height = [UIScreen mainScreen].bounds.size.width;
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.height.mas_equalTo(height);
        }];
        
    }
}

#pragma mark 增加下面部分的View
/**
 *   //增加下面部分的View
 */
- (void)addbottomCourseViewWithFrame:(CGRect)ViewFrame{
    UIView *view = [[UIView alloc] initWithFrame:ViewFrame];
    [self.view addSubview:view];
    self.bottomView = view;

    //        增加底部的View
    CGFloat bottomViewH = 50;
    CGFloat bottomViewY = ViewFrame.size.height - bottomViewH;
    [self addBottomViewWithFrame:CGRectMake (0, bottomViewY, YYWidthScreen, bottomViewH)andSuperView:view];
    //增加三个按钮
    CGFloat btnsViewY = 0;
    [self addThreeBtnViewWithFrame:CGRectMake(0, btnsViewY, YYWidthScreen, 35) andSuperView:view];
    
    [self threeBtnClickOneWithBtn:self.firstBtn];
    
    //增加scrollerView
    CGFloat scrollerViewY = 35;
    CGFloat scrollerViewH = ViewFrame.size.height - scrollerViewY - bottomViewH;
    [self addScrollerViewWithFrame:CGRectMake(0, scrollerViewY, YYWidthScreen, scrollerViewH) andSuperView:view];
}
#pragma mark 增加三个按钮
- (void)addThreeBtnViewWithFrame:(CGRect)btsFrame andSuperView:(UIView *)superView{
    
    UIView *btnsView = [[UIView alloc] initWithFrame:btsFrame];
    
    [superView addSubview:btnsView];
    
    CGFloat btnW = YYWidthScreen/3.0;
    CGFloat btnH = btsFrame.size.height - 1;
    CGFloat btnY = 0;
    for (int i = 0; i < 3; i++) {
        CGFloat btnX = i * btnW;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        switch (i) {
            case 0:
                [btn setTitle:@"目录" forState:UIControlStateNormal];
                self.firstBtn = btn;
                break;
            case 1:
                [btn setTitle:@"详情" forState:UIControlStateNormal];
                self.secondBtn = btn;
                break;
            case 2:
                [btn setTitle:@"评分" forState:UIControlStateNormal];
                self.threeBtn = btn;
                break;
            default:
                break;
        }
        [btn setTitleColor:YYBlueTextColor forState:UIControlStateSelected];
        [btn setTitleColor:YYBlueTextColor forState:UIControlStateHighlighted];
        [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
        [btnsView addSubview:btn];
        btn.tag = i;
        [YYPugongyingTool addLineViewWithFrame:CGRectMake(btnW - 0.5, 5, 0.5, 20) andView:btn];
        [btn addTarget:self action:@selector(threeBtnClickOneWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btnH, YYWidthScreen, 1)];
    lineView.backgroundColor = YYGrayLineColor;
    [btnsView addSubview:lineView];
    [btnsView addSubview:self.bottomLine];

}
#pragma mark 三个按钮其中一个被点击
- (void)threeBtnClickOneWithBtn:(UIButton *)btn{
    self.firstBtn.selected = NO;
    self.secondBtn.selected = NO;
    self.threeBtn.selected = NO;
    btn.selected = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomLine.x = btn.tag * YYWidthScreen/3.0;
        self.scrollerView.contentOffset = CGPointMake(btn.tag * YYWidthScreen, 0);
    }];
}

#pragma mark 增加scroller View
/**
 *  增加scroller View
 */
- (void)addScrollerViewWithFrame:(CGRect)scrollerFrame andSuperView:(UIView *)superView{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:scrollerFrame];
    [superView addSubview:scrollerView];
    self.scrollerView = scrollerView;
    scrollerView.contentSize = CGSizeMake(3*YYWidthScreen, scrollerFrame.size.height);
    scrollerView.delegate = self;
    scrollerView.showsHorizontalScrollIndicator = NO;
    
    scrollerView.pagingEnabled = YES;
    //增加scroller View中的三个页面
    [self addScrollerViewThreeViews];
    
}
#pragma mark 增加scroller View中的三个页面
/**
 *  增加scroller View中的三个页面
 */
- (void)addScrollerViewThreeViews{
    /**
     *  增加目录的View
     */
    CGRect catalogueTableViewFrame = CGRectMake(0, 0, YYWidthScreen, self.scrollerView.height);
    _catalogueController = [[YYCatalogueViewController alloc] initWithCourseModel:self.model andCatalogueFrame:catalogueTableViewFrame];
    UITableView *catalogueTableView = _catalogueController.catalogueTableView;
    catalogueTableView.x = 0;
    [self.scrollerView addSubview:catalogueTableView];
    _catalogueController.delegate = self;
    
    /**
     *  增加详情的View
     */
    CGRect detailTableViewFrame = CGRectMake(YYWidthScreen, 0, YYWidthScreen, self.scrollerView.height);
    _detailController = [[YYDetailCourseViewController alloc] initWithCourseModel:self.model andStyle:UITableViewStyleGrouped andFrame:detailTableViewFrame];
    UITableView *detailTableView = _detailController.detailTableView;
    [self.scrollerView addSubview:detailTableView];
    /**
     *  增加评论的控制器
     */
    CGRect commentTableViewFrame = CGRectMake(2 *YYWidthScreen, 0, YYWidthScreen, self.scrollerView.height);
    _commentController = [[YYCommentCourseController alloc] initWithCourseModel:self.model andFrame:commentTableViewFrame];
    _commentController.delegate = self;
    UIView *commentView = _commentController.commentView;
    [self.scrollerView addSubview:commentView];

}
#pragma mark 增加底部的View
- (void)addBottomViewWithFrame:(CGRect)bottomFrame andSuperView:(UIView *)superView{
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    [superView addSubview:bottomView];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:bottomView];
    CGFloat applyBtnW = 130;
    CGFloat applyBtnY = 5;
    CGFloat applyBtnX = YYWidthScreen - YY18WidthMargin- applyBtnW;
    CGFloat applyBtnH = bottomFrame.size.height - 2 * applyBtnY;
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(applyBtnX, applyBtnY, applyBtnW, applyBtnH)];
    [bottomView addSubview:applyBtn];
    self.applyBtn = applyBtn;
    [self.applyBtn setImage:[UIImage imageNamed:@"home_movie_7"] forState:UIControlStateDisabled];
    [self.applyBtn setImage:[UIImage imageNamed:@"home_movie_6"] forState:UIControlStateNormal];
    [self.applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //先查询该用户是否收藏该课程
    YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
    BOOL collect = [database selectCollectWithCourseID:self.model.courseID andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
    if (collect) {
        self.applyBtn.enabled = NO;
    }
    else{
        self.applyBtn.enabled = YES;
    }
    //再去网络查询是否收藏该课程
    [self selectCollectThisCourse];
}

#pragma mark 报名按钮被点击
- (void)applyBtnClick{

    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        //去登录页面
        [self registerLoginBtnClick];
        return;
        
    }
    [MBProgressHUD showMessage:@"正在收藏课程"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mode"] = @"12";
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"userid"] = userId;
    parameters[@"courseid"] = self.model.courseID;
    
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        YYLog(@"%@",error);
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:YYHTTPInsertPOST] cachePolicy:1 timeoutInterval:10.0];
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        if (connectionError) {
            YYLog(@"%@出错",connectionError);
            [MBProgressHUD showError:@"收藏课程失败"];
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        YYLog(@"收藏课程\n dic=%@\n response = %@\n data = %@\n error = %@",dic, response, data, error);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"成功收藏该课程"];
            self.applyBtn.enabled = NO;
            //成功收藏课程后，更新数据库，增加该条收藏记录
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database addCourseID:self.model.courseID andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
        }
        else if ([dic[@"msg"] isEqualToString:@"error_exist"]){
            [MBProgressHUD showError:@"已收藏过该课程"];
            self.applyBtn.enabled = NO;
            //成功收藏课程后，更新数据库，增加该条收藏记录
            YYHomeDataBaseManager *database = [YYHomeDataBaseManager shareHomeDataBaseManager];
            [database addCourseID:self.model.courseID andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
        }
    }];
}

#pragma mark 右上角bar button item被点击
- (void)rightBarButtonItemClick{
    YYLog(@"右上角bar button item被点击");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark scroller View的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.bottomLine.x = scrollView.contentOffset.x / 3.0;
    
    int page = scrollView.contentOffset.x/ YYWidthScreen;
    self.firstBtn.selected = NO;
    self.secondBtn.selected = NO;
    self.threeBtn.selected = NO;
    switch (page) {
        case 0:
            self.firstBtn.selected = YES;
            break;
        case 1:
            self.secondBtn.selected = YES;
            break;
        case 2:
            self.threeBtn.selected = YES;
            break;
        default:
            break;
    }
}

#pragma mark YYCatalogueControllerDelegate代理方法
- (void)playCourseWithCourseCatalogueModel:(YYCourseCellModel *)catalogueModel{

    [self.playerView cancelAutoFadeOutControlBar];
    [self.playerView removeFromSuperview];
    ZFPlayerView *playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:playerView];
    self.playerView = playerView;
    __weak __typeof(&*self)weakSelf = self;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(20);
        make.left.right.equalTo(weakSelf.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.mas_equalTo(145/667.0 * YYHeightScreen + 44);
    }];

    self.playerView.videoURL = [NSURL URLWithString:catalogueModel.courseMediaURL];
    // （可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    // 打开断点下载功能（默认没有这个功能）
    //    self.playerView.hasDownload = YES;
    
    // 如果想从xx秒开始播放视频
    //self.playerView.seekTime = 15;
    self.playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerView cancelAutoFadeOutControlBar];
}
#pragma mark 监听到课程中评论按钮被点击
/**
 *  监听到课程中评论按钮被点击
 */
- (void)commentCourseBtnClick{
    YYLog(@"监听到课程中评论按钮被点击");
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        //去登录页面
        [self registerLoginBtnClick];
        return;
    }
    
    YYMoviePostCommentController *commentController = [[YYMoviePostCommentController alloc] initWithCourseCommentControllerWithModel:self.model];
    [self.navigationController pushViewController:commentController animated:YES];
    
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
