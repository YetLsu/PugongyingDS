//
//  YYYiZhenDetailsViewController.m
//  pugongying
//
//  Created by wyy on 16/3/9.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYiZhenDetailsViewController.h"


#import "YYYiZhenQuestionFrame.h"
#import "YYYiZhenQuestionView.h"
#import "YYYiZhenAnswerView.h"
#import "YYYiZhenAnswerFrame.h"

#define TwoBtnViewHeight 40


@interface YYYiZhenDetailsViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) YYYiZhenQuestionFrame *modelFrame;
@property (nonatomic, strong) YYYiZhenAnswerFrame *answerModelFrame;
/**
 *scroller View
 */
@property (nonatomic, weak) UIScrollView *scrollerView;

/**
 *  是否是QQ发请求
 */
@property (nonatomic, assign) BOOL qqRequest;

@end

@implementation YYYiZhenDetailsViewController
- (instancetype)initWithModel:(YYClinicModel *)model{
    if (self = [super init]) {
        self.modelFrame = [[YYYiZhenQuestionFrame alloc] init];
        self.modelFrame.model = model;
        
        self.answerModelFrame = [[YYYiZhenAnswerFrame alloc] init];
        self.answerModelFrame.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"义诊详情";
    //增加scroller View到诊详情的View
    [self addScrollerViewToSuperView];
}
#pragma mark 增加scroller View到诊详情的View
- (void)addScrollerViewToSuperView{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, YYHeightScreen)];
    [self.view addSubview:scrollerView];
    self.scrollerView = scrollerView;
    self.scrollerView.contentSize = CGSizeMake(YYWidthScreen, 1000);
    
    self.scrollerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    
    //增加问题的View到义诊详情
    CGFloat bgViewW = YYWidthScreen - YY18WidthMargin * 2;
    [self addQuestionViewToScrollerViewWithFrame:CGRectMake(YY18WidthMargin, YY12HeightMargin, bgViewW, self.modelFrame.viewHeight)];
    
    //增加回复的View到义诊详情
    CGFloat viewY = YY12HeightMargin + self.modelFrame.viewHeight + YY12HeightMargin;
    YYYiZhenAnswerView *answerView = [YYYiZhenAnswerView yiZhenAnswerViewWithFrame:CGRectMake(YY18WidthMargin, viewY, bgViewW, self.answerModelFrame.viewHeight)];
    [self.scrollerView addSubview:answerView];
    answerView.answerModelFrame = self.answerModelFrame;
    
    //增加两个联系方式的View到ScrollerView上
    CGFloat btnMargin = YY18WidthMargin;
    CGFloat btnW = (YYWidthScreen - btnMargin * 2.5)/2.0;
    CGFloat scale = btnW/165.0;
    CGFloat btnH = 46.5 * scale;
    
    CGFloat twoBtnViewY = CGRectGetMaxY(answerView.frame) + 20;
    CGFloat twoBtnViewH = btnH;
    UIView *twoBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, twoBtnViewY , YYWidthScreen, twoBtnViewH)];
    [self.scrollerView addSubview:twoBtnView];

    //增加QQ按钮
    UIButton *qqBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnMargin, 0, btnW, btnH)];
    [qqBtn setImage:[UIImage imageNamed:@"yizhen_myqqyuyueBig"] forState:UIControlStateNormal];
    [twoBtnView addSubview:qqBtn];
    [qqBtn addTarget:self action:@selector(QQBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加电话按钮
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(1.5 *btnMargin + btnW, 0, btnW, btnH)];
    [phoneBtn setImage:[UIImage imageNamed:@"yizhen_myphoneyuyueBig"] forState:UIControlStateNormal];
    [twoBtnView addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //改变ScrollerView的滚动高度
    CGFloat height = twoBtnViewY + 20 + TwoBtnViewHeight;
    self.scrollerView.contentSize = CGSizeMake(YYWidthScreen, height);
}
#pragma mark 增加问题的View到义诊详情的ScrollerView
- (void)addQuestionViewToScrollerViewWithFrame:(CGRect)viewFrame{

    YYYiZhenQuestionView *questionView = [YYYiZhenQuestionView yiZhenQuestionViewWithFrame:viewFrame];

    [self.scrollerView addSubview:questionView];
    
    questionView.modelFrame = self.modelFrame;

}
#pragma mark加系统通知的View未回答到到ScrollerView上
- (void)addNoFinishViewToSelfViewWithY:(CGFloat)viewY{
    
}
#pragma mark 加官方回复的View到ScrollerView上
- (void)addAnswerViewToScrollerViewWithY:(CGFloat)viewY{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark QQ预约按钮被点击
- (void)QQBtnClick{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2969944016&version=1&src_type=web"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
#pragma mark 电话预约按钮被点击
- (void)phoneBtnClick{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0575-85321688"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL.absoluteString rangeOfString:@"mqq"].location != NSNotFound) {//字符串中存在mqq
        
        self.qqRequest = YES;
    }
    else{
        self.qqRequest = NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    if (self.qqRequest) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QQ预约失败" message:@"是否去电话预约" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
        [alertView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [self phoneBtnClick];
    }
    
}

@end
