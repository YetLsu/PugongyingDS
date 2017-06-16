//
//  YYXieYiWebViewController.m
//  pugongying
//
//  Created by wyy on 16/3/14.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYXieYiWebViewController.h"

@interface YYXieYiWebViewController ()<UIWebViewDelegate>

@end

@implementation YYXieYiWebViewController
- (instancetype)initWithFromRegister{
    if (self = [super init]) {
        //添加导航栏
        UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, 64)];
        [self.view addSubview:navBarView];
        navBarView.backgroundColor = [UIColor whiteColor];
        [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 63.5, YYWidthScreen, 0.5) andView:navBarView];
//        2342
        CGFloat btnW = 11.5 + YY18WidthMargin * 2;
        CGFloat btnH = 44;
        UIButton *btn = [YYPugongyingTool createBtnWithFrame:CGRectMake(0, 20, btnW, btnH) superView:navBarView backgroundImage:nil titleColor:nil title:nil];
        [btn setImage:[UIImage imageNamed:@"navigation_previous"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //增加标题Label
        CGFloat labelX = btnW;
        CGFloat labelH = 44;
        CGFloat labelW = YYWidthScreen - 2 * labelX;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 20, labelW, labelH)];
        label.text = @"用户使用协议";
        label.textAlignment = NSTextAlignmentCenter;
        [navBarView addSubview:label];
        
        //添加UIWebView
        CGFloat webViewH = YYHeightScreen;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, YYWidthScreen, webViewH)];
        NSURL *url = [NSURL URLWithString:@"http://www.sxeto.com/App/dandelion/admin/agreement"];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
        webView.delegate = self;
    }
    return self;
}
/**
 *  从设置页面进入
 */
- (instancetype)initWithFromSet{
    if (self = [super init]) {
        //添加UIWebView
        CGFloat webViewH = YYHeightScreen;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, webViewH)];
        NSURL *url = [NSURL URLWithString:@"http://www.sxeto.com/App/dandelion/admin/agreement"];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
        webView.delegate = self;
        
        self.title = @"用户使用协议";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark 返回按钮被点击
- (void)previousBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    YYLog(@"网页开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    YYLog(@"网页加载结束");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    YYLog(@"网页加载失败%@",error);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
