//
//  YYSetPassWordViewController.m
//  pugongying
//
//  Created by wyy on 16/5/23.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYSetPassWordViewController.h"


@interface YYSetPassWordViewController (){
    NSString *_user;
    NSString *_oldPassword;
}
/**
 *  懒加载注册的View
 */
@property (nonatomic, strong) UIButton *registerView;
/**
 *  注册中的密码TextField
 */
@property (nonatomic, weak) UITextField *registerPasswordTextField;
/**
 *  注册中的确认密码TextField
 */
@property (nonatomic, weak) UITextField *registerSurePasswordTextField;
@end

@implementation YYSetPassWordViewController
- (instancetype)initWithUser:(NSString *)user andOldPassword:(NSString *)oldPassword{
    if (self = [super init]) {
        _user = user;
        _oldPassword = oldPassword;
    }
    return self;
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
        topLabel.text = @"请输入新密码";
        topLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:15.0];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [_registerView addSubview:topLabel];
        
        //        增加输入框
        CGFloat labelY = labelHeight + YY12HeightMargin/2.0;
        CGFloat marginX = 40/375.0 *YYWidthScreen;
        CGFloat labelH = 40;
        CGFloat textFieldW = YYWidthScreen - 2 * marginX;
        //密码输入框
        self.registerPasswordTextField = [self createTextFieldWithFrame:CGRectMake(marginX, labelY, textFieldW, labelH) addToView:_registerView andPlaceholder:@"密码"];
        self.registerPasswordTextField.secureTextEntry = YES;
        
        //确认输入框
        self.registerSurePasswordTextField = [self createTextFieldWithFrame:CGRectMake(marginX, labelY + labelH +YY10HeightMargin, textFieldW, labelH) addToView:_registerView andPlaceholder:@"确认密码"];
        self.registerSurePasswordTextField.secureTextEntry = YES;
        
        //增加修改密码按钮
        CGFloat finishBtnY = labelY + (labelHeight +YY10HeightMargin) *2 + YY10HeightMargin * 2;
        CGFloat finishBtnW = textFieldW;
        
        UIButton *finishBtn = [YYPugongyingTool createBtnWithFrame:CGRectMake(marginX, finishBtnY, finishBtnW, labelHeight) superView:_registerView backgroundImage:[UIImage imageNamed:@"profile_loginBtnBg"] titleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0] title:@"修改密码"];
        [finishBtn addTarget:self action:@selector(setPasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_registerView addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerView;
}
#pragma mark 增加textField到View上
- (UITextField *)createTextFieldWithFrame:(CGRect)textFrame addToView:(UIView *)superView andPlaceholder:(NSString *)placeholder{
    UITextField *textfield = [[UITextField alloc] initWithFrame:textFrame];
    [superView addSubview:textfield];
    
    textfield.placeholder = placeholder;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, textFrame.size.height - 0.5, textFrame.size.width, 0.5) andView:textfield];
    
    return textfield;
}
#pragma mark 修改密码按钮被点击
- (void)setPasswordBtnClick{
    NSString *firstPassword = self.registerPasswordTextField.text;
    NSString *secondPassword = self.registerSurePasswordTextField.text;
    if (firstPassword.length == 0){
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    else if (secondPassword.length == 0){
        [MBProgressHUD showError:@"请确认密码"];
        return;
    }
    
    else if (![firstPassword isEqualToString:secondPassword]) {
        [MBProgressHUD showError:@"两次密码不同" toView:self.view];
        return;
    }
    else{
        YYLog(@"两次密码一致");
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"21";
    parameters[@"newpassword"] = firstPassword;

    if (_oldPassword) {
        YYLog(@"修改密码");
        parameters[@"oldpassword"] = _oldPassword;
        parameters[@"reset"] = @"0";
        parameters[@"user"] = [YYUserTool userModel].userID;
    }
    else{
        YYLog(@"重置密码");
        parameters[@"oldpassword"] = @"";
        parameters[@"reset"] = @"1";
        parameters[@"user"] = _user;
    }
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    NSError *dataError = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&dataError];
    if (dataError) {
        [MBProgressHUD showError:@"修改密码失败，请重试"];
        return;
    }
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyData;
    
    [MBProgressHUD showMessage:@"正在修改密码"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"修改密码失败，请重试"];
            return;
        }
        NSError *dicError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
        if (dicError) {
            [MBProgressHUD showError:@"修改密码失败，请重试"];
            return;
        }
        YYLog(@"%@",dic);
        if (_oldPassword) {
            YYLog(@"修改密码成功");
            if ([dic[@"msg"] isEqualToString:@"ok"]) {
                [MBProgressHUD showSuccess:@"成功修改密码,请重新登录"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:YYUserID];
                [YYUserTool removeUserModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:YYUserLogoutApp object:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
//                [self.navigationController popViewControllerAnimated:YES];

            }
            else{
                [MBProgressHUD showError:@"修改密码失败，请重试"];
                return;
            }
        }
        else{
            YYLog(@"重置密码成功");
            if ([dic[@"msg"] isEqualToString:@"ok"]) {
                [MBProgressHUD showSuccess:@"成功修改密码,请登录"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:YYUserID];
                [YYUserTool removeUserModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:YYUserLogoutApp object:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [MBProgressHUD showError:@"修改密码失败，请重试"];
                return;
            }
        }
    }];
}
- (void)coverBtnClick{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
