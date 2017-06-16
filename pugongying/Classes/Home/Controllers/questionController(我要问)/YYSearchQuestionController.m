//
//  YYSearchQuestionController.m
//  pugongying
//
//  Created by wyy on 16/2/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYSearchQuestionController.h"
#import "WYYSearchBar.h"
#import "YYQuestionStateCell.h"
#import "YYQuestionStateCellFrame.h"
#import "YYQuestionStateModel.h"

@interface YYSearchQuestionController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 *  问题的数组
 */
@property (nonatomic, strong) NSArray *questionArray;

/**
 *  蒙版按钮
 */
@property (nonatomic, strong) UIButton *coverBtn;
/**
 *  搜索框
 */
@property (nonatomic, weak) WYYSearchBar  *searchBar;
/**
 *  中间的tableView
 */
@property (nonatomic, strong) UITableView *centerTableView;
/**
 *  热门搜索的View
 */
@property (nonatomic, strong) UIView *hotSearchView;
/**
 *  热门搜索按钮的View
 */
@property (nonatomic, weak) UIView *hotBtnsView;
/**
 *  热门搜索按钮上的内容数组
 */
@property (nonatomic, strong) NSArray *hotBtnTextArray;
@end

@implementation YYSearchQuestionController
#pragma mark 懒加载数据
- (NSArray *)hotBtnTextArray{
    if (!_hotBtnTextArray) {
        _hotBtnTextArray = @[@"怎么开网店", @"我想开网店", @"怎么开网店", @"我想开网店", @"怎么开网店", @"我想开网店"];
    }
    return _hotBtnTextArray;
}
/**
 * 懒加载tableView
 */
- (UITableView *)centerTableView{
    if (!_centerTableView) {
        //增加中间的tableView
        CGFloat tableViewY = 64;
        CGFloat tableViewH = YYHeightScreen - 48 - tableViewY;
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, YYWidthScreen, tableViewH) style:UITableViewStyleGrouped];
        _centerTableView.delegate = self;
        _centerTableView.dataSource = self;
    }
    return _centerTableView;
}
/**
 *  懒加载热门搜索的整个View
 */
- (UIView *)hotSearchView{
    if (!_hotSearchView) {
        CGFloat tableViewY = 64;
        CGFloat tableViewH = YYHeightScreen - 48 - tableViewY;
        _hotSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewY, YYWidthScreen, tableViewH)];
        _hotSearchView.backgroundColor = [UIColor whiteColor];
        
        //在热门搜索View中增加热门搜索Label
        CGFloat labelY = 20/667.0*YYHeightScreen;
        CGFloat labelH = 20;
        CGFloat labelW = 70;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, labelY, labelW, labelH)];
        [_hotSearchView addSubview:label];
        label.text = @"热门搜索";
        label.textColor = YYGrayTextColor;
        
    }
    return _hotSearchView;
}
/**
 * 加载到热门搜索按钮的数据后在热门搜索View中增加多个热门搜索按钮的View
 */
- (void)addhotBtnsViewWithViewY:(CGFloat)viewY{
    CGFloat margin = 30/375.0 * YYWidthScreen;
    CGFloat btnW = (YYWidthScreen - 2*YY18WidthMargin - margin)/2.0;
    CGFloat btnH = 40;
    CGFloat viewW = YYWidthScreen;
    CGFloat viewH = (btnH + YY12HeightMargin) * 3;
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, viewW, viewH)];
    [_hotSearchView addSubview:btnsView];
    self.hotBtnsView = btnsView;
    
    //在热门搜索View中增加6个按钮
    for (int i =0; i < self.hotBtnTextArray.count; i++) {
        CGFloat btnX = i%2* (btnW + margin) + YY18WidthMargin;
        CGFloat btnY = i/2*(btnH + YY12HeightMargin);
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [self.hotBtnsView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"home_question_btnGrayBG"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(hotBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.hotBtnTextArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
}
#pragma mark 热门搜索中的按钮被点击
- (void)hotBtnClickWithBtn:(UIButton *)btn{
    YYLog(@"%ld",(long)btn.tag);
}
/**
 *  蒙版按钮懒加载
 */
- (UIButton *)coverBtn{
    if (!_coverBtn) {
        CGFloat tableViewY = 64;
        CGFloat tableViewH = YYHeightScreen - 48 - tableViewY;
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableViewY, YYWidthScreen, tableViewH)];
        _coverBtn.backgroundColor = [UIColor clearColor];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _coverBtn;
}
/**
 *  遮盖层被点击
 */
- (void)coverBtnClick{
    [self.coverBtn removeFromSuperview];
    [self.searchBar resignFirstResponder];
}
- (NSArray *)questionArray{
    if (!_questionArray) {
        YYQuestionStateModel *model = [[YYQuestionStateModel alloc] init];
        model.userName = @"东海龙三太子";
        model.contentText = @"东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子东海龙三太子";
        model.rewardNumber = @"100";
        model.markText = @"开店  淘宝运营";
        model.dateText = @"1天前";
        model.answerNumber = @"1111";
        model.state = YYQuestionStateFinshed;
        YYQuestionStateCellFrame *cellFrame = [[YYQuestionStateCellFrame alloc] init];
        cellFrame.model = model;
        
        
        YYQuestionStateModel *model1 = [[YYQuestionStateModel alloc] init];
        model1.userName = @"东海龙三太子";
        model1.contentText = @"QQ邮箱,为亿万用户提供高效稳定便捷的电子邮件服务。你可以在电脑网页、iOS/iPad客户端、及Android客户端上使用它,通过邮件发送3G的超大附件,体验文件中转站、日历、户端上使用它,通过邮件发送3G的超";
        model1.rewardNumber = @"100";
        model1.markText = @"开店  淘宝运营";
        model1.dateText = @"1天前";
        model1.answerNumber = @"1111";
        model1.state = YYQuestionStateProgress;
        YYQuestionStateCellFrame *cellFrame1 = [[YYQuestionStateCellFrame alloc] init];
        cellFrame1.model = model1;
        _questionArray = @[cellFrame, cellFrame1, cellFrame];
    }
    return _questionArray;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //增加顶部的搜索框的View
    [self addHeaderView];
    //增加底部的向其他网友提问按钮的View
    [self addQuestionFriendBtnViewWithHeight:48];
    
    // 先显示热门搜索的View
    [self.view addSubview:self.hotSearchView];
 
    //加载到热门搜索按钮的数据后在热门搜索View中增加多个热门搜索按钮的View
    CGFloat labelY = 20/667.0*YYHeightScreen;
    CGFloat labelH = 20;
    CGFloat viewY = labelY + labelH + YY12HeightMargin;
    [self addhotBtnsViewWithViewY:viewY];

}
#pragma mark 增加顶部的搜索框d的View
- (void) addHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, YYWidthScreen, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    //在headerView中增加搜索框
    CGFloat searchBarW = YYWidthScreen - YY18WidthMargin*2 - 40 - YY12WidthMargin;
    WYYSearchBar *searchBar = [[WYYSearchBar alloc] initWithFrame:CGRectMake(YY18WidthMargin, 4.5, searchBarW, 35)];
    [headerView addSubview:searchBar];
    self.searchBar = searchBar;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    //在headerView中增加取消按钮
    CGFloat btnW = 40;
    CGFloat btnX = YYWidthScreen - YY18WidthMargin - 40;
    UIButton *previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, headerView.height)];
    [headerView addSubview:previousBtn];
    [previousBtn setTitle:@"取消" forState:UIControlStateNormal];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [previousBtn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //增加下方的线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 43.5, YYWidthScreen, 0.5) andView:headerView];
    //键盘弹出后添加遮盖层
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow) name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark 弹出键盘调用的方法
- (void)keyBoardWillShow{
    [self.view addSubview:self.coverBtn];
}
#pragma mark 增加底部的向其他网友提问按钮的View
- (void)addQuestionFriendBtnViewWithHeight:(CGFloat)btnHeight{
    CGFloat btnViewY = YYHeightScreen - btnHeight;
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, btnViewY, YYWidthScreen, btnHeight)];
    [self.view addSubview:btnView];
    btnView.backgroundColor = [UIColor whiteColor];
    
    //增加按钮
    CGFloat btnW = 215;
    CGFloat btnY = 4;
    CGFloat btnH = 40;
    CGFloat btnX = (YYWidthScreen - 215)/2.0;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [btnView addSubview:btn];
    [btn setTitle:@"向其他网友提问" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_question_btnBG"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(questionFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加按钮View顶部的线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:btnView];
}
/**
 *  向其他网友提问按钮被点击
 */
- (void)questionFriendBtnClick{
    YYLog(@"向其他网友提问按钮被点击");
}
/**
 *  取消按钮被点击
 */
- (void)previousBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.questionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYQuestionStateCell *cell = [YYQuestionStateCell questionCellWithTableView:tableView];
    
    YYQuestionStateCellFrame *cellFrame = self.questionArray[indexPath.section];
    
    cell.questionCellFrame = cellFrame;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark UITableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYQuestionStateCellFrame *cellFrame = self.questionArray[indexPath.section];
    return cellFrame.cellRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YY12HeightMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
#pragma mark 搜索框的代理方法
/**
 *  键盘上的搜索键被点击
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击搜索后隐藏热门View显示tableView
    [self.hotSearchView removeFromSuperview];
    [self.view addSubview:self.centerTableView];
    [self.searchBar resignFirstResponder];
    return YES;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
}
@end
