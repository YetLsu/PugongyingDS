//
//  YYWriteCommentViewController.m
//  pugongying
//
//  Created by wyy on 16/3/14.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  设置tag值，0为创建资讯评论控制器，1为创建的课程评论控制器
 */
#import "YYWriteCommentViewController.h"
#import "YYInformationModel.h"
#import "YYCourseCollectionCellModel.h"
#import "YYLoginRegisterViewController.h"

#import "YYNavigationController.h"

#define YYAddNewsSuccess @"YYAddNewsSuccess"

@interface YYWriteCommentViewController ()
/**
 *  资讯模型
 */
@property (nonatomic, strong) YYInformationModel *informationModel;
/**
 *  课程模型
 */
@property (nonatomic, strong) YYCourseCollectionCellModel *courseModel;
/**
 *  输入的文字
 */
@property (nonatomic, weak) UITextView *textView;
/**
 *  检测是否是第一次输入文字
 */
@property (nonatomic, assign,getter=isFirstWrite) BOOL firstWrite;
/**
 *  蒙版按钮
 */
@property (nonatomic, strong) UIButton *coverBtn;

/**
 *  设置tag值，0为创建资讯评论控制器，1为创建的课程评论控制器,2为意见反馈
 */
@property (nonatomic, assign) NSInteger tagController;
@end

static NSString *placeholderStr;
@implementation YYWriteCommentViewController
/**
 *  创建意见反馈的控制器
 */
- (instancetype)initWithOpinion{
    if (self = [super init]) {
        self.tagController = 2;
        placeholderStr = @"请输入对我们的意见";
        self.title = @"意见反馈";
    }
    return self;
}
- (instancetype)initWithInformationCommentControllerWithModel:(YYInformationModel *)model{
    if (self = [super init]) {
        self.informationModel = model;
        placeholderStr = @"请输入评论内容";
        self.title = @"评论";
        self.tagController = 0;
    }
    return self;
}
/**
 *  创建课程的评论
 */
- (instancetype) initWithCourseCommentControllerWithModel:(YYCourseCollectionCellModel *)model{
    if (self = [super init]) {
        self.courseModel = model;
        placeholderStr = @"请输入评论内容";
        self.title = @"评论";
        self.tagController = 1;
    }
    return self;
}

/**
 *  蒙版按钮懒加载
 */
- (UIButton *)coverBtn{
    if (!_coverBtn) {
        CGFloat textViewH = 160;
        CGFloat textViewY = YY12HeightMargin + 64;
        CGFloat tableViewY =textViewY + textViewH;
        CGFloat tableViewH = YYHeightScreen -tableViewY;
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableViewY, YYWidthScreen, tableViewH)];
        _coverBtn.backgroundColor = [UIColor clearColor];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _coverBtn;
}
//蒙版按钮被点击
- (void)coverBtnClick{
    [self.coverBtn removeFromSuperview];
    [self.textView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //增加提交按钮
    [self addPostBtn];
    
    //增加输入框
    CGFloat textViewH = 400;
    CGFloat textViewW = YYWidthScreen - 2 * YY18WidthMargin;
    CGFloat textViewY = YY12HeightMargin + 64;
    [self addTextViewWithFrame:CGRectMake(YY18WidthMargin, textViewY, textViewW, textViewH)];
    
}
#pragma mark 监听输入框的方法
/**
 *  输入框开始输入
 */
- (void)beginWrite1{
    //    YYLog(@"beginWrite");
    if (self.isFirstWrite) return;
    
    self.textView.text = nil;
    self.textView.textColor = [UIColor blackColor];
    
}
/**
 *  输入框正在输入
 */
- (void)nowWrite1{
    //    YYLog(@"输入框正在输入");
    self.firstWrite = YES;
}
/**
 *  输入框结束输入
 */
- (void)endWrite1{
    //    YYLog(@"结束输入");
    if (self.firstWrite) return;
    
    self.textView.text = placeholderStr;
    self.textView.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
}

#pragma mark 增加取消和下一步按钮
- (void)addPostBtn{
    //增加提交按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn sizeToFit];
    [nextBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
}
#pragma mark 增加输入框
- (void)addTextViewWithFrame:(CGRect)textViewFrame{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [self.view addSubview:textView];
    self.textView = textView;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.text = placeholderStr;
    self.textView.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
    //监听输入框开始输入文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginWrite1) name:UITextViewTextDidBeginEditingNotification object:nil];
    //监听输入框正在输入文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowWrite1) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endWrite1) name:UITextViewTextDidEndEditingNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.returnKeyType = UIReturnKeyDone;
    //添加遮盖层
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}
/**
 *  键盘弹出添加遮盖层
 */
- (void)keyboardWillShow{
    [self.view addSubview:self.coverBtn];
}
/**
 *  提交按钮被点击
 */
- (void)postBtnClick{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        //去登录页面
        [self registerLoginBtnClick];
        return;
        
    }
    
    if (!self.isFirstWrite) {
        [MBProgressHUD showError:@"请先填写评论" toView:self.view];
        return;
    }
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    request.HTTPMethod = @"POST";
    
    
   
    if (self.tagController == 0) {//0为创建资讯评论控制器
        [self informationPostWithRequest:request];
    }
    else if (self.tagController == 1){//1为创建的课程评论控制器
        [self coursePostWithRequest:request];
    }
    else if (self.tagController == 2){//2为意见反馈
        [self opinionPostWithRequest:request];
    }
}
#pragma mark 2为意见反馈
- (void)opinionPostWithRequest:(NSMutableURLRequest *)request{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"8";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults]objectForKey:YYUserID];
    parameters[@"content"] = self.textView.text;
  
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    YYLog(@"%@",error);
    
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            [MBProgressHUD showError:@"网络连接失败"];
            return ;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YYLog(@"%@",dict);
        if ([dict[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"已接收到您的建议"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([dict[@"msg"] isEqualToString:@"error_exsit"]){
            [MBProgressHUD showError:@"今天已经提交过建议，请明天再提交"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}
#pragma mark 1为创建的课程评论控制器
- (void)coursePostWithRequest:(NSMutableURLRequest *)request{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"13";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults]objectForKey:YYUserID];
    parameters[@"courseid"] = self.courseModel.courseID;

    parameters[@"content"] = self.textView.text;
    YYLog(@"%@评论内容",self.textView.text);
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    YYLog(@"%@",error);
    
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            [MBProgressHUD showError:@"网络连接失败"];
            return ;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YYLog(@"%@",dict);
        if ([dict[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"成功评论"];
            [self.navigationController popViewControllerAnimated:YES];
            //            通知资讯评论列表进行刷新
//            [[NSNotificationCenter defaultCenter] postNotificationName:YYAddCourseCommentSuccess object:self];
        }
        
    }];

}
#pragma mark 0为创建资讯评论控制器中的提交
- (void)informationPostWithRequest:(NSMutableURLRequest *)request{
    
    [MBProgressHUD showMessage:@"正在提交评论"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"13";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults]objectForKey:YYUserID];
    parameters[@"newsid"] = self.informationModel.newsID;
    YYLog(@"%@userid",[[NSUserDefaults standardUserDefaults]objectForKey:YYUserID]);
    YYLog(@"%@newsid",self.informationModel.newsID);
    NSString *content = self.textView.text;
    NSString *text = @"\n\n";
    NSString *subContent = content;
    
    while ([text isEqualToString:@"\n\n"]||[text isEqualToString:@"\r\r"]||[text isEqualToString:@"\n\r"]) {
        content = subContent;
        NSUInteger fromIndex = content.length - 2;
        text = [subContent substringFromIndex:fromIndex];
        subContent = [content substringToIndex:fromIndex];
//        YYLog(@"text=:%@",text);
//        YYLog(@"content=:%@",content);
//        YYLog(@"subContent=:%@",subContent);
    }

    parameters[@"content"] = content;
    YYLog(@"%@评论内容",self.textView.text);
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"提交评论失败"];
        return;
    }
    
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"提交评论失败"];
            return;

        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YYLog(@"返回值%@",dict);
        if ([dict[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"评论已提交"];
            [self.navigationController popViewControllerAnimated:YES];
            //            通知资讯评论列表进行刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:YYAddNewsSuccess object:self];
        }
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
