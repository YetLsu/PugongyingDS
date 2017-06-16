//
//  YYOfflineYiZhenViewController.m
//  pugongying
//
//  Created by wyy on 16/3/10.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYOfflineYiZhenViewController.h"

@interface YYOfflineYiZhenViewController ()<UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic, weak) UIButton *QQBtn;
@property (nonatomic, weak) UIButton *phoneBtn;
/**
 *  是否是QQ发请求
 */
@property (nonatomic, assign) BOOL qqRequest;
@end

@implementation YYOfflineYiZhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat scale = YYHeightScreen/667.0;
    
    self.title = @"上门诊断";
    self.view.backgroundColor = [UIColor whiteColor];
    //增加蒲公英imageView
    CGFloat logoW = 174 * scale;
    CGFloat logoH = 147 * scale;
    CGFloat logoX = (YYWidthScreen - logoW)/2.0;
    CGFloat logoY = 64 + (125 - 64)/667.0*YYHeightScreen;
    UIImageView *pugongyingLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoW, logoH)];
    [self.view addSubview:pugongyingLogoImageView];
    pugongyingLogoImageView.image = [UIImage imageNamed:@"yizhen_pugongyingLogo"];
    //增加联系电话和方式ImageView576，230
    
    CGFloat phoneAddressW = 288 *scale;
    CGFloat phoneAddressH = 115 * scale;
    CGFloat phoneAddressX = (YYWidthScreen - phoneAddressW)/2.0;
    CGFloat phoneAddressY = logoY + logoH +55/667.0*YYHeightScreen;
    UIImageView *phoneAddressmageView = [[UIImageView alloc] initWithFrame:CGRectMake(phoneAddressX, phoneAddressY, phoneAddressW, phoneAddressH)];
    [self.view addSubview:phoneAddressmageView];
    phoneAddressmageView.image = [UIImage imageNamed:@"yizhen_phoneaddress"];
    //增加QQ预约按钮
    CGFloat btnW = 247 *scale;
    CGFloat btnX = (YYWidthScreen - btnW)/2.0;
    CGFloat btnH = 47 *scale;
    CGFloat btnY = phoneAddressY + phoneAddressH + 30/667.0*YYHeightScreen;
    self.QQBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH) superView:self.view backgroundImage:[UIImage imageNamed:@"yizhen_qqyuyue"] titleColor:nil title:nil];
    [self.QQBtn addTarget:self action:@selector(QQBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //增加拨号预约按钮
    CGFloat phoneBtnY = btnY + btnH + YY12HeightMargin;
    self.phoneBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(btnX, phoneBtnY, btnW, btnH) superView:self.view backgroundImage:[UIImage imageNamed:@"yizhen_phoneyuyue"] titleColor:nil title:nil];
    [self.phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
