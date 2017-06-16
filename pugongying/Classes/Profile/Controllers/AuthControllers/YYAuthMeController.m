//
//  YYAuthMeController.m
//  pugongying
//
//  Created by wyy on 16/5/4.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYAuthMeController.h"
#import "YYNoAuthMeController.h"
#import "YYUserTool.h"

@interface YYAuthMeController ()
/**
 *  真实姓名Label
 */
@property (nonatomic, weak) UILabel *realNameLabel;
/**
 *  身份证号码Label
 */
@property (nonatomic, weak) UILabel *IDCardLabel;
/**
 *  再次认证按钮
 */
@property (nonatomic, weak) UIButton *regBtn;

/**
 *  填写信息下方的提示Label
 */
@property (nonatomic, weak) UILabel *promptLabel;
@end

@implementation YYAuthMeController
- (void)getPersonMessage{
  
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"191";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *dic = responseObject[@"ret"];
            self.realNameLabel.text = dic[@"name"];
            self.IDCardLabel.text = dic[@"card"];
            
            YYUserModel *userModel = [YYUserTool userModel];
            userModel.realname = dic[@"name"];
            userModel.idcard = dic[@"card"];
            [YYUserTool saveUserModelWithModel:userModel];
            //            NSString *state = dic[@"regstate"];
            //            if ([state isEqualToString:@"已认证"]) {//已认证
            //                self.promptLabel.textColor = [UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0];
            //                self.promptLabel.text = @"您已通过实名认证";
            //            }
            //            else if ([state isEqualToString:@"认证中"]){
            //                self.promptLabel.textColor = [UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0];
            //                self.promptLabel.text = @"实名认证已提交，工作人员正在认证";
            //            }
            //            else if ([state isEqualToString:@"认证失败"]){
            //                self.promptLabel.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:0 alpha:1.0];
            //                self.promptLabel.text = @"实名认证失败，请重新提交";
            //            }
            
        }

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setNavBar];
    
    //增加填写身份信息的View
    CGFloat viewY = YY12HeightMargin * 2 + 64;
    
    [self addPersonDataHaveTextFieldViewWithFrame:CGRectMake(0, viewY, YYWidthScreen, 100)];
    //增加填写信息下方的提示Label
    [self addPromptLabelWithFrame:CGRectMake(YY18WidthMargin, viewY + 100 + YY12HeightMargin, YYWidthScreen - YY18WidthMargin * 2, 20)];
    
    [self getPersonMessage];
}
/**
 *  增加填写信息下方的提示Label
 */
- (void)addPromptLabelWithFrame:(CGRect)labelFrame{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [self.view addSubview:label];
    self.promptLabel = label;
    self.promptLabel.font = [UIFont systemFontOfSize:16.0];
    YYUserModel *model = [YYUserTool userModel];
    if ([model.regstate isEqualToString:@"已认证"]) {//已认证
        self.promptLabel.textColor = [UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0];
        self.promptLabel.text = @"您已通过实名认证";
    }
    else if ([model.regstate isEqualToString:@"认证中"]){
        self.promptLabel.textColor = [UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0];
        self.promptLabel.text = @"实名认证已提交，工作人员正在认证";
    }
    else if ([model.regstate isEqualToString:@"认证失败"]){
        self.promptLabel.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:0 alpha:1.0];
         self.promptLabel.text = @"实名认证失败，请重新提交";
    }

    
    self.promptLabel.textAlignment = NSTextAlignmentLeft;
}
#pragma mark 增加展示身份信息的View
- (void)addPersonDataHaveTextFieldViewWithFrame:(CGRect)viewFrame{
    UIView *superView = [[UIView alloc] initWithFrame:viewFrame];
    [self.view addSubview:superView];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:superView];
    //增加真实姓名Label和展示真实姓名的label
    CGFloat realNameTextFieldH = viewFrame.size.height/2.0;
    self.realNameLabel = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, 0, 85, realNameTextFieldH) toSuperView:superView labelText:@"真实姓名："];
    
    self.realNameLabel.text = [YYUserTool userModel].realname;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, viewFrame.size.height/2.0 -0.5, YYWidthScreen - YY18WidthMargin * 2, 0.5) andView:superView];
    
    //增加身份证号码Label和textfield
    self.IDCardLabel = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, realNameTextFieldH, 100, realNameTextFieldH) toSuperView:superView labelText:@"身份证号码："];
    self.IDCardLabel.text = [YYUserTool userModel].idcard;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, viewFrame.size.height - 0.5, YYWidthScreen, 0.5) andView:superView];
    
    
}

#pragma mark 设置导航栏
- (void)setNavBar{
    self.title = @"个人实名认证";
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"再次认证" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(againPersonAuthbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 再次认证按钮被点击
- (void)againPersonAuthbtnClick{
    YYUserModel *model = [YYUserTool userModel];
    if ([model.regstate isEqualToString:@"认证中"]) {
         [MBProgressHUD showError:@"实名认证认证中"];
        return;
    }
    YYNoAuthMeController *noauth = [[YYNoAuthMeController alloc] init];
    [self.navigationController pushViewController:noauth animated:YES];
}
#pragma mark 增加真实姓名Label和展示真实姓名的label
- (UILabel *)addLabelWithLabelFrame:(CGRect)labelFrame toSuperView:(UIView *)superView labelText:(NSString *)labelTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = YYGrayTextColor;
    label.text = labelTitle;
    [superView addSubview:label];
    label.font = [UIFont systemFontOfSize:16];
    
    CGFloat textFieldX = labelFrame.origin.x + labelFrame.size.width + 5;
    CGFloat textFieldW = YYWidthScreen - textFieldX - YY18WidthMargin;
    UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(textFieldX, labelFrame.origin.y, textFieldW, labelFrame.size.height)];
    [superView addSubview:textField];
    
    return textField;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
