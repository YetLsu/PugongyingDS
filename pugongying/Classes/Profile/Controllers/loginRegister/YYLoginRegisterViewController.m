//
//  YYLoginRegisterViewController.m
//  pugongying
//
//  Created by wyy on 16/3/11.
//  Copyright © 2016年 WYY. All rights reserved.
//
#define topViewH (242/667.0*YYHeightScreen)
#import "YYLoginRegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "YYUserTool.h"
#import "YYUserModel.h"
#import "YYXieYiWebViewController.h"
#import "YYGetAuthCodeController.h"

@interface YYLoginRegisterViewController ()
/**
 *  登录下面的线
 */
@property (nonatomic, weak) UIView *loginLineView;
/**
 *  登录按钮
 */
@property (nonatomic, weak) UIButton *loginBtn;
/**
 *  注册下面的线
 */
@property (nonatomic, weak) UIView *registerLineView;
/**
 *  注册按钮
 */
@property (nonatomic, weak) UIButton *registerBtn;
/**
 *  懒加载登录的View
 */
@property (nonatomic, strong) UIButton *loginBtnView;
/**
 *  懒加载注册的View
 */
@property (nonatomic, strong) UIButton *registerView;
/**
 *  登录中的手机号TextField
 */
@property (nonatomic, weak) UITextField *loginPhoneTextField;
/**
 *  登录中的密码TextField
 */
@property (nonatomic, weak) UITextField *loginPasswordTextField;
/**
 *  注册中的手机号TextField
 */
@property (nonatomic, weak) UITextField *registerPhoneTextField;
/**
 *  注册中的密码TextField
 */
@property (nonatomic, weak) UITextField *registerPasswordTextField;
/**
 *  注册中的确认密码TextField
 */
@property (nonatomic, weak) UITextField *registerSurePasswordTextField;
/**
 *  注册中的验证码TextField
 */
@property (nonatomic, weak) UITextField *registerAuthCodeTextField;
/**
 *  验证码按钮
 */
@property (nonatomic, weak) UIButton *authCodeBtn;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  计时
 */
@property (nonatomic, assign) int i;
@end

@implementation YYLoginRegisterViewController
- (void)coverBtnClick{
    [self.view endEditing:YES];
}

#pragma mark 懒加载登录的View
- (UIButton *)loginView{
    if (!_loginBtnView) {
        CGFloat viewH = YYHeightScreen - topViewH;
        _loginBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, topViewH, YYWidthScreen, viewH)];
        _loginBtnView.backgroundColor = [UIColor whiteColor];
        
        CGFloat textFieldX = 40/375.0 *YYWidthScreen;
        
        CGFloat textFieldW = YYWidthScreen - textFieldX * 2;
        CGFloat textFieldH = 40;
        CGFloat textFieldY = 55/667.0*YYHeightScreen;
        self.loginPhoneTextField = [self createTextFieldWithFrame:CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH) addToView:_loginBtnView andPlaceholder:@"手机号"];
        self.loginPasswordTextField = [self createTextFieldWithFrame:CGRectMake(textFieldX, textFieldY + textFieldH + YY12HeightMargin * 3, textFieldW, textFieldH) addToView:_loginBtnView andPlaceholder:@"密码"];
        self.loginPasswordTextField.secureTextEntry = YES;
        
        CGFloat btnW = 60;
        CGFloat btnH = 40 / 667.0 * YYHeightScreen;
        CGFloat btnX = YYWidthScreen - btnW - textFieldX;
        CGFloat btnY = textFieldY + textFieldH * 2 + YY12HeightMargin * 3;
        //增加忘记密码按钮
        [self addForgetPassWordBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        //增加登录按钮
        CGFloat loginBtnY = textFieldY + textFieldH * 2 + YY10HeightMargin *10;
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(textFieldX, loginBtnY, textFieldW, textFieldH)];
        [_loginBtnView addSubview:loginBtn];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginUserBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        
        [_loginBtnView addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtnView;
}
#pragma mark 忘记密码
/**
 *  增加忘记密码按钮
 */
- (void)addForgetPassWordBtnWithFrame:(CGRect)btnFrame{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [_loginBtnView addSubview:btn];
    [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn setTitleColor:YYBlueTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];

    [btn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  忘记密码被点击
 */
- (void)forgetBtnClick{
    YYLog(@"忘记密码被点击");
    YYGetAuthCodeController *forget =[[YYGetAuthCodeController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
    
}
#pragma mark 登录按钮被点击
- (void)loginUserBtnClcik:(UIButton *)loginBtn{
   
    if (self.loginPhoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
        return;
    }
    else if (self.loginPasswordTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登录中"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:YYHTTPInsertPOST] cachePolicy:1 timeoutInterval:30.0];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mode"] = @"20";
    parameters[@"username"] = self.loginPhoneTextField.text;
    parameters[@"password"] = self.loginPasswordTextField.text;
    
    NSError *bodyError = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&bodyError];
    if (bodyError) {
        YYLog(@"转换json出错，%@",bodyError);
        [MBProgressHUD showError:@"登录失败，请重新登录"];
        return;
    }
    
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        if (connectionError) {//-1099
            if (connectionError.code == -1009) {
                [MBProgressHUD showError:@"网络连接失败，请检查网络连接"];
            }
            YYLog(@"%ld",(long)connectionError.code);
            return;

        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YYLog(@"返回值%@",dic);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"userid"] forKey:YYUserID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self selectUserMessageWithUserid:dic[@"userid"]];
            
        }
        else if ([dic[@"msg"] isEqualToString:@"error_none"]){
           
            [MBProgressHUD showError:@"该用户不存在" toView:self.view];
           
            
        }
        else{
           
            [MBProgressHUD showError:@"用户名或密码错误" toView:self.view];
        }
        
//        YYLog(@"%@",dic);
    }];
    YYLog(@"登录按钮被点击");
}
#pragma mark 获取用户信息
- (void)selectUserMessageWithUserid:(NSString *)userId{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"11";
    parameters[@"userid"] = userId;
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//查询用户信息成功
            NSDictionary *ret = responseObject[@"ret"];
            
            YYUserModel *userModel = [[YYUserModel alloc] init];
            
            [userModel setValuesForKeysWithDictionary:ret];
            
            [YYUserTool saveUserModelWithModel:userModel];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:YYUserLoginApp object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                [MBProgressHUD showSuccess:@"登录成功"];
            }];
        }
    }];
}
#pragma mark 增加textField到View上
- (UITextField *)createTextFieldWithFrame:(CGRect)textFrame addToView:(UIView *)superView andPlaceholder:(NSString *)placeholder{
    UITextField *textfield = [[UITextField alloc] initWithFrame:textFrame];
    [superView addSubview:textfield];
    
    textfield.placeholder = placeholder;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, textFrame.size.height - 0.5, textFrame.size.width, 0.5) andView:textfield];
    
    return textfield;
}
#pragma mark 懒加载注册的View
- (UIButton *)registerView{
    if (!_registerView) {
        CGFloat viewH = YYHeightScreen - topViewH;
        _registerView = [[UIButton alloc] initWithFrame:CGRectMake(0, topViewH, YYWidthScreen, viewH)];
        _registerView.backgroundColor = [UIColor whiteColor];
        
        //增加顶部的Label
        CGFloat labelHeight = 40;
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, labelHeight)];
        topLabel.text = @"注册成为蒲公英用户，享受专业的电商指导";
        topLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:15.0];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [_registerView addSubview:topLabel];
        
//        增加输入框以及＋86Label,在验证码中增加获取验证码按钮
        CGFloat labelY = labelHeight + YY12HeightMargin/2.0;
        [self addRegisterPhoneTextFieldAndLabelWithY:labelY];
        
        //增加完成按钮
        CGFloat marginX = 40/375.0 *YYWidthScreen;
        CGFloat finishBtnY = labelY + (labelHeight +YY10HeightMargin) *4 + YY10HeightMargin * 2;
        CGFloat finishBtnW = YYWidthScreen - 2 * marginX;

       UIButton *finishBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(marginX, finishBtnY, finishBtnW, labelHeight) superView:_registerView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0] title:@"完成"];
        [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //增加注册代表你已同意label
        CGFloat registerAgreeLabelY = finishBtnY + labelHeight + 3 *YY10HeightMargin;
        UILabel *registerAgreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, registerAgreeLabelY, YYWidthScreen, 20)];
        [_registerView addSubview:registerAgreeLabel];
        
        registerAgreeLabel.text = @"注册代表你已同意";
        registerAgreeLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        registerAgreeLabel.font = [UIFont systemFontOfSize:13];
        registerAgreeLabel.textAlignment = NSTextAlignmentCenter;
        
        //增加使用协议按钮
        CGFloat xieyiBtnY = registerAgreeLabelY + 20;
        UIButton *xieyiBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, xieyiBtnY, YYWidthScreen, 20)];
        [xieyiBtn setTitleColor:[UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0] forState:UIControlStateNormal];
        [xieyiBtn setTitle:@"蒲公英APP使用协议和隐私条款" forState:UIControlStateNormal];
        [_registerView addSubview:xieyiBtn];
        [xieyiBtn addTarget:self action:@selector(xieyiBtnClick) forControlEvents:UIControlEventTouchUpInside];
        xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        [_registerView addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerView;
}
#pragma mark 协议按钮被点击
- (void)xieyiBtnClick{
   
    YYXieYiWebViewController *xieyiWeb = [[YYXieYiWebViewController alloc] initWithFromRegister];
    [self presentViewController:xieyiWeb animated:YES completion:nil];
}
#pragma mark 完成按钮被点击
- (void)finishBtnClick:(UIButton *)finishBtn{
//    YYLog(@"完成按钮被点击");

    NSString *phone = self.registerPhoneTextField.text;
    NSString *code = self.registerAuthCodeTextField.text;
    NSString *firstPassword = self.registerPasswordTextField.text;
    NSString *secondPassword = self.registerSurePasswordTextField.text;
    if (phone.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    else if (code.length == 0){
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    else if (firstPassword.length == 0){
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    else if (secondPassword.length == 0){
        [MBProgressHUD showError:@"请再次输入密码"];
        return;
    }
    
    else if (![firstPassword isEqualToString:secondPassword]) {
        [MBProgressHUD showError:@"两次密码不同" toView:self.view];
        return;
    }
    else{
        YYLog(@"两次密码一致");
    }
    self.authCodeBtn.enabled = YES;
    [MBProgressHUD showMessage:@"正在注册新用户"];
    /**
     *  提交验证码
     *
     */
    [SMSSDK commitVerificationCode:self.registerAuthCodeTextField.text phoneNumber:phone zone:@"86" result:^(NSError *error) {
        
        if (!error) {//没有错误
            //去注册用户
            [self registerUserAndPhone:phone password:firstPassword finishBtn:finishBtn];
        }
        else
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"注册失败"];
            YYLog(@"错误信息:%@",error);
        }
    }];
}
#pragma mark 去注册用户
- (void)registerUserAndPhone:(NSString *)phone password:(NSString *)password finishBtn:(UIButton *)finishBtn{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:YYHTTPInsertPOST]cachePolicy:1 timeoutInterval:10.0];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mode"] = @"10";
    parameters[@"username"] = phone;
    parameters[@"password"] = password;
    
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        YYLog(@"%@打包json出错",error);
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"注册失败"];
            YYLog(@"%@发送出错",connectionError);
        }
        NSError *returnError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&returnError];
        if (returnError) {
            [MBProgressHUD showError:@"注册失败"];
            YYLog(@"%@解析出错",returnError);
        }
        YYLog(@"%@",dic);

        if ([dic[@"msg"] isEqualToString:@"error_exsit"]) {
            [MBProgressHUD showError:@"该用户已存在"];
        }
        else if ([dic[@"msg"] isEqualToString:@"ok"]){
            //保存用户ID到配置文件
            NSString *userID = dic[@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:YYUserID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self selectUserMessageWithUserid:dic[@"userid"]];

            [MBProgressHUD showSuccess:@"成功注册"];
            
        }
    }];
}
#pragma mark 键盘弹出收回
- (void)keyboardWillShow{
    self.loginView.y = 64;
    self.registerView.y = 64;
}
- (void)keyboardWillHidden{
    self.loginView.y = topViewH;
    self.registerView.y = topViewH;

}
/**
 *  增加输入框以及＋86Label,在验证码中增加获取验证码按钮
 */
- (void)addRegisterPhoneTextFieldAndLabelWithY:(CGFloat)labelY{
    CGFloat marginX = 40/375.0 *YYWidthScreen;
    CGFloat labelW = 45;
    CGFloat labelH = 40;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, labelY, labelW, labelH)];
    numberLabel.textColor = [UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0];
    numberLabel.text = @"+86";
    [_registerView addSubview:numberLabel];
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, labelH - 0.5, labelW, 0.5) andView:numberLabel];
    //增加竖线
    CGFloat lineH = 16;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(labelW - 5.5, (labelH - lineH)/2.0, 0.5, lineH) andView:numberLabel];
    //增加手机号输入框
    self.registerPhoneTextField = [self createTextFieldWithFrame:CGRectMake(marginX + labelW, labelY, YYWidthScreen - 2 *marginX - labelW, labelH) addToView:_registerView andPlaceholder:@"手机号"];
    
    //增加验证码输入框
    CGFloat textFieldW = YYWidthScreen - marginX * 2;
    self.registerAuthCodeTextField = [self createTextFieldWithFrame:CGRectMake(marginX, labelY + labelH +YY10HeightMargin, textFieldW, labelH) addToView:_registerView andPlaceholder:@"验证码"];
//    增加获取验证码按钮
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = textFieldW - btnW;
    CGFloat btnY = 5;
    UIButton *authCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [self.registerAuthCodeTextField addSubview:authCodeBtn];
    self.authCodeBtn = authCodeBtn;
    
    [authCodeBtn setBackgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] forState:UIControlStateNormal];
    [authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0] forState:UIControlStateNormal];
    authCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [authCodeBtn addTarget:self action:@selector(authCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //密码输入框
    self.registerPasswordTextField = [self createTextFieldWithFrame:CGRectMake(marginX, labelY + (labelH +YY10HeightMargin) *2, textFieldW, labelH) addToView:_registerView andPlaceholder:@"密码"];
    self.registerPasswordTextField.secureTextEntry = YES;
    
    //确认输入框
    self.registerSurePasswordTextField = [self createTextFieldWithFrame:CGRectMake(marginX, labelY + (labelH +YY10HeightMargin) *3, textFieldW, labelH) addToView:_registerView andPlaceholder:@"确认密码"];
    self.registerSurePasswordTextField.secureTextEntry = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置顶部的View
    [self addTopView];
    
    [self loginBtnClick];
}
#pragma mark 验证码按钮被点击
- (void)authCodeBtnClick{
   
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    if (self.registerPhoneTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    [MBProgressHUD showMessage:@"正在发送验证码"];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.registerPhoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
        if (!error) {
             self.authCodeBtn.enabled = NO;
//            YYLog(@"获取验证码成功");
            [MBProgressHUD showSuccess:@"验证码已发送"];
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            self.timer = timer;
            
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            self.i = 60;
            
            [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",self.i] forState:UIControlStateDisabled];
            
            
        }
        else{
            
            [MBProgressHUD showError:@"验证码发送失败"];
        }
    }];

}
#pragma mark 定时器动作
- (void)timerAction{
    self.i--;
    
    if (self.i == 0) {
        [self.timer invalidate];
        self.authCodeBtn.enabled = YES;
    }
    [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",self.i] forState:UIControlStateDisabled];
    
}
#pragma mark 设置顶部的View
- (void)addTopView{
    //添加顶部的View

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, topViewH)];
    [self.view addSubview:topView];
    //增加图片
    UIImageView *topIV = [[UIImageView alloc] initWithFrame:topView.bounds];
    topIV.image = [UIImage imageNamed:@"profile_logintopBG"];
    [topView addSubview:topIV];
    
    //在图片上增加蒲公英的Logo
    CGFloat logoW = 125;
    CGFloat logoH = 106;
    CGFloat logoX = (YYWidthScreen - logoW)/2.0;
    CGFloat logoY = (topViewH - logoH)/2.0;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoW, logoH)];
    logoView.image = [UIImage imageNamed:@"profile_pugongyingLOGO"];
    [topView addSubview:logoView];
    
    //增加左边的取消按钮
    
    CGFloat cancelBtnW = 20 + 10;
    CGFloat cancelBtnH = 44;
    CGFloat cancelBtnX = YY18WidthMargin - 5;
    CGFloat cancelBtnY = 20;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH)];
    [cancelBtn setImage:[UIImage imageNamed:@"profile_cancel"] forState:UIControlStateNormal];
    cancelBtn.imageView.contentMode = UIViewContentModeCenter;
    [topView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加注册和登录按钮
    CGFloat btnH = 13 * 2 + 16;
    CGFloat btnY = topViewH - btnH;
    CGFloat btnW = 70;
    CGFloat marginW = (YYWidthScreen - btnW * 2)/4.0;
    self.loginLineView = [self addBtnToTopView:topView andBtnFrame:CGRectMake(marginW, btnY, btnW, btnH) andSEL:@selector(loginBtnClick) andTitle:@"登录" andIndex:0];
    self.registerLineView = [self addBtnToTopView:topView andBtnFrame:CGRectMake(marginW * 3+ btnW, btnY, btnW, btnH) andSEL:@selector(registerBtnClick) andTitle:@"注册" andIndex:1];
}
#pragma mark 增加一个按钮并设置
- (UIView *)addBtnToTopView:(UIView *)topView andBtnFrame:(CGRect)btnFrame andSEL:(SEL)section andTitle:(NSString *)title andIndex:(NSInteger) index{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    [topView addSubview:btn];
    [btn addTarget:self action:section forControlEvents:UIControlEventTouchUpInside];
    if (index == 0) {
        self.loginBtn = btn;
    }
    else if (index == 1){
        self.registerBtn = btn;
    }
    
    CGFloat lineY = btnFrame.size.height - 4;
    CGFloat lineW = btnFrame.size.width;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, lineW, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [btn addSubview:lineView];
    lineView.hidden = YES;
    
    return lineView;
}
#pragma mark 上面的登录按钮被点击
- (void)loginBtnClick{
    self.loginLineView.hidden = NO;
    self.registerLineView.hidden = YES;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.registerBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    
    [self.registerView removeFromSuperview];
    
    [self.view addSubview:self.loginView];
}
#pragma mark 上面的注册按钮被点击
- (void)registerBtnClick{
    self.loginLineView.hidden = YES;
    self.registerLineView.hidden = NO;
    [self.loginBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.loginView removeFromSuperview];
    [self.view addSubview:self.registerView];
}
#pragma mark 取消按钮被点击
- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
