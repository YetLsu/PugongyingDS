//
//  YYWebViewController.m
//  pugongying
//
//  Created by wyy on 16/3/4.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYWebViewController.h"
#import "YYInformationModel.h"
#import "YYInformationCommentController.h"
#import "YYPullDownMenuView.h"

#import "YYNewsCategoryModel.h"

#import "YYLoginRegisterViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "YYNavigationController.h"


#define YYAddNewsSuccess @"YYAddNewsSuccess"
@interface YYWebViewController ()<UIWebViewDelegate, YYPullDownMenuViewDelegate>{
    /**
     *  yes表示隐藏下拉菜单，no表示显示下拉菜单
     */
    BOOL _MenuHidden;
    NSString *_categoryID;
    CGFloat _menuViewW;
    CGFloat _menuViewH;
    CGFloat _cellH;
    CGFloat _menuViewEndX;
    CGFloat _menuViewEndY;
    CGFloat _menuViewStartX;
    CGFloat _menuViewStartY;
    CGFloat _topMargin;
}
/**
 *  资讯的模型
 */
@property (nonatomic, strong) YYInformationModel *model;
/**
 *  评论按钮上评论数量label
 */
@property (nonatomic, weak) UILabel *commentNumLabel;
/**
 *  点击下拉菜单出现的view
 */
@property (nonatomic, strong) YYPullDownMenuView *menuView;
/**
 * 分享后遮挡的View
 */
@property (nonatomic, strong) UIView *shareCoverView;
@end

@implementation YYWebViewController
- (instancetype)initWithModel:(YYInformationModel *)model andnewsCategoryID:(NSString *)categoryID{
    if (self = [super init]) {
        _categoryID = categoryID;
        
        [self setViewHeight];
        
        //设置title
        [self setControllerTitleWithCategoryID:categoryID];
        self.model = model;
        self.view.backgroundColor = [UIColor whiteColor];
        
        //增加顶部右边的加号按钮
        UIImage *addImage = [UIImage imageNamed:@"home_information_add"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[addImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnOnNewsClick)];
        
        [self.view addSubview:self.menuView];
    }
    return self;
}
- (void)setViewHeight{
    _topMargin = 7;
    _MenuHidden = YES;
    _cellH = 50;
    _menuViewW = 120;
    _menuViewH = _topMargin + _cellH * 2;
    CGFloat rightMargin = 11;
    _menuViewEndX = YYWidthScreen - rightMargin - _menuViewW;;
    _menuViewEndY = 66;
    _menuViewStartX = YYWidthScreen - rightMargin;
    _menuViewStartY = 64;
}
/**
 *  懒加载点击下拉菜单出现的View
 */
- (YYPullDownMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[YYPullDownMenuView alloc] initWithFrame:CGRectMake(_menuViewStartX, _menuViewStartY, 0, 0) andCellHeight:_cellH];
        _menuView.alpha = 0;
        _menuView.delegate = self;
    }
    return _menuView;
}

/**
 *  右上角的加号按钮被点击
 */
- (void)addBtnOnNewsClick{
    YYLog(@"右上角的加号按钮被点击");
    if (_MenuHidden) {//下拉菜单本来是隐藏的
        [UIView animateWithDuration:0.5 animations:^{
            self.menuView.frame = CGRectMake(_menuViewEndX, _menuViewEndY, _menuViewW, _menuViewH);
            self.menuView.alpha = 1;
            _MenuHidden = NO;
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.menuView.frame = CGRectMake(_menuViewStartX, _menuViewStartY, 0, 0);
            self.menuView.alpha = 0;
            _MenuHidden = YES;
        }];
    }
    
}
/**
 *  设置title
 */
- (void)setControllerTitleWithCategoryID:(NSString *)categoryID{
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:YYNewsCategoryArrayPath];
    NSArray *newsCategoryArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
   
    if ([categoryID isEqualToString:@"0"]) {
        self.title = @"推荐";
    }
    else{
        int i = categoryID.intValue;
        YYNewsCategoryModel *model = newsCategoryArray[i - 1];
        
        self.title = model.newsCategoryName;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //增加底部的按钮条
    CGFloat bottomViewH = 49;
    CGFloat bottomViewW = YYWidthScreen;
    CGFloat bottomViewY = YYHeightScreen - bottomViewH;
    [self addBottomViewWithFrame:CGRectMake(0, bottomViewY, bottomViewW, bottomViewH)];
    
    //添加UIWebView
    CGFloat webViewH = YYHeightScreen - bottomViewH - 64;
    [self addWebViewWithFrame:CGRectMake(0, 64, YYWidthScreen, webViewH)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCommentUploadCommentNum) name:YYAddNewsSuccess object:nil];
}
/**
 *  添加UIWebView
 */
- (void)addWebViewWithFrame:(CGRect)webViewFrame{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:self.model.weburl];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [webView loadRequest:request];
    
    webView.delegate = self;

}
/**
 *  增加评论成功
 */
- (void)addCommentUploadCommentNum{
    NSInteger commentNumber = self.model.commentnum.integerValue;
    commentNumber += 1;
    if (self.model.commentnum == 0) {
        self.commentNumLabel.text = nil;
        self.commentNumLabel.backgroundColor = [UIColor clearColor];
    }
    else if (commentNumber >= 99){
        self.commentNumLabel.text = @"99";
    }
    else{
        self.commentNumLabel.text = [NSString stringWithFormat:@"%ld",(long)commentNumber];
    }
    
}
#pragma mark 增加底部的按钮条
- (void)addBottomViewWithFrame:(CGRect)bottomFrame{
   
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
     //在底部View的上面增加线
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:bottomView];
    
//    增加中间的评论按钮
    CGFloat commentBtnW = bottomFrame.size.height;
    CGFloat commentBtnH = bottomFrame.size.height;
    CGFloat commentBtnX = (YYWidthScreen - commentBtnW)/2.0;
    CGFloat commentBtnY = 0;
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH)];
    [bottomView addSubview:commentBtn];
    commentBtn.imageView.contentMode = UIViewContentModeCenter;
    [commentBtn setImage:[UIImage imageNamed:@"home_information_6"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //在评论按钮上增加消息label
    CGFloat numberLabelX = commentBtn.center.x;
    CGFloat numberLabelY = commentBtn.centerY - 15;
    CGFloat numberLabelH = 10;
    CGFloat numberLabelW = 15;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberLabelX, numberLabelY, numberLabelW, numberLabelH)];
    [bottomView addSubview:numberLabel];
    self.commentNumLabel = numberLabel;
    
    numberLabel.backgroundColor = [UIColor whiteColor];
    NSInteger commentNumber = self.model.commentnum.integerValue;
    if (commentNumber == 0) {
        numberLabel.text = nil;
        numberLabel.backgroundColor = [UIColor clearColor];
    }
    else if (commentNumber >= 99){
        numberLabel.text = @"99";
    }
    else{
        numberLabel.text = self.model.commentnum;
    }

    numberLabel.font = [UIFont systemFontOfSize:11];

    numberLabel.textAlignment = NSTextAlignmentCenter;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.menuView.frame = CGRectMake(_menuViewStartX, _menuViewStartY, 0, 0);
    _MenuHidden = YES;
}

/**
 *  评论按钮被点击
 */
- (void)commentBtnClick{
   
    YYInformationCommentController *information = [[YYInformationCommentController alloc] initWithStyle:UITableViewStyleGrouped andModel:self.model];
    [self.navigationController pushViewController:information animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *   @"收藏"
 *   @"分享"
 */
- (void)pullDownMenuViewCellClickWithCellText:(NSString *)cellText{
    if ([cellText isEqualToString:@"收藏"]) {
        [self collectNewsClick];
    }
    else if ([cellText isEqualToString:@"分享"]) {
        [self shareNewsClick];
    }
}
/**
 *  收藏文章
 */
- (void)collectNewsClick{
    YYLog(@"收藏文章");
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        [self registerLoginBtnClick];
        return;
    }
    [MBProgressHUD showMessage:@"正在收藏资讯"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"14";
    parameters[@"newsid"] = self.model.newsID;
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    request.HTTPMethod = @"POST";
    NSError *error = nil;
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"收藏资讯失败"];
        return;
    }
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        if (connectionError) {
            YYLog(@"发送请求失败%@",connectionError);
            [MBProgressHUD showError:@"收藏资讯失败"];
            return;
        }
        
        NSError *conError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&conError];
        if (conError) {
            [MBProgressHUD showError:@"收藏资讯失败"];
            return;
        }
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"成功收藏该资讯"];
        }
        else if ([dic[@"msg"] isEqualToString:@"error_exist"]){
            [MBProgressHUD showError:@"已收藏该资讯"];
        }
        YYLog(@"%@",dic);
    }];
}
/**
 *  分享文章
 */
- (void)shareNewsClick{
//    YYLog(@"分享文章");
    NSString *imageUrl = self.model.showimgurl;
    NSString *newsUrl = self.model.weburl;
    NSArray* imageArray = @[imageUrl];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"蒲公英电商查看最新资讯"
                                         images:@[imageUrl]
                                            url:[NSURL URLWithString:newsUrl]
                                          title:self.model.title
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
                           [[[UIApplication sharedApplication].windows lastObject] addSubview:self.shareCoverView];
                       }
                       else{
                           [self.shareCoverView removeFromSuperview];
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
/**
 *  分享后遮挡的View
 */
- (UIView *)shareCoverView{
    if (!_shareCoverView) {
        _shareCoverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.centerX = YYWidthScreen / 2.0;
        activityView.centerY = YYHeightScreen / 2.0;
        activityView.width = 50;
        activityView.height = 50;
        UIColor *coverColor = [UIColor blackColor];
        _shareCoverView.backgroundColor = [coverColor colorWithAlphaComponent:0.5];
        [_shareCoverView addSubview:activityView];
        [activityView startAnimating];
    }
    return _shareCoverView;
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
