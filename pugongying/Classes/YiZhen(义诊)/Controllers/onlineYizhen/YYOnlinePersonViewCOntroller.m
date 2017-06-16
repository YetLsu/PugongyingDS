//
//  YYOnlinePersonViewController.m
//  pugongying
//
//  Created by wyy on 16/3/22.
//  Copyright © 2016年 WYY. All rights reserved.
//
#define YizhenPostSuccess @"YizhenPostSuccess"


#import "YYOnlinePersonViewController.h"

#import "YYClinicModel.h"


@interface YYOnlinePersonViewController ()<UITextFieldDelegate>

/**
 *  个人信息的View
 */
@property (nonatomic, weak) UIView *messageView;
/**
 *  模型
 */
@property (nonatomic, strong) YYClinicModel *model;

/**
 * 姓名输入框
 */
@property (nonatomic, weak) UITextField *nameTextField;
/**
 *  男士按钮
 */
@property (nonatomic, weak) UIButton *manBtn;
/**
 *  女士按钮
 */
@property (nonatomic, weak) UIButton *womenBtn;
/**
 * 电话输入框
 */
@property (nonatomic, weak) UITextField *phoneTextField;
/**
 * QQ输入框
 */
@property (nonatomic, weak) UITextField *QQTextField;
/**
 * 遮盖层按钮
 */
@property (nonatomic, strong) UIButton *coverBtn;
/**
 *  提交按钮
 */
@property (nonatomic, weak) UIButton *postBtn;
@end

@implementation YYOnlinePersonViewController
- (UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, YYWidthScreen, YYHeightScreen - 64)];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}
#pragma mark 遮盖层被点击
- (void)coverBtnClick{
    [self.view endEditing:YES];
    
}
- (instancetype)initWithModel:(YYClinicModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, YYHeightScreen, YYWidthScreen, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    //设置导航栏
    [self setNavBar];
    
    //增加蒲公英图片和下面的字
    UILabel *label = [self addImageViewAndLabel];
    
    //增加用户信息的View
    [self addPersonMessageViewWithViewY:CGRectGetMaxY(label.frame) +5 * YY10HeightMargin];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldStartWrite:) name:UITextFieldTextDidBeginEditingNotification object:self.nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEndWrite:) name:UITextFieldTextDidEndEditingNotification object:self.nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldStartWrite:) name:UITextFieldTextDidBeginEditingNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEndWrite:) name:UITextFieldTextDidEndEditingNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldStartWrite:) name:UITextFieldTextDidBeginEditingNotification object:self.QQTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEndWrite:) name:UITextFieldTextDidEndEditingNotification object:self.QQTextField];
}
#pragma mark 监听键盘弹出
- (void)textFieldStartWrite:(NSNotification *)notification{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = -200;
    }];

}
- (void)textFieldEndWrite:(NSNotification *)notification{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = 0;
    }];
}
#pragma mark 设置导航栏
- (void)setNavBar{
    self.title = @"在线诊断申请";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.postBtn = rightBtn;
}
#pragma mark 提交按钮被点击
- (void)submitBtnClick{
    NSString *userName = self.nameTextField.text;
    NSString *sex = nil;
    NSString *phone = self.phoneTextField.text;
    NSString *qq = self.QQTextField.text;
    if (userName.length == 0) {
        [MBProgressHUD showError:@"请输入您的姓名"];
        return;
    }
    if (self.manBtn.selected) {
        sex = @"先生";
    }
    else if (self.womenBtn.selected){
        sex = @"女士";
    }
    else {
        [MBProgressHUD showError:@"请选择性别"];
        return;
    }
    
    if (phone.length == 0){
        [MBProgressHUD showError:@"请输入您的联系电话"];
        return;
    }
    else if (qq.length == 0){
        [MBProgressHUD showError:@"请输入您的QQ"];
        return;
    }
    //提交义诊信息
    [self postYizhenMessageWithUserName:userName sex:sex phone:phone qq:qq];
}
#pragma mark 提交义诊信息
- (void)postYizhenMessageWithUserName:(NSString *)userName sex:(NSString *)sex phone:(NSString *)phone qq:(NSString *)qq{
    [MBProgressHUD showMessage:@"正在提交义诊"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:YYHTTPInsertPOST] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /**
     *  mode: 15,userid: 1,categoryid: 1,title: 我的义诊一,name: 章XX,sex: 先生,phone: 133435 81115,qq: 619631670,elem1: 填写内容一,elem2: 填写内容二,elem3: 填写内容三,ele m4: 填写内容四,content: 补充内容
     */
    parameters[@"mode"] = @"15";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    parameters[@"categoryid"] = self.model.categoryid;

    parameters[@"title"] = @"";

    parameters[@"name"] = userName;
    
    parameters[@"sex"] = sex;
    
    parameters[@"phone"] = phone;
    
    parameters[@"qq"] = qq;
    
    parameters[@"elem1"] = self.model.elem1;
    
    parameters[@"elem2"] = self.model.elem2;
    
    parameters[@"elem3"] = self.model.elem3;
    
    parameters[@"elem4"] = self.model.elem4;
    
    parameters[@"content"] = self.model.content;
   
    NSError *error = nil;
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"义诊提交失败，请重新提交"];
        return;
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"义诊提交失败，请重新提交"];
            return;

        }
        
        NSError *error1 = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
        if (error1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"义诊提交失败，请重新提交"];
            return;
        }

        YYLog(@"成功获取数据：%@",dic);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"成功提交义诊"];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:YYUpdateYizhen];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //添加通知
            [[NSNotificationCenter defaultCenter] postNotificationName:YizhenPostSuccess object:self];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([dic[@"msg"] isEqualToString:@"error_exist"]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"当前有义诊正在处理"];
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"提交义诊失败，请重新提交"];
        }
        
    }];

}
#pragma mark 增加蒲公英图片348,294和下面的字
- (UILabel *)addImageViewAndLabel{
    CGFloat imageViewY = 5 * YY10HeightMargin + 64;
    
    CGFloat scale = YYHeightScreen/667.0;
    
    CGFloat imageViewW = 174*scale;
    CGFloat imageViewH = 147*scale;
    CGFloat imageViewX = (YYWidthScreen - imageViewW)/2.0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    imageView.image = [UIImage imageNamed:@"yizhen_pugongyingLogo"];
    [self.view addSubview:imageView];
    
    CGFloat label1Y = CGRectGetMaxY(imageView.frame) + 5 *YY10HeightMargin;
    CGFloat labelH = 20;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1Y, YYWidthScreen, labelH)];
    [self.view addSubview:label1];
    label1.text = @"您已填写完毕";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = YYGrayText140Color;
    label1.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1Y + labelH, YYWidthScreen, labelH)];
    [self.view addSubview:label2];
    label2.text = @"请留下您的联系方式，方便义诊专家联系您哦！";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = YYGrayText140Color;
    label2.font = [UIFont systemFontOfSize:15.0];
    
    return label2;
}
#pragma mark 增加用户信息的View
- (void)addPersonMessageViewWithViewY:(CGFloat)viewY{
    
    [self.view addSubview:self.coverBtn];
    
    CGFloat viewW = YYWidthScreen;
    CGFloat viewH = 35 * 4;
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, viewW, viewH)];
    [self.view addSubview:messageView];
    self.messageView = messageView;
    
    CGFloat allWidth = 270;
    CGFloat labelX = (YYWidthScreen - allWidth)/2.0;
    CGFloat labelH = 35;
    
    self.nameTextField = [self addLabelAndTextFieldWithLabelFrame:CGRectMake(labelX, 0, 80, labelH) andTextFieldFrame:CGRectMake(labelX + 80, 0, allWidth - 80, labelH) andlabelText:@"您的姓名：" placeholder:nil andSuperView:messageView];
    self.nameTextField.delegate = self;
    
    //增加性别按钮
    [self addSexBtnsWithSuperView:messageView andTopLabelFrame:CGRectMake(labelX, 0, 80, labelH)];
    
    // 增加联系电话输入框
    self.phoneTextField = [self addLabelAndTextFieldWithLabelFrame:CGRectMake(labelX, labelH * 2, 80, labelH) andTextFieldFrame:CGRectMake(labelX + 80, labelH * 2, allWidth - 80, labelH) andlabelText:@"联系电话：" placeholder:nil andSuperView:messageView];
    self.phoneTextField.delegate = self;
    
    // 增加联系QQ输入框
    self.QQTextField = [self addLabelAndTextFieldWithLabelFrame:CGRectMake(labelX, labelH * 3, 80, labelH) andTextFieldFrame:CGRectMake(labelX + 80, labelH * 3, allWidth - 80, labelH) andlabelText:@"联系QQ：" placeholder:nil andSuperView:messageView];
    self.QQTextField.delegate = self;
}
#pragma mark 添加一个Label和一个TextField到View上 tag为0添加星星 为1不添加
- (UITextField *)addLabelAndTextFieldWithLabelFrame:(CGRect)labelFrame andTextFieldFrame:(CGRect)tfFrame andlabelText:(NSString *)labelText placeholder:(NSString *)placeholder andSuperView:(UIView *)superView{
    
    //增加Label
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = labelText;
    label.textColor = YYGrayTextColor;
    [superView addSubview:label];
    label.font = [UIFont systemFontOfSize:15.0];
    
    //增加TextField
    UITextField *textField = [[UITextField alloc] initWithFrame:tfFrame];
    textField.placeholder = placeholder;
    [superView addSubview:textField];
    
    CGFloat lineX = tfFrame.origin.x;
    CGFloat lineY = CGRectGetMaxY(tfFrame) - 0.5;
    CGFloat lineW = tfFrame.size.width;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(lineX, lineY, lineW, 0.5) andView:superView];
    
    return textField;
}

- (void)addSexBtnsWithSuperView:(UIView *)superView andTopLabelFrame:(CGRect)labelF{
    //在联系人下方增加性别选项
    CGFloat allWidth = 270;
    //男按钮
    CGFloat labelH = labelF.size.height;
    CGFloat manBtnX = labelF.origin.x + labelF.size.width + 10;

    CGFloat manBtnY = labelF.origin.y + labelH;
    UIButton *manBtn = [[UIButton alloc] initWithFrame:CGRectMake(manBtnX, manBtnY, labelH, labelH)];
    [superView addSubview:manBtn];
    [manBtn setImage:[UIImage imageNamed:@"yizhen_sex_nor"] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"yizhen_sex_sel"] forState:UIControlStateHighlighted];
    [manBtn setImage:[UIImage imageNamed:@"yizhen_sex_sel"] forState:UIControlStateSelected];
    self.manBtn = manBtn;
    self.manBtn.imageView.contentMode = UIViewContentModeCenter;
    [self.manBtn addTarget:self action:@selector(sexBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat manLabelW = 60;
    CGFloat manLabelX = manBtnX + labelH + 5;
    //    YYLog(@"manLabelX = %f", manLabelX);
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(manLabelX, manBtnY, manLabelW, labelH)];
    [superView addSubview:manLabel];
    manLabel.text = @"先生";
    //女按钮
    CGFloat womenBtnX = manBtnX + labelH + 5 + manLabelW;
    UIButton *womenBtn = [[UIButton alloc] initWithFrame:CGRectMake(womenBtnX, manBtnY, labelH, labelH)];
    [superView addSubview:womenBtn];
    [womenBtn setImage:[UIImage imageNamed:@"yizhen_sex_nor"] forState:UIControlStateNormal];
    [womenBtn setImage:[UIImage imageNamed:@"yizhen_sex_sel"] forState:UIControlStateHighlighted];
    [womenBtn setImage:[UIImage imageNamed:@"yizhen_sex_sel"] forState:UIControlStateSelected];
    self.womenBtn = womenBtn;
    self.womenBtn.imageView.contentMode = UIViewContentModeCenter;
    [self.womenBtn addTarget:self action:@selector(sexBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat womenLabelX = womenBtnX + labelH + 5;
    
    //    YYLog(@"womenLabelX = %f", womenLabelX);
    UILabel *womenLabel = [[UILabel alloc] initWithFrame:CGRectMake(womenLabelX, manBtnY, 60, labelH)];
    [superView addSubview:womenLabel];
    womenLabel.text = @"女士";
    //增加线条
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(labelF.origin.x, CGRectGetMaxY(labelF) + labelH - 0.5, allWidth, 0.5) andView:superView];
}
#pragma mark 性别按钮被点击
- (void)sexBtnClickWithBtn:(UIButton *)btn{
    if (self.manBtn == btn) {
        YYLog(@"先生");
        self.manBtn.selected = YES;
        self.womenBtn.selected = NO;
    }
    else if (self.womenBtn == btn){
        YYLog(@"女士");
        self.manBtn.selected = NO;
        self.womenBtn.selected = YES;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
