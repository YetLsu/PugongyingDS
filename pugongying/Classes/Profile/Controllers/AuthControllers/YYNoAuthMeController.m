//
//  YYNoAuthMeController.m
//  pugongying
//
//  Created by wyy on 16/5/4.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYNoAuthMeController.h"

#import "YYUserTool.h"

@interface YYNoAuthMeController ()
/**
 *  真实姓名TextField
 */
@property (nonatomic, weak) UITextField *realNameTextField;
/**
 *  身份证号码TextField
 */
@property (nonatomic, weak) UITextField *IDCardtextField;
/**
 *  填写信息下方的提示Label
 */
@property (nonatomic, weak) UILabel *promptLabel;
@end

@implementation YYNoAuthMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    [self setNavBar];
    
    // 增加遮盖层
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加填写身份信息的View
    CGFloat viewY = YY12HeightMargin * 2 + 64;
    
    [self addPersonDataHaveTextFieldViewWithFrame:CGRectMake(0, viewY, YYWidthScreen, 100)];
    
    //增加填写信息下方的提示Label
    [self addPromptLabelWithFrame:CGRectMake(YY18WidthMargin, viewY + 100 + YY12HeightMargin, YYWidthScreen - YY18WidthMargin * 2, 20)];
}
/**
 *  增加填写信息下方的提示Label
 */
- (void)addPromptLabelWithFrame:(CGRect)labelFrame{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [self.view addSubview:label];
    self.promptLabel = label;
    self.promptLabel.font = [UIFont systemFontOfSize:16.0];
    self.promptLabel.textColor = YYGrayTextColor;
    self.promptLabel.text = @"请进行实名认证";
    self.promptLabel.textAlignment = NSTextAlignmentLeft;
}

/**
 *  设置导航栏
 */
- (void)setNavBar{
    self.title = @"个人实名认证";
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(postPersonRegBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  提交按钮被点击
 */
- (void)postPersonRegBtnClick{
    NSString *realName = self.realNameTextField.text;
    NSString *idCard = self.IDCardtextField.text;
    if (realName.length == 0) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    else if (idCard.length == 0){
        [MBProgressHUD showError:@"请输入身份证号码"];
        return;
    }
    else if (idCard.length != 18){
        [MBProgressHUD showError:@"身份证号码不正确"];
        return;
    }
    
    [self realNameAuthWithRealName:realName andIDCard:idCard];
}
#pragma mark 实名认证信息提交
- (void)realNameAuthWithRealName:(NSString *)realName andIDCard:(NSString *)IDCard{
    [MBProgressHUD showMessage:@"正在提交您的信息"];
    
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10];
    
    request.HTTPMethod = @"POST";
    /**
     *  mode: 16,userid: 1,name: 章xx,card: 3306215******,category: 个人认证
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"16";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"card"] = IDCard;
    parameters[@"name"] = realName;
    parameters[@"category"] = @"个人认证";

    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"提交您的个人信息失败，请重新提交"];
        return ;
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"提交您的个人信息失败，请重新提交"];
            return ;
        }
        
        NSError *error1 = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
        if (error1) {
            [MBProgressHUD showError:@"提交您的个人信息失败，请重新提交"];
            return ;
        }
        YYLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"实名认证申请已提交"];
            [self.navigationController popViewControllerAnimated:YES];
            YYUserModel *userModel = [YYUserTool userModel];
            userModel.regstate = @"认证中";
            [YYUserTool saveUserModelWithModel:userModel];
        }
        else if ([dic[@"msg"] isEqualToString:@"error_idcard"]){
            [MBProgressHUD showError:@"身份证号码输入错误"];
            return;
        }
    }];
}
#pragma mark 遮盖层被点击
/**
 *  遮盖层被点击
 */
- (void)coverBtnClick{
    [self.view endEditing:YES];
}
#pragma mark 增加填写身份信息的View
- (void)addPersonDataHaveTextFieldViewWithFrame:(CGRect)viewFrame{
    UIView *superView = [[UIView alloc] initWithFrame:viewFrame];
    [self.view addSubview:superView];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:superView];
    //增加真实姓名Label和textfield
    CGFloat realNameTextFieldH = viewFrame.size.height/2.0;
    self.realNameTextField = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, 0, 85, realNameTextFieldH) toSuperView:superView labelText:@"真实姓名："];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, viewFrame.size.height/2.0 -0.5, YYWidthScreen - YY18WidthMargin * 2, 0.5) andView:superView];
    
    //增加身份证号码Label和textfield
    self.IDCardtextField = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, realNameTextFieldH, 100, realNameTextFieldH) toSuperView:superView labelText:@"身份证号码："];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, viewFrame.size.height - 0.5, YYWidthScreen, 0.5) andView:superView];
    
}
#pragma mark 增加Label和textField
- (UITextField *)addLabelWithLabelFrame:(CGRect)labelFrame toSuperView:(UIView *)superView labelText:(NSString *)labelTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = YYGrayTextColor;
    label.text = labelTitle;
    [superView addSubview:label];
    label.font = [UIFont systemFontOfSize:16];
    
    CGFloat textFieldX = labelFrame.origin.x + labelFrame.size.width + 5;
    CGFloat textFieldW = YYWidthScreen - textFieldX - YY18WidthMargin;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, labelFrame.origin.y, textFieldW, labelFrame.size.height)];
    [superView addSubview:textField];
    
    return textField;
    
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
