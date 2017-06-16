//
//  YYYiZhenController.m
//  pugongying
//
//  Created by wyy on 16/3/28.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenController.h"

#import "YYYizhenUserModel.h"
#import "YYClinicModel.h"
#import "YYClinicDataBaseManager.h"
//义诊分类模型
#import "YYClinicCategoryModel.h"

#import "YYMyOrderTableViewController.h"
#import "YYOfflineYiZhenViewController.h"
#import "YYLoginRegisterViewController.h"

#import "YYOnLineYiZhenViewController.h"
//义诊详情
#import "YYYiZhenDetailsViewController.h"

#import "FFScrollView.h"

#import "YYNavigationController.h"

//顶部图片的高度
#define topImageViewHeight 185/667.0*YYHeightScreen
//两个按钮的View的高度
#define twoBtnViewHeight (68/667.0*YYHeightScreen)
//义诊案例Label的高度
#define titleLabelH 43
//增加三个模块的案例
#define cellH  80


@interface YYYiZhenController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_firstArray; //淘宝案例的数组
    NSMutableArray *_secondArray; //1688案例的数组
    NSMutableArray *_thirdArray; //国际站案例的数组
    
    UIButton *_firstBtn; //淘宝案例整一块的按钮
    UIButton *_secondBtn; //1688案例整一块的按钮
    UIButton *_thirdBtn; //国际站案例整一块的按钮
    MJRefreshGifHeader *_headerRefresh;
    /**
     *  义诊数据表
     */
    NSString *_clinicCaseTable;
    
}
/**
 *  scroller View
 */
@property (nonatomic, weak) UIScrollView *scrollerView;

/**
 *  义诊案例的View
 */
@property (nonatomic, weak) UIView *yizhenTablesView;
/**
 *  淘宝案例的View,tag0
 */
@property (nonatomic, weak) UIView *taobaoFirstView;
/**
 *  淘宝案例中右边的箭头
 */
@property (nonatomic, weak) UIImageView *firstArrow;
/**
 *  淘宝案例的tableView
 */
@property (nonatomic, strong) UITableView *firstTableView;
/**
 *  1688案例的View,tag1
 */
@property (nonatomic, weak) UIView *secondView;
/**
 *  1688案例中右边的箭头
 */
@property (nonatomic, weak) UIImageView *secondArrow;
/**
 *  1688案例的tableView
 */
@property (nonatomic, strong) UITableView *secondTableView;
/**
 *  国际站案例的View,tag2
 */
@property (nonatomic, weak) UIView *internationalThirdView;
/**
 *  国际站案例中右边的箭头
 */
@property (nonatomic, weak) UIImageView *thirdArrow;
/**
 *  国际站案例的tableView
 */
@property (nonatomic, strong) UITableView *thirdTableView;
/**
 *  tableView展开的个数
 */
@property (nonatomic, assign) int numberTable;
/**
 *  scroller View的滚动高度
 */
@property (nonatomic, assign) CGFloat scrollerContentHeight;

@property (nonatomic, strong) NSArray *refreshImages;
/**
 *  没网时的View
 */
@property (nonatomic, strong) UIButton *noNetBtnView;
/**
 *  加载数据时的View
 */
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@end

@implementation YYYiZhenController
//案例单元格的高度
CGFloat yizhenCellHeight = 50;

#pragma mark 获取义诊案例
- (void)refreshYizhenCases{

//    [self.activityView stopAnimating];
//    [self.loadingView removeFromSuperview];
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    parmeters[@"mode"] = @"41";
//    parmeters[@"category"] = @"全部";
//    parmeters[@"page"] = @"1";
    [NSObject GET:YYHTTPSelectGET parameters:parmeters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [_headerRefresh endRefreshing];
        if (error) {
            YYLog(@"出现错误:%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            //获取数据后清空数据库
            YYClinicDataBaseManager *dataManager = [YYClinicDataBaseManager shareClinicDataBaseManager];
            [dataManager removeAllYizhensAtClinicTable:_clinicCaseTable];
            
            [_firstArray removeAllObjects];
            [_secondArray removeAllObjects];
            [_thirdArray removeAllObjects];
            
            NSArray *retArray = responseObject[@"ret"];
            
            [self analyzingYizhenCaseWithArray:retArray];
            
            //把模型存入数据库
            [dataManager addclinics:_firstArray andClinicTable:_clinicCaseTable];
            [dataManager addclinics:_secondArray andClinicTable:_clinicCaseTable];
            [dataManager addclinics:_thirdArray andClinicTable:_clinicCaseTable];
            
            [self.loadingView removeFromSuperview];
            self.scrollerView.scrollEnabled = YES;
            [self.activityView stopAnimating];
  
        }

    }];

}
#pragma mark 解析获取到的案例数组
- (void)analyzingYizhenCaseWithArray:(NSArray *)retArray{
//    YYLog(@"%@",retArray);
    for (NSDictionary *dic in retArray) {
        YYClinicModel *model = [[YYClinicModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        YYYizhenUserModel *userModel = [[YYYizhenUserModel alloc] initWithUserName:dic[@"name"] phone:dic[@"phone"] sex:dic[@"sex"] qq:dic[@"qq"] userIconImgUrl:dic[@"headimgurl"] userID:nil];
        
        model.userModel = userModel;
        model.done = @"1";
        if ([model.categoryid isEqualToString:@"1"])
        {
            [_firstArray addObject:model];
        }
        else if ([model.categoryid isEqualToString:@"2"])
        {
            [_secondArray addObject:model];
            
        }
        else if ([model.categoryid isEqualToString:@"3"])
        {
            [_thirdArray addObject:model];
        }
    }
}
#pragma mark 懒加载三个TableView
- (UITableView *)firstTableView{
    if (!_firstTableView) {
 
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cellH, YYWidthScreen, 0)];
        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.scrollEnabled = NO;
    }
    return _firstTableView;
}
- (UITableView *)secondTableView{
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cellH, YYWidthScreen, 0)];
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.scrollEnabled = NO;

    }
    return _secondTableView;
}
- (UITableView *)thirdTableView{
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cellH, YYWidthScreen, 0)];
        _thirdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        _thirdTableView.scrollEnabled = NO;
        
    }
    return _thirdTableView;
}

#pragma mark 初始化变量
- (void)installDatas{
    _firstArray = [NSMutableArray array];
    _secondArray = [NSMutableArray array];
    _thirdArray = [NSMutableArray array];
    _clinicCaseTable = @"t_clinicCaseTable";
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor whiteColor];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    //初始化变量
    [self installDatas];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.numberTable = 0;
    self.scrollerContentHeight = topImageViewHeight + twoBtnViewHeight + YY12HeightMargin + titleLabelH + cellH * 3;
    
    
    [self setNavBar];
    //添加scroller View
    [self addScrollerView];
    
    [self setMJRefresh];
    
    //根据网络状况以及数据库中的数据加载页面
    [self baseOnInterAndDataBaseLoadData];
}
#pragma mark 根据网络状况以及数据库中的数据加载页面
/**
 *  根据网络状况以及数据库中的数据加载页面
 */
- (void)baseOnInterAndDataBaseLoadData{
    YYClinicDataBaseManager *dataManager = [YYClinicDataBaseManager shareClinicDataBaseManager];
    NSArray *models = [dataManager clinicsListFromClinicTable:_clinicCaseTable];
    //数据库没有数据
    if (models.count == 0) {
        //判断网络状态
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == 0) {//断网，显示断网的View
            self.noNetBtnView.x = 0;
            self.noNetBtnView.y = 0;
            [self.view addSubview:self.noNetBtnView];
        }
        else{
            self.loadingView.x = 0;
            self.loadingView.y = 0;
            [self.view addSubview:self.loadingView];
            //加载数据
            [self refreshYizhenCases];
        }
        
    }
    //数据库有数据
    else {
        [self getModelsArrayFromDataBaseWithArray:models];
        //加载数据
        [self refreshYizhenCases];
    }
}

#pragma mark 若数据库存在模型则先展示本地数据
/**
 *  若数据库存在模型则先展示本地数据
 */
- (void)getModelsArrayFromDataBaseWithArray:(NSArray *)modelsArray{
    for (YYClinicModel *model in modelsArray) {
        if ([model.categoryid isEqualToString:@"1"]) {
            [_firstArray addObject:model];
        }
        else if ([model.categoryid isEqualToString:@"2"]) {
            [_secondArray addObject:model];
        }
        else if ([model.categoryid isEqualToString:@"3"]) {
            [_thirdArray addObject:model];
        }
    }
}
#pragma mark 添加scroller View
- (void)addScrollerView{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:scrollerView];
    self.scrollerView = scrollerView;
    //设置scroller View的滚动高度
    self.scrollerView.contentSize = CGSizeMake(YYWidthScreen, self.scrollerContentHeight);
    
    self.scrollerView.backgroundColor = YYGrayBGColor;
    //增加顶部的ScrollerView
    FFScrollView *scroll = [[FFScrollView alloc] initPageViewWithFrame:CGRectMake(0, 0, YYWidthScreen, topImageViewHeight) views:@[@"yizhen_banner_1", @"yizhen_banner_2", @"yizhen_banner_3"]];
    [self.scrollerView addSubview:scroll];
    
    //增加两个按钮的View
    [self addTwoBtnToScrollerView];
    
    CGFloat tablesViewY = topImageViewHeight + twoBtnViewHeight + YY12HeightMargin;
    
    CGFloat tablesViewH = titleLabelH + cellH * 3;
    [self addYizhenTablesViewWithFrame:CGRectMake(0, tablesViewY, YYWidthScreen, tablesViewH)];
    
}
/**
 *  增加两个按钮到ScrollerView
 */
- (void) addTwoBtnToScrollerView{
    UIView *twoBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, topImageViewHeight, YYWidthScreen, twoBtnViewHeight)];
    [self.scrollerView addSubview:twoBtnView];
    twoBtnView.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnW = 130/375.0*YYWidthScreen;
    CGFloat btnH = 44/667.0*YYHeightScreen;
    CGFloat margin = (YYWidthScreen - btnW * 2)/3.5;
    UIButton *onlineBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(margin, YY12HeightMargin, btnW, btnH) superView:twoBtnView backgroundImage:[UIImage imageNamed:@"yizhen_onlineBtn_nor"] titleColor:[UIColor whiteColor] title:@"线上诊断"];
    [onlineBtn setBackgroundImage:[UIImage imageNamed:@"yizhen_onlineBtn_sel"] forState:UIControlStateHighlighted];
    [onlineBtn addTarget:self action:@selector(onlineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *offlineBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(margin * 2.5 + btnW, YY12HeightMargin, btnW, btnH) superView:twoBtnView backgroundImage:[UIImage imageNamed:@"yizhen_onlineBtn_nor"] titleColor:[UIColor whiteColor] title:@"上门诊断"];
    [offlineBtn setBackgroundImage:[UIImage imageNamed:@"yizhen_onlineBtn_sel"] forState:UIControlStateHighlighted];
    [offlineBtn addTarget:self action:@selector(subscribeBtnClick) forControlEvents:UIControlEventTouchUpInside];

}
/**
 *  增加义诊案例的View
 */
- (void)addYizhenTablesViewWithFrame:(CGRect)viewFrame{
    UIView *tablesView = [[UIView alloc] initWithFrame:viewFrame];
    tablesView.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:tablesView];
    self.yizhenTablesView = tablesView;
    
   
    [self setTitleLabelAndLineWithSuperView:tablesView title:@"义诊案例"];
    
    //增加三个模块的案例

    self.taobaoFirstView = [self addYizhenCellWithSuperView:tablesView andFrame:CGRectMake(0, titleLabelH, YYWidthScreen, cellH) andImage:[UIImage imageNamed:@"yizhen_taobao"] andTag:0 andTitle:@"淘宝案例" andDetailText:@"流量·销量·访客·转化率"];
    self.secondView = [self addYizhenCellWithSuperView:tablesView andFrame:CGRectMake(0, titleLabelH + cellH, YYWidthScreen, cellH) andImage:[UIImage imageNamed:@"yizhen_ali"] andTag:1 andTitle:@"1688案例" andDetailText:@"流量·访客·装修·运营"];
    self.internationalThirdView = [self addYizhenCellWithSuperView:tablesView andFrame:CGRectMake(0, titleLabelH + cellH * 2, YYWidthScreen, cellH) andImage:[UIImage imageNamed:@"yizhen_alibaba"] andTag:2 andTitle:@"国际站案例" andDetailText:@"流量·访客·装修"];
}
#pragma mark 增加一个模块案例的View
- (UIView *)addYizhenCellWithSuperView:(UIView *)superView andFrame:(CGRect)cellFrame andImage:(UIImage *)image andTag:(NSInteger)tag andTitle:(NSString *)title andDetailText:(NSString *)detailText{
    
    UIView *cellViewSuper = [[UIView alloc] initWithFrame:cellFrame];
    [superView addSubview:cellViewSuper];
    
    //案例的View
    UIButton *cellView = [[UIButton alloc] initWithFrame:cellViewSuper.bounds];
    cellView.tag = tag;
    [cellViewSuper addSubview:cellView];
    
    //增加左边图片的View
    CGFloat imageViewW = 56;
    CGFloat imageViewH = 56;
    CGFloat imageViewX = YY12WidthMargin * 2;
    CGFloat imageViewY = (cellFrame.size.height - imageViewH)/2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    imageView.image = image;
    
    [cellView addSubview:imageView];
    //增加标题
    CGFloat titleLabelX = imageViewX + imageViewW + YY18WidthMargin;
    CGFloat titleLabelY = imageViewY;
    CGFloat titleLabelW = 150;
    CGFloat sortLabelH = 32;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, sortLabelH)];
    titleLabel.text = title;
    [cellView addSubview:titleLabel];
    //增加小标题
    CGFloat detailLabelY = titleLabelH + titleLabelY;
    CGFloat detailLabelW = 200;
    CGFloat detailLabelH = 16;
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, detailLabelY, detailLabelW, detailLabelH)];
    detailLabel.text = detailText;
    detailLabel.textColor = YYGrayTextColor;
    detailLabel.font = [UIFont systemFontOfSize:15.0];
    [cellView addSubview:detailLabel];
    
    //增加右边的箭头图片
    CGFloat rightImageW = 28;
    CGFloat rightImageH = 28;
    CGFloat rightImageX = YYWidthScreen - rightImageW - YY18WidthMargin;
    CGFloat rightImageY = (cellFrame.size.height - rightImageH)/2.0;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rightImageX, rightImageY, rightImageW, rightImageH)];
    rightImageView.image = [UIImage imageNamed:@"yizhen_rightImage"];
    [cellView addSubview: rightImageView];
    
    switch (tag) {
        case 0:
            self.firstArrow = rightImageView;
            _firstBtn = cellView;
            break;
        case 1:
            self.secondArrow = rightImageView;
            _secondBtn = cellView;
            break;
        case 2:
            self.thirdArrow = rightImageView;
            _thirdBtn = cellView;
            break;
        default:
            break;
    }
    //增加线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:cellView];
    
    [cellView addTarget:self action:@selector(cellClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cellViewSuper;
}
#pragma mark 案例的cell被点击
- (void)cellClickWithBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    UIButton *btn1 = [[UIButton alloc] init];
    btn1.selected = NO;
    
    if (btn.tag == 0) {
        [self taobaoCaseClickWithBtn:btn];
        if (_secondBtn.selected) {
            _secondBtn.selected = NO;
            [self second1688CaseClickWithBtn:_secondBtn];
        }
        if (_thirdBtn.selected) {
            _thirdBtn.selected = NO;
            [self internationCaseClickWithBtn:_thirdBtn];
        }
    }
    else if (btn.tag == 1){
        [self second1688CaseClickWithBtn:btn];
        if (_firstBtn.selected) {
            _firstBtn.selected = NO;
            [self taobaoCaseClickWithBtn:_firstBtn];
        }
        if (_thirdBtn.selected) {
            _thirdBtn.selected = NO;
            [self internationCaseClickWithBtn:_thirdBtn];
        }
    }
    else if (btn.tag == 2){
        [self internationCaseClickWithBtn:btn];
        if (_firstBtn.selected) {
            _firstBtn.selected = NO;
            [self taobaoCaseClickWithBtn:_firstBtn];
        }
        if (_secondBtn.selected) {
            _secondBtn.selected = NO;
            [self second1688CaseClickWithBtn:_secondBtn];
        }

    }
    
    CGFloat height = self.scrollerContentHeight + self.numberTable * 3 * yizhenCellHeight;
    YYLog(@"%d几页",self.numberTable);
    YYLog(@"%f",height);
    if (self.numberTable == 1) {
        [UIView animateWithDuration:0.25 animations:^{
//            CGFloat contentY = height - YYHeightScreen + cellH;
//            
//            if (_secondBtn.selected) {
////                contentY += cellH;
//            }
//            else if (_thirdBtn.selected){
////                contentY += 2 * cellH;
//            }
            
            self.scrollerView.contentSize = CGSizeMake(YYWidthScreen, height);
            self.scrollerView.contentOffset = CGPointMake(0, cellH);
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollerView.contentSize = CGSizeMake(YYWidthScreen, height);
            self.scrollerView.contentOffset = CGPointMake(0, -64);
        }];
    }
    
    
    
}
#pragma mark 淘宝案例被点击
- (void)taobaoCaseClickWithBtn:(UIButton *)btn{
    if (btn.selected) {
        [self.taobaoFirstView addSubview:self.firstTableView];
        self.numberTable +=1;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.firstArrow.transform = CGAffineTransformMakeRotation(M_PI_2);
            
            self.firstTableView.height = 3 * yizhenCellHeight;
            self.taobaoFirstView.height += 3 *yizhenCellHeight;
            self.secondView.y += 3 *yizhenCellHeight;
            self.internationalThirdView.y += 3 *yizhenCellHeight;
            
            self.yizhenTablesView.height += 3 * yizhenCellHeight;
        }];

    }
    else{
        self.numberTable -= 1;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.firstArrow.transform = CGAffineTransformIdentity;
          
            self.firstTableView.height = 0;
            self.taobaoFirstView.height -= 3 *yizhenCellHeight;
            self.secondView.y -= 3 *yizhenCellHeight;
            self.internationalThirdView.y -= 3 *yizhenCellHeight;
            
            self.yizhenTablesView.height -= 3 * yizhenCellHeight;
        } completion:^(BOOL finished) {
            [self.firstTableView removeFromSuperview];
        }];
    }
    YYLog(@"淘宝案例");
}
#pragma mark 1688案例被点击
- (void)second1688CaseClickWithBtn:(UIButton *)btn{
    
    if (btn.selected) {//为yes说明展开
        
        [self.secondView addSubview:self.secondTableView];
        self.numberTable += 1;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.secondArrow.transform = CGAffineTransformMakeRotation(M_PI_2);
           
            self.secondView.height += 3 * yizhenCellHeight;
            self.secondTableView.height = 3 * yizhenCellHeight;
            self.internationalThirdView.y += 3 * yizhenCellHeight;
            
            self.yizhenTablesView.height += 3 * yizhenCellHeight;
        }];
    }
    else{
        self.numberTable -= 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.secondArrow.transform = CGAffineTransformIdentity;
            
            self.secondTableView.height = 0;
            self.secondView.height -= 3 * yizhenCellHeight;
            self.internationalThirdView.y -= 3 * yizhenCellHeight;
            
            self.yizhenTablesView.height -= 3 * yizhenCellHeight;
        } completion:^(BOOL finished) {
            [self.secondTableView removeFromSuperview];
        }];
    }
    YYLog(@"1688案例");
}
#pragma mark 国际站案例被点击
- (void)internationCaseClickWithBtn:(UIButton *)btn{
 
        if (btn.selected) {
            self.numberTable += 1;
            [self.internationalThirdView addSubview:self.thirdTableView];
            
            [UIView animateWithDuration:0.25 animations:^{
             
                self.thirdArrow.transform = CGAffineTransformMakeRotation(M_PI_2);
                
                self.thirdTableView.height = 3 * yizhenCellHeight;
                self.internationalThirdView.height += 3 * yizhenCellHeight;
                self.yizhenTablesView.height += 3 * yizhenCellHeight;

            }];
        }
        else{
            self.numberTable -= 1;
            [UIView animateWithDuration:0.25 animations:^{
                self.thirdArrow.transform = CGAffineTransformIdentity;
     
                
                self.thirdTableView.height = 0;
                self.internationalThirdView.height -= 3 * yizhenCellHeight;
                self.yizhenTablesView.height -= 3 * yizhenCellHeight;
            } completion:^(BOOL finished) {
                [self.thirdTableView removeFromSuperview];
            }];
        }
  
   
    YYLog(@"国际站案例");
}
#pragma mark 设置一部分顶部的标题
- (void)setTitleLabelAndLineWithSuperView:(UIView *)superView title:(NSString *)title{

    //设置义诊案例
    CGFloat blueLineH = 20;
    CGFloat blueLineY = (titleLabelH - blueLineH)/2.0;
    CGFloat blueLabelW = 5;
    UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, blueLineY, blueLabelW, blueLineH)];
    blueLine.backgroundColor = YYBlueTextColor;
    [superView addSubview:blueLine];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(blueLabelW + 10, 0, YYWidthScreen, titleLabelH)];
    [superView addSubview:titleLabel];
    titleLabel.text = title;
}
- (void)myOrderBtnClick{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        //去登录页面
        [self registerLoginBtnClick];
        return;
    }
    YYMyOrderTableViewController *myorder = [[YYMyOrderTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:myorder animated:YES];
}
#pragma mark 自定义导航条
- (void)setNavBar{
    //设置标题
    self.title = @"义诊";
    //设置右边按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"我的义诊" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(myOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 申请义诊按钮,线下预约按钮被点击
/**
 *  申请义诊按钮被点击
 */
- (void)onlineBtnClick:(UIButton *)btn{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        //去登录页面
        [self registerLoginBtnClick];
        return;
    }
    YYOnLineYiZhenViewController *applyController = [[YYOnLineYiZhenViewController alloc] init];
    [self.navigationController pushViewController:applyController animated:YES];
}
/**
 *  线下预约按钮被点击
 */
- (void)subscribeBtnClick{
   
    YYOfflineYiZhenViewController *offline = [[YYOfflineYiZhenViewController alloc] init];
    [self.navigationController pushViewController:offline animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _firstTableView) {
        return _firstArray.count;
    }
    else if(tableView == _secondTableView) {
        return _secondArray.count;
    }
    else if(tableView == _thirdTableView) {
        return _thirdArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"yizhenSmallCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (tableView == self.firstTableView) {
        YYClinicModel *model = _firstArray[indexPath.row];
        cell.textLabel.text = model.title;
        
    }
    else if (tableView == self.secondTableView){
        YYClinicModel *model = _secondArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    else if (tableView == self.thirdTableView){
        YYClinicModel *model = _thirdArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    cell.textLabel.textColor = YYGrayTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, 0, YYWidthScreen - YY18WidthMargin * 2, 0.5) andView:cell.contentView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return yizhenCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firstTableView) {
        YYClinicModel *taobaoModel = _firstArray[indexPath.row];
        YYYiZhenDetailsViewController *detailController = [[YYYiZhenDetailsViewController alloc] initWithModel:taobaoModel];
        [self.navigationController pushViewController:detailController animated:YES];
    }
    else if (tableView == self.secondTableView){
        YYClinicModel *aliModel = _secondArray[indexPath.row];
        YYYiZhenDetailsViewController *detailController = [[YYYiZhenDetailsViewController alloc] initWithModel:aliModel];
        [self.navigationController pushViewController:detailController animated:YES];
        
    }
    else if (tableView == self.thirdTableView){
        YYClinicModel *interModel = _thirdArray[indexPath.row];
        YYYiZhenDetailsViewController *detailController = [[YYYiZhenDetailsViewController alloc] initWithModel:interModel];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

#pragma mark 设置刷新控件
- (void)setMJRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
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
    self.scrollerView.mj_header = header;
}
- (void)loadNewData{
    [self refreshYizhenCases];
    
    
    YYLog(@"刷新数据");
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
    self.loadingView.y = 0;

    [self.view addSubview:self.loadingView];
    
    [self refreshYizhenCases];
  
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
