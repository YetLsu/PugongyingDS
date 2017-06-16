//
//  YYTestOldPasswordController.m
//  pugongying
//
//  Created by wyy on 16/5/23.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYTestOldPasswordController.h"
#import "YYSetPassWordViewController.h"
#import "YYGetAuthCodeController.h"

@interface YYTestOldPasswordController ()
/**
 *  懒加载输原密码的View
 */
@property (nonatomic, strong) UIButton *passwordView;
/**
 *  密码TextField
 */
@property (nonatomic, weak) UITextField *passwordTextField;
@end

@implementation YYTestOldPasswordController
#pragma mark 懒加载输原密码的View
- (UIButton *)passwordView{
    if (!_passwordView) {
        CGFloat viewH = YYHeightScreen - 64;
        _passwordView = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, YYWidthScreen, viewH)];
        _passwordView.backgroundColor = [UIColor whiteColor];
        
        //增加顶部的Label
        CGFloat labelHeight = 40;
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, labelHeight)];
        topLabel.text = @"请输入原密码";
        topLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:15.0];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [_passwordView addSubview:topLabel];
        
        //        增加输入框
        CGFloat labelY = labelHeight + YY12HeightMargin/2.0;
        CGFloat marginX = 40/375.0 *YYWidthScreen;
        CGFloat labelH = 40;
        CGFloat textFieldW = YYWidthScreen - 2 * marginX;
        //密码输入框
        self.passwordTextField = [self createTextFieldWithFrame:CGRectMake(marginX, labelY, textFieldW, labelH) addToView:_passwordView andPlaceholder:@"原密码"];
        self.passwordTextField.secureTextEntry = YES;
        
        //增加忘记密码按钮
        CGFloat btnW = 60;
        CGFloat btnH = 40 / 667.0 * YYHeightScreen;
        CGFloat btnX = YYWidthScreen - btnW - marginX;
        CGFloat btnY = labelY + labelH + YY12HeightMargin;
        [self addForgetPassWordBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];

        //增加确认按钮
        CGFloat finishBtnY = btnY + btnH +YY10HeightMargin;
        CGFloat finishBtnW = textFieldW;
        
        UIButton *finishBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(marginX, finishBtnY, finishBtnW, labelHeight) superView:_passwordView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0] title:@"确认"];
        [finishBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_passwordView addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordView;
}
#pragma mark 增加textField到View上
- (UITextField *)createTextFieldWithFrame:(CGRect)textFrame addToView:(UIView *)superView andPlaceholder:(NSString *)placeholder{
    UITextField *textfield = [[UITextField alloc] initWithFrame:textFrame];
    [superView addSubview:textfield];
    
    textfield.placeholder = placeholder;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, textFrame.size.height - 0.5, textFrame.size.width, 0.5) andView:textfield];
    
    return textfield;
}
#pragma mark 忘记密码
/**
 *  增加忘记密码按钮
 */
- (void)addForgetPassWordBtnWithFrame:(CGRect)btnFrame{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [_passwordView addSubview:btn];
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
#pragma mark  确认按钮被点击
/**
 *  确认按钮被点击
 */
- (void)sureBtnClick{
    YYLog(@"确认按钮被点击");
    if (self.passwordTextField.text.length == 0){
        [MBProgressHUD showError:@"请输入原密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在验证中"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:YYHTTPInsertPOST] cachePolicy:1 timeoutInterval:30.0];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mode"] = @"20";
    
    YYUserModel *userModel = [YYUserTool userModel];
    parameters[@"username"] = userModel.phone;
    parameters[@"password"] = self.passwordTextField.text;
    
    NSError *bodyError = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&bodyError];
    if (bodyError) {
        YYLog(@"转换json出错，%@",bodyError);
        [MBProgressHUD showError:@"验证失败，请重新输入原密码"];
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
            YYSetPassWordViewController *setPass = [[YYSetPassWordViewController alloc] initWithUser:userModel.phone andOldPassword:self.passwordTextField.text];
            [self.navigationController pushViewController:setPass animated:YES];
        }
        else if([dic[@"msg"] isEqualToString:@"error_password"]){
            [MBProgressHUD showError:@"原密码错误"];
        }
        else{
            [MBProgressHUD showError:@"验证失败"];
        }
    }
    ];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passwordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (void)coverBtnClick{
    [self.view endEditing:YES];
}

@end
