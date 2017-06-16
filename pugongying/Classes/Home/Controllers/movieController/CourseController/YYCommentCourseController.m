//
//  YYCommentCourseController.m
//  pugongying
//
//  Created by wyy on 16/5/17.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCommentCourseController.h"
#import "YYCourseCollectionCellModel.h"

//评论cell的类
#import "YYCourseCommentCell.h"
#import "YYCourseCommentFrame.h"
#import "YYCourseCommentModel.h"

#define YYCourseSuccessComment @"YYCourseSuccessComment"
#define YYAddCourseCommentSuccess @"YYAddCourseCommentSuccess"

@interface YYCommentCourseController ()<UITableViewDataSource, UITableViewDelegate>{
    int _page;
    YYCourseCollectionCellModel *_courseModel;
    
    MJRefreshGifHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    /**
     *  该课程的评论模型数组
     */
    NSMutableArray *_commentsArray;
}

@property (nonatomic, weak) UITableView *commentTableView;

@property (nonatomic, strong) NSArray *refreshImages;
/**
 *  第三页中的评论按钮
 */
@property (nonatomic, weak) UIButton *commentBtn;
@end

@implementation YYCommentCourseController

#pragma mark 获取该课程的评论信息
- (void)getCommentMessageWithPage:(int)page{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    mode=22&courseid=2
    parameters[@"mode"] = @"25";
    parameters[@"courseid"] = _courseModel.courseID;
    int index = (page - 1) * 10;
    parameters[@"page"] = [NSString stringWithFormat:@"%d",page];
    parameters[@"index"] = [NSString stringWithFormat:@"%d",index];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_headerRefresh endRefreshing];
        [_footerRefresh endRefreshing];

        if (error) {
            YYLog(@"错误：%@",error);
            return;
        }
//        YYLog(@"%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"error"]) {
            [_footerRefresh endRefreshingWithNoMoreData];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            
            if (page == 1) {
                [_commentsArray removeAllObjects];
            }
            
            NSArray *commentArray = responseObject[@"ret"];
            if (commentArray.count < 10) {
                [_footerRefresh setState:MJRefreshStateNoMoreData];
            }
            
            for (NSDictionary *dic in commentArray) {
                NSString *userName = dic[@"nickname"];
                NSString *commentStr = dic[@"content"];
                NSString *createTime = dic[@"create_t"];
                NSString *dateStr = [self timeWithLastTime:createTime.longLongValue];
                NSString *iconURLStr = nil;
                if (dic[@"headimgurl"] != [NSNull null]) {
                    iconURLStr = dic[@"headimgurl"];
                }
                
                NSString *score = dic[@"score"];
                
                YYCourseCommentModel *commentModel = [[YYCourseCommentModel alloc] initWithiconURL:iconURLStr userName:userName commentStr:commentStr dateStr:dateStr commentScore:score];
                YYCourseCommentFrame *commentFrame = [[YYCourseCommentFrame alloc] init];
                commentFrame.model = commentModel;
                [_commentsArray addObject:commentFrame];
                if (_commentsArray.count == 0) [_footerRefresh setHidden:YES];
                else [_footerRefresh setHidden:NO];
            }
        }
        
        [self.commentTableView reloadData];
    }];
}

- (instancetype)initWithCourseModel:(YYCourseCollectionCellModel *)courseModel andFrame:(CGRect)ViewFrame{
    if (self = [super init]) {
        
        _courseModel = courseModel;
        //创建显示的View
        [self createCommentViewWithFrame:ViewFrame];
        
    }
    return self;
}
/**
 *  创建显示的View
 */
- (void)createCommentViewWithFrame:(CGRect)viewFrame{
    UIView *commentView = [[UIView alloc] initWithFrame:viewFrame];
    [self.view addSubview:commentView];
    self.commentView = commentView;
    
    CGFloat commentViewH = viewFrame.size.height;
    //增加一个tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, commentViewH) style:UITableViewStyleGrouped];
    [self.commentView addSubview:tableView];
    self.commentTableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setHeader];
    [self setFooter];
    
    //增加一个评论按钮
    CGFloat btnH = 50;
    CGFloat btnW = 50;
    CGFloat btnX = YYWidthScreen - btnW - YY18WidthMargin;
    CGFloat btnY = commentViewH - YY12HeightMargin - btnH;
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [self.commentView addSubview:commentBtn];
    self.commentBtn = commentBtn;
    
    [self.commentBtn setImage:[UIImage imageNamed:@"home_movie_comment"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"home_movie_comment_finish"] forState:UIControlStateDisabled];
    [self.commentBtn addTarget:self action:@selector(commentBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    /**
     *  设置评论按钮能否被点击
     */
    [self setCommentBtnState];
    
}
/**
 *  设置评论按钮能否被点击
 */
- (void)setCommentBtnState{
    //判断用户是否存在
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    if (!userID) {
        
        self.commentBtn.enabled = YES;
    }
    else{//查询是否评论过
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"mode"] = @"251";
        
        parameters[@"userid"] = userID;
        parameters[@"courseid"] = _courseModel.courseID;
        
        [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
            
        } completionHandler:^(id responseObject, NSError *error) {
            if (error) {
                YYLog(@"错误：%@",error);
                self.commentBtn.enabled = YES;
                return;
            }
            if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
                self.commentBtn.enabled = NO;
            }
            else{
                self.commentBtn.enabled = YES;
            }

        }];
    }
}
/**
 *  课程中评论按钮被点击
 */
- (void)commentBtnClickWithBtn:(UIButton *)btn{
    YYLog(@"课程中评论按钮被点击");
    if ([self.delegate respondsToSelector:@selector(commentCourseBtnClick)]) {
        [self.delegate commentCourseBtnClick];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installDatas];
    
    //监听成功增加课程
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCourseComment:) name:YYAddCourseCommentSuccess object:nil];
    
    [self getCommentMessageWithPage:_page];

}
/**
 *  初始化数据
 */
- (void)installDatas{
    
    _page = 1;
    _commentsArray = [NSMutableArray array];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 评论tableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseCommentCell *cell = [YYCourseCommentCell courseCellWithTableView:tableView];
    
    YYCourseCommentFrame *modelFrame = _commentsArray[indexPath.row];
    
    cell.modelFrame = modelFrame;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark 评论tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCourseCommentFrame *modelFrame = _commentsArray[indexPath.row];
    
    return modelFrame.cellHeight;
}

/**
 *  评论增加成功
 */
- (void)addCourseComment:(NSNotification *)noti{
    YYLog(@"%@",noti.userInfo);
    YYCourseCommentModel *model = noti.userInfo[YYCourseSuccessComment];
    YYCourseCommentFrame *frameModel = [[YYCourseCommentFrame alloc] init];
    frameModel.model = model;
    //    [self.commentsArray insertx]
    [_commentsArray insertObject:frameModel atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.commentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.commentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.commentBtn.enabled = NO;
    
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
- (void)setHeader{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getCommentMessageWithPage:_page];
    }];
    _headerRefresh = header;
    // 设置普通状态的动画图片
    [header setImages:self.refreshImages forState:MJRefreshStateIdle];
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    
    // 设置header
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.commentTableView.mj_header = header;
    
}
- (void)setFooter{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getCommentMessageWithPage:_page];
        YYLog(@"上拉刷新%d",_page);
    }];
    
    _footerRefresh = footer;
    if (_commentsArray.count == 0) [_footerRefresh setHidden:YES];
    else [_footerRefresh setHidden:NO];
    
    [_footerRefresh setTitle:@"评论已加载完毕" forState:MJRefreshStateNoMoreData];
    self.commentTableView.mj_footer = footer;
}
#pragma mark 计算时间
/**
 *  计算时间
 */
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
