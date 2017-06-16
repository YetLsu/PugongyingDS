//
//  YYForgetPasswordController.m
//  pugongying
//
//  Created by wyy on 16/5/23.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYGetAuthCodeController.h"
#import <SMS_SDK/SMSSDK.h>
#import "YYSetPassWordViewController.h"

@interface YYGetAuthCodeController (){
    
}
/**
 *  懒加载注册的View
 */
@property (nonatomic, strong) UIButton *registerView;
/**
 *  注册中的手机号TextField
 */
@property (nonatomic, weak) UITextField *registerPhoneTextField;
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

@implementation YYGetAuthCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码";
    [self.view addSubview:self.registerView];
}
#pragma mark 懒加载注册的View
- (UIButton *)registerView{
    if (!_registerView) {
        CGFloat viewH = YYHeightScreen - 64;
        _registerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, YYWidthScreen, viewH)];
        _registerView.backgroundColor = [UIColor whiteColor];
        
        //增加顶部的Label
        CGFloat labelHeight = 40;
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, labelHeight)];
        topLabel.text = @"通过验证码修改密码";
        topLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:15.0];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [_registerView addSubview:topLabel];
        
        //        增加输入框以及＋86Label,在验证码中增加获取验证码按钮
        CGFloat labelY = labelHeight + YY12HeightMargin/2.0;
        [self addRegisterPhoneTextFieldAndLabelWithY:labelY];
        
        //增加完成按钮
        CGFloat marginX = 40/375.0 *YYWidthScreen;
        CGFloat finishBtnY = labelY + (labelHeight +YY10HeightMargin) *2 + YY10HeightMargin * 2;
        CGFloat finishBtnW = YYWidthScreen - 2 * marginX;
        
        UIButton *finishBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(marginX, finishBtnY, finishBtnW, labelHeight) superView:_registerView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0] title:@"下一步"];
        [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [_registerView addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerView;
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
    //  增加获取验证码按钮
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
    
}

#pragma mark 增加textField到View上
- (UITextField *)createTextFieldWithFrame:(CGRect)textFrame addToView:(UIView *)superView andPlaceholder:(NSString *)placeholder{
    UITextField *textfield = [[UITextField alloc] initWithFrame:textFrame];
    [superView addSubview:textfield];
    
    textfield.placeholder = placeholder;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, textFrame.size.height - 0.5, textFrame.size.width, 0.5) andView:textfield];
    
    return textfield;
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

#pragma mark 完成按钮被点击
- (void)finishBtnClick:(UIButton *)finishBtn{
    //    YYLog(@"完成按钮被点击");
    //验证码出错，进入下一步
//    [self setPassword];
//    return;
    NSString *phone = self.registerPhoneTextField.text;
    NSString *code = self.registerAuthCodeTextField.text;
    if (phone.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    else if (code.length == 0){
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    self.authCodeBtn.enabled = YES;
    [MBProgressHUD showMessage:@"正在验证用户"];
    /**
     *  提交验证码
     *
     */
    [SMSSDK commitVerificationCode:self.registerAuthCodeTextField.text phoneNumber:phone zone:@"86" result:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (!error) {//没有错误
            //验证码没有错误，进入下一步
            [self setPassword];
        }
        else
        {
            [MBProgressHUD showError:@"验证码验证失败"];
            YYLog(@"错误信息:%@",error);
        }
    }];
}
#pragma mark 验证码出错，进入下一步
- (void)setPassword{
    YYSetPassWordViewController *setPass = [[YYSetPassWordViewController alloc] initWithUser:self.registerPhoneTextField.text andOldPassword:nil];
    [self.navigationController pushViewController:setPass animated:YES];
}
- (void)coverBtnClick{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
