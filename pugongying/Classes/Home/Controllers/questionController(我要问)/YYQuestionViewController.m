//
//  YYQuestionViewController.m
//  pugongying
//
//  Created by wyy on 16/2/29.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  搜索问题我的提问我的回答三个按钮用的tag值为10，11，12
 
    最新，最热，高悬赏用的是0，1，2
 *
 */
#define YYPurpleThisColor [UIColor colorWithRed:197/255.0 green:100/255.0 blue:208/255.0 alpha:1]
#import "YYQuestionViewController.h"
#import "YYQuestionCell.h"
#import "YYQuestionCellFrame.h"
#import "YYQuestionModel.h"
#import "YYSearchQuestionController.h"
#import "YYMyQuestionTableViewController.h"
#import "YYMyAnswerTableViewController.h"
#import "YYPostQuestionViewController.h"

@interface YYQuestionViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UIView *topView;
/**
 *  标题下方的紫色线
 */
@property (nonatomic, weak) UIView *lineView;
/**
 *  最新按钮
 */
@property (nonatomic, weak) UIButton *newestBtn;
/**
 *  最热按钮
 */
@property (nonatomic, weak) UIButton *hotBtn;
/**
 *  高悬赏按钮
 */
@property (nonatomic, weak) UIButton *rewardBtn;
/**
 *  下面的scrollerView
 */
@property (nonatomic, weak) UIScrollView *bottomScrollerView;

/**
 *  最新问题数组
 */
@property (nonatomic, strong) NSArray *newsQuestionArray;
@property (nonatomic, weak) UITableView *newsTableView;
/**
 *  最热问题数组
 */
@property (nonatomic, strong) NSArray *hotQuestionArray;
@property (nonatomic, weak) UITableView *hotTableView;
/**
 *  高悬赏问题数组
 */
@property (nonatomic, strong) NSArray *rewardQuestionArray;
@property (nonatomic, weak) UITableView *rewardTableView;

@end

@implementation YYQuestionViewController
#pragma mark 懒加载三个数组的数据
- (NSArray *)newsQuestionArray{
    if (!_newsQuestionArray) {
        YYQuestionModel *model = [[YYQuestionModel alloc] init];
        model.userName = @"东海龙三太子";
        model.contentText = @"东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子";
        model.rewardNumber = @"100";
        model.markText = @"开店  淘宝运营";
        model.dateText = @"1天前";
        model.answerNumber = @"1111";
        YYQuestionCellFrame *cellFrame = [[YYQuestionCellFrame alloc] init];
        cellFrame.model = model;
        
        
        YYQuestionModel *model1 = [[YYQuestionModel alloc] init];
        model1.userName = @"东海龙三太子";
        model1.contentText = @"QQ邮箱,为亿万用户提供高效稳定便捷的电子邮件服务。你可以在电脑网页、iOS/iPad客户端、及Android客户端上使用它,通过邮件发送3G的超大附件,体验文件中转站、日历、户端上使用它,通过邮件发送3G的超";
        model1.rewardNumber = @"100";
        model1.markText = @"开店  淘宝运营";
        model1.dateText = @"1天前";
        model1.answerNumber = @"1111";
        YYQuestionCellFrame *cellFrame1 = [[YYQuestionCellFrame alloc] init];
        cellFrame1.model = model1;
        _newsQuestionArray = @[cellFrame, cellFrame1, cellFrame];
    }
    return _newsQuestionArray;
}
- (NSArray *)hotQuestionArray{
    if (!_hotQuestionArray) {
        YYQuestionModel *model = [[YYQuestionModel alloc] init];
        model.userName = @"东海龙三太子";
        model.contentText = @"您的浏览器可能不支持自动设置主页。请参考以下步骤，设置百度为您的上网主页。您的浏览器可能不支持自动设置主页。请参考以下步骤，设置百度为您的上网主的浏览器可能不支持自动设置主页。请参考以下步。";
        model.rewardNumber = @"0";
    
        model.markText = @"开店  淘宝运营";
        model.dateText = @"1天前";
        model.answerNumber = @"1111";
        YYQuestionCellFrame *cellFrame = [[YYQuestionCellFrame alloc] init];
        cellFrame.model = model;
        _hotQuestionArray = @[cellFrame, cellFrame];
    }
    return _hotQuestionArray;
}
- (NSArray *)rewardQuestionArray{
    if (!_rewardQuestionArray) {
        YYQuestionModel *model = [[YYQuestionModel alloc] init];
        model.userName = @"东海龙三太子";
        model.contentText = @"云音乐官方账号。欢迎使用网易云音乐,有任何问题可以联系@云音乐小秘书 我们会尽快答复。独立音乐人招募邮箱:music163yc@163.com";
        model.rewardNumber = @"100";
        model.markText = @"开店  淘宝运营";
        model.dateText = @"1天前";
        model.answerNumber = @"1111";
        YYQuestionCellFrame *cellFrame = [[YYQuestionCellFrame alloc] init];
        
        cellFrame.model = model;
        _rewardQuestionArray = @[cellFrame, cellFrame];
    }
    return _rewardQuestionArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //增加顶部的View
    CGFloat topHeight = 64 + 30 + 25/667.0*YYHeightScreen + 100/667.0*YYHeightScreen + 25/667.0*YYHeightScreen;
    [self addTopViewWithViewHeight:topHeight];
    
    //增加标题按钮的View
    CGFloat btnsViewY = topHeight;
    [self addTitleBtnsViewWithViewY:btnsViewY andViewH:41];
    
    [self btnsClick:self.newestBtn];
    
    //增加下面的scrollerView
    CGFloat scrollerViewY = btnsViewY + 41;
    [self addBottomScrollerViewWithScrollerY:scrollerViewY];
    
    
    
}
#pragma mark 增加下面的scrollerView
- (void)addBottomScrollerViewWithScrollerY:(CGFloat)scrollerViewY{
    CGFloat scrollerViewH = YYHeightScreen - scrollerViewY;
    
    UIScrollView *bottomScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollerViewY, YYWidthScreen, scrollerViewH)];
    [self.view addSubview:bottomScrollerView];
    self.bottomScrollerView = bottomScrollerView;
    
    bottomScrollerView.backgroundColor = [UIColor whiteColor];
    bottomScrollerView.contentSize = CGSizeMake(YYWidthScreen * 3, scrollerViewH);
    bottomScrollerView.pagingEnabled = YES;
    bottomScrollerView.delegate = self;
    
    //把最新对应模块增加到ScrollerView
    UITableView *newestTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, scrollerViewH) style:UITableViewStyleGrouped];
    
    [bottomScrollerView addSubview:newestTableView];
    self.newsTableView = newestTableView;
    newestTableView.delegate = self;
    newestTableView.dataSource = self;
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //把最热对应模块增加到ScrollerView
    UITableView *hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(YYWidthScreen, 0, YYWidthScreen, scrollerViewH) style:UITableViewStyleGrouped];
    [bottomScrollerView addSubview:hotTableView];
    self.hotTableView = hotTableView;
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //把高悬赏对应模块增加到ScrollerView
    UITableView *rewardTableView = [[UITableView alloc] initWithFrame:CGRectMake(YYWidthScreen * 2, 0, YYWidthScreen, scrollerViewH) style:UITableViewStyleGrouped];
    [bottomScrollerView addSubview:rewardTableView];
    self.rewardTableView = rewardTableView;
    self.rewardTableView.delegate = self;
    self.rewardTableView.dataSource = self;
    self.rewardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark tableView的数据源方法
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    YYLog(@"%ld",(unsigned long)self.newsQuestionArray.count);
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.newsTableView) {
       
        return self.newsQuestionArray.count;
    }
    else if (tableView == self.hotTableView){
        return self.hotQuestionArray.count;
    }
    return self.rewardQuestionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYQuestionCell *cell = [YYQuestionCell questionCellWithTableView:tableView];
    
    YYQuestionCellFrame *cellFrame = [[YYQuestionCellFrame alloc] init];
    
    if (tableView ==self.newsTableView) {
        cellFrame = self.newsQuestionArray[indexPath.row];
    }
    else if (tableView == self.hotTableView){
        cellFrame = self.hotQuestionArray[indexPath.row];
    }
    else if (tableView == self.rewardTableView){
        cellFrame = self.rewardQuestionArray[indexPath.row];
    }

    cell.questionCellFrame = cellFrame;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}
#pragma mark tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYQuestionCellFrame *cellFrame = [[YYQuestionCellFrame alloc] init];
    
    if (tableView ==self.newsTableView) {
        cellFrame = self.newsQuestionArray[indexPath.row];
    }
    else if (tableView == self.hotTableView){
        cellFrame = self.hotQuestionArray[indexPath.row];
    }
    else if (tableView == self.rewardTableView){
        cellFrame = self.rewardQuestionArray[indexPath.row];
    }
    
    return cellFrame.cellRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
#pragma mark 增加顶部的View
- (void)addTopViewWithViewHeight:(CGFloat)viewHeight{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, viewHeight)];
    topView.backgroundColor = YYPurpleThisColor;
    [self.view addSubview:topView];
    self.topView = topView;
    //增加返回按钮和提问按钮
    [self addPreviousBtnAndQuestionBtn];
    
    //增加互助问答标题
    CGFloat questionImageViewX = YYWidthScreen/3.0;
    CGFloat questionImageViewY = 64;
    CGFloat questionImageViewH = 30;
    UIImageView *questionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(questionImageViewX, questionImageViewY, questionImageViewX, questionImageViewH)];
    [self.view addSubview:questionImageView];
    questionImageView.image = [UIImage imageNamed:@"home_question_0"];
    
    //增加搜索问题我的提问我的回答三个按钮的View
    CGFloat btnsViewX = 52/375.0*YYWidthScreen;
    CGFloat btnsViewY = questionImageViewY + questionImageViewH + 25/667.0*YYHeightScreen;
    CGFloat btnsViewW = YYWidthScreen - btnsViewX * 2;
    CGFloat btnsViewH = 100/667.0*YYHeightScreen;
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(btnsViewX, btnsViewY, btnsViewW, btnsViewH)];
    [topView addSubview:btnsView];
    
    CGFloat margin = 28/375.0*YYWidthScreen;
    CGFloat btnW = (btnsViewW - 2*margin)/3.0;
    //搜索问题按钮
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnsViewH)];
    btn0.tag = 10;
    [btn0 setImage:[UIImage imageNamed:@"home_question_1"] forState:UIControlStateNormal];
    [btnsView addSubview:btn0];
    [btn0 addTarget:self action:@selector(topQuestionsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //我的问题按钮
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btnW +margin, 0, btnW, btnsViewH)];
    btn1.tag = 11;
    [btn1 setImage:[UIImage imageNamed:@"home_question_2"] forState:UIControlStateNormal];
    [btnsView addSubview:btn1];
    [btn1 addTarget:self action:@selector(topQuestionsBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    //我的回答按钮
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake((btnW +margin)*2, 0, btnW, btnsViewH)];
    btn2.tag = 12;
    [btn2 setImage:[UIImage imageNamed:@"home_question_3"] forState:UIControlStateNormal];
    [btnsView addSubview:btn2];
    [btn2 addTarget:self action:@selector(topQuestionsBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
/**
 *  搜索问题我的提问我的回答三个按钮被点击
 *
 */
- (void)topQuestionsBtnClick:(UIButton *)btn{
    YYLog(@"%ld",(long)btn.tag);
    switch (btn.tag) {
        case 10:
            [self.navigationController pushViewController:[[YYSearchQuestionController alloc] init] animated:YES];
            break;
        case 11:
            [self.navigationController pushViewController:[[YYMyQuestionTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            break;
        case 12:
            [self.navigationController pushViewController:[[YYMyAnswerTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            break;
            
        default:
            break;
    }
}
/**
 *  增加返回按钮和提问按钮
 */
- (void)addPreviousBtnAndQuestionBtn{
    //增加返回按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(YY18WidthMargin, 20, 50, 44)];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:btn];
    [btn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    增加提问按钮
    CGFloat questionBtnX = YYWidthScreen - YY18WidthMargin - 50;
    UIButton *questionBtn = [[UIButton alloc] initWithFrame:CGRectMake(questionBtnX, 20, 50, 44)];
    [questionBtn setTitle:@"提问" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    questionBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.topView addSubview:questionBtn];
    [questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  返回按钮被点击
 */
- (void)previousBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  提问按钮被点击
 */
- (void)questionBtnClick{
    YYPostQuestionViewController *postQuestion = [[YYPostQuestionViewController alloc] init];
    [self.navigationController pushViewController:postQuestion animated:YES];
    YYLog(@"提问按钮被点击");
}

#pragma mark 增加标题按钮的View
- (void)addTitleBtnsViewWithViewY:(CGFloat)viewY andViewH:(CGFloat)viewH{
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, YYWidthScreen, viewH)];
    [self.view addSubview:btnsView];
    //增加底下的线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YYWidthScreen, 1)];
    [btnsView addSubview:bottomLine];
    bottomLine.backgroundColor = YYGrayLineColor;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 70, 1)];
    [btnsView addSubview:lineView];
    lineView.backgroundColor = YYPurpleThisColor;
    self.lineView = lineView;
    
    CGFloat btnW = 70;
    CGFloat btnH = 40;
    CGFloat btnY = 0;
    self.newestBtn = [self addBtnOnSuperView:btnsView andFrame:CGRectMake(0, btnY, btnW, btnH) andTitle:@"最新"];
    self.newestBtn.tag = 0;
    self.hotBtn = [self addBtnOnSuperView:btnsView andFrame:CGRectMake(btnW, btnY, btnW, btnH) andTitle:@"最热"];
    self.hotBtn.tag = 1;
    self.rewardBtn = [self addBtnOnSuperView:btnsView andFrame:CGRectMake(btnW * 2, btnY, btnW, btnH) andTitle:@"高悬赏"];
    self.rewardBtn.tag = 2;
    
    
}
- (UIButton *)addBtnOnSuperView:(UIView *)superView andFrame:(CGRect)btnFrame andTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [superView addSubview:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:YYPurpleThisColor forState:UIControlStateSelected];
    [btn setTitleColor:YYPurpleThisColor forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    return btn;
}
#pragma mark 三个按钮其中一个被点击
- (void)btnsClick:(UIButton *)btn{
    self.newestBtn.selected = NO;
    self.hotBtn.selected = NO;
    self.rewardBtn.selected = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.x = btn.tag * btn.width;
        btn.selected = YES;
        self.bottomScrollerView.contentOffset = CGPointMake(btn.tag * YYWidthScreen, 0);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bottomScrollerView) {
     
        self.lineView.x = scrollView.contentOffset.x/YYWidthScreen*70;
        int page = scrollView.contentOffset.x/ YYWidthScreen;
        self.newestBtn.selected = NO;
        self.hotBtn.selected = NO;
        self.rewardBtn.selected = NO;
        switch (page) {
            case 0:
                self.newestBtn.selected = YES;
                break;
            case 1:
                self.hotBtn.selected = YES;
                break;
            case 2:
                self.rewardBtn.selected = YES;
                break;
            default:
                break;
        }

        
    }
}


@end
