//
//  YYBusinessAuthViewController.m
//  pugongying
//
//  Created by wyy on 16/3/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYBusinessAuthViewController.h"
#import "YYBusinessNoAuthViewController.h"
#import "YYUserTool.h"

@interface YYBusinessAuthViewController ()
/**
 *  企业名称Label
 */
@property (nonatomic, weak) UILabel *businessNameLabel;
/**
 *  营业执照Label
 */
@property (nonatomic, weak) UILabel *businessCardLabel;
/**
 *  提交营业执照图片ImageView
 */
@property (nonatomic, weak) UIImageView *uploadPicImageView;
@end

@implementation YYBusinessAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setNavBar];
    
    //增加填写企业信息的View
    CGFloat viewY = YY12HeightMargin * 2 + 64;
    
    [self addBusinessDataHaveTextFieldViewWithFrame:CGRectMake(0, viewY, YYWidthScreen, 100)];
    
    //增加营业执照的ImageView
    CGFloat uploadPicBtnW = 225;
    CGFloat uploadPicBtnH = 145;
    CGFloat uploadPicBtnX = (YYWidthScreen - uploadPicBtnW)/2.0;
    CGFloat uploadPicBtnY = viewY + 100 + 5 * YY10HeightMargin;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(uploadPicBtnX, uploadPicBtnY, uploadPicBtnW, uploadPicBtnH)];
    
    [self.view addSubview:imageView];
    YYLog(@"%@",[YYUserTool userModel].licenseimgurl);
   
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[YYUserTool userModel].licenseimgurl]];
    
    //增加上传图片的名称label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, uploadPicBtnY + uploadPicBtnH + YY10HeightMargin, YYWidthScreen, 20)];
    label.text = @"营业执照";
    label.textColor = YYGrayTextColor;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    
    //增加已通过实名认证的label
    CGFloat realLabelY = uploadPicBtnY + uploadPicBtnH + 5 *YY10HeightMargin;
    UILabel *realLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, realLabelY, YYWidthScreen, 50)];
    [self.view addSubview:realLabel];
    
    NSString *regState = [YYUserTool userModel].authstate;
    if ([regState isEqualToString:@"已认证"]) {//已认证
        realLabel.text = @"您已通过企业实名认证！";
        realLabel.textColor = [UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0];
    }
    else if ([regState isEqualToString:@"认证中"]){
        realLabel.text = @"您的申请已提交，请耐心等待！";
        realLabel.textColor = [UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0];
    }
    else if ([regState isEqualToString:@"认证失败"]){
        realLabel.text = @"您的认证已失败，请重新提交！";
        realLabel.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:0 alpha:1.0];
    }
  
    realLabel.textAlignment = NSTextAlignmentCenter;
}
#pragma mark 设置导航栏
- (void)setNavBar{
    self.title = @"企业实名认证";
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"再次认证" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn sizeToFit];
    
    [btn addTarget:self action:@selector(againBusinessAuthbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 增加展示企业信息的View
- (void)addBusinessDataHaveTextFieldViewWithFrame:(CGRect)viewFrame{
    UIView *superView = [[UIView alloc] initWithFrame:viewFrame];
    [self.view addSubview:superView];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:superView];
    //增加企业名称Label和展示企业的label
    CGFloat realNameTextFieldH = viewFrame.size.height/2.0;
    self.businessNameLabel = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, 0, 85, realNameTextFieldH) toSuperView:superView labelText:@"企业名称："];
    
    self.businessNameLabel.text = [YYUserTool userModel].company;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, viewFrame.size.height/2.0 -0.5, YYWidthScreen - YY18WidthMargin * 2, 0.5) andView:superView];
    
    //增加企业营业执照Label和企业营业执照号码Label
    self.businessCardLabel = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, realNameTextFieldH, 100, realNameTextFieldH) toSuperView:superView labelText:@"营业执照号："];
    self.businessCardLabel.text = [YYUserTool userModel].license;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, viewFrame.size.height - 0.5, YYWidthScreen, 0.5) andView:superView];
    
    
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
#pragma mark 再次认证按钮被点击
- (void)againBusinessAuthbtnClick{
    YYBusinessNoAuthViewController *noauth = [[YYBusinessNoAuthViewController alloc] init];
    [self.navigationController pushViewController:noauth animated:YES];
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
