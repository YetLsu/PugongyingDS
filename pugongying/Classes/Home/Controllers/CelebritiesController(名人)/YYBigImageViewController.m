//
//  YYBigImageViewController.m
//  pugongying
//
//  Created by wyy on 16/3/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYBigImageViewController.h"
#import "YYMagazineModel.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface YYBigImageViewController ()<UIWebViewDelegate>
/**
 *  名人模型
 */
@property (nonatomic, strong)YYMagazineModel *model;

@property (strong, nonatomic) NSURLCache *urlCache;

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) NSMutableURLRequest *request;

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation YYBigImageViewController

#pragma mark 返回按钮或分享按钮被点击
- (void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareMagazineBtnClick{
    YYLog(@"分享按钮被点击");
    //    YYLog(@"分享文章");
    NSString *imageUrl = self.model.magazineShowimgurl;
    NSString *newsUrl = self.model.magazineWebUrl;
    NSArray* imageArray = @[imageUrl];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"蒲公英电商查看最新资讯"
                                         images:@[imageUrl]
                                            url:[NSURL URLWithString:newsUrl]
                                          title:self.model.magazineTitle
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        
        //1.2、自定义分享平台（非必要）activePlatforms
        NSMutableArray *activePlatforms = [NSMutableArray array];
        //        [activePlatforms removeAllObjects];
        
        [activePlatforms addObject:@(SSDKPlatformTypeWechat)];
        
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:activePlatforms
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       if (state == SSDKResponseStateBegin) {//显示遮挡的View
                           YYLog(@"开始分享");
                           [MBProgressHUD showMessage:@"正在分享"];
                       }
                       else{
                           [MBProgressHUD hideHUD];
                       }
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               NSString *title = nil;
                               if (platformType == SSDKPlatformSubTypeWechatFav) {
                                   title = @"收藏成功";
                               }
                               else title = @"分享成功";
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}
- (instancetype)initWithModel:(YYMagazineModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNav];
    //先放网页
//    YYLog(@"%@",self.model.contentUrl);
    CGFloat webViewH = YYHeightScreen;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, webViewH)];
    [self.view addSubview:webView];
    webView.delegate = self;
    self.webView = webView;
    //请求网址
    [self requestWebView];
    
}
#pragma mark 请求网址
- (void)requestWebView{
    self.urlCache = [NSURLCache sharedURLCache];
    self.urlCache.memoryCapacity = 4*1024*1024;
    self.urlCache.diskCapacity = 20 * 1024 * 1024;
    
    self.url = [NSURL URLWithString:self.model.magazineWebUrl];
    
    self.request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [self.webView loadRequest:self.request];
}

#pragma mark 设置导航栏
- (void)setNav{
    self.title = @"创业故事";
    
    //增加分享按钮

    UIButton *shareBtn = [[UIButton alloc] init];
    
    [shareBtn setImage:[UIImage imageNamed:@"home_movie_5"] forState:UIControlStateNormal];
    
    [shareBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    [shareBtn addTarget:self action:@selector(shareMagazineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
