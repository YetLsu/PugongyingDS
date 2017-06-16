//
//  YYChangeNameViewController.m
//  pugongying
//
//  Created by wyy on 16/3/14.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYChangeNameViewController.h"
#import "YYUserTool.h"


@interface YYChangeNameViewController ()
/**
 *  昵称输入框
 */
@property (nonatomic, weak) UITextField *textField;
@end

@implementation YYChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"修改昵称";
    
    //增加textField
    CGFloat textFieldY = 84;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, textFieldY, YYWidthScreen, 50)];
    [self.view addSubview:textField];
    self.textField = textField;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"昵称：";
   
    [label sizeToFit];
    
    self.textField.leftView = label;
    self.textField.leftViewMode = UITextFieldViewModeAlways;

    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:self.textField];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 49.5, YYWidthScreen, 0.5) andView:self.textField];
    //增加右上角提交按钮
    [self addPostBtn];
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
- (void)postBtnClick{
     [MBProgressHUD showMessage:@"正在修改昵称"];
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"22";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"column"] = @"nickname";
    parameters[@"value"] = self.textField.text;
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        [MBProgressHUD showError:@"修改昵称失败"];
        [MBProgressHUD hideHUD];
        return;
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"修改昵称失败"];
            return ;
        }
        
        NSError *dicError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
        if (dicError) {
            [MBProgressHUD showError:@"修改昵称失败"];
            return ;
        }
        YYLog(@"修改昵称%@",dic);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"成功修改昵称"];
            
            YYUserModel *model = [YYUserTool userModel];
            
            model.nickname = self.textField.text;
            [YYUserTool saveUserModelWithModel:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YYUserChangeName object:self];

            [self.navigationController popViewControllerAnimated:YES];
          
        }else{
            [MBProgressHUD showError:@"修改昵称失败"];
            return ;
         
        }
    }];

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
