//
//  YYOnLineYiZhenViewController.m
//  pugongying
//
//  Created by wyy on 16/3/21.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**15f123f90e9f0b9b6c7fc5945236e1af91c79787
 *  顶部的三个按钮，淘宝tag0，阿里巴巴tag1，国际站tag2
 *
 */

#define YizhenPostSuccess @"YizhenPostSuccess"


#import "YYOnLineYiZhenViewController.h"
#import "YYOnlinePersonViewController.h"

#import "YYTaobaoScrollerView.h"
#import "YYAliScrollerView.h"
#import "YYinternationalScrollerView.h"

#import "YYClinicModel.h"


@interface YYOnLineYiZhenViewController ()<UIScrollViewDelegate>

/**
 *  顶部三个按钮的父button
 */
@property (nonatomic, weak) UIButton *topViewBtn;
/**
 *  淘宝按钮
 */
@property (nonatomic, weak) UIButton *taobaoBtn;
/**
 *  阿里巴巴按钮
 */
@property (nonatomic, weak) UIButton *aliBtn;
/**
 *  国际站按钮
 */
@property (nonatomic, weak) UIButton *internationalBtn;
/**
 *  淘宝
 */
@property (nonatomic, strong) YYTaobaoScrollerView *taobaoScrollerView;
/**
 *  阿里巴巴
 */
@property (nonatomic, strong) YYAliScrollerView *aliScrollerView;
/**
 *  国际站
 */
@property (nonatomic, strong) YYInternationalScrollerView *internationalScrollerView;
@end

@implementation YYOnLineYiZhenViewController

#pragma mark 遮盖层被点击
- (void)coverBtnClick{
    YYLog(@"遮盖层被点击");
    [self.view endEditing:YES];
}
- (UIScrollView *)taobaoScrollerView{
    if (!_taobaoScrollerView) {
 
        CGFloat viewHeight = YY10HeightMargin * 5 + 30;
        CGFloat scrollerY = 64 + viewHeight;
        CGFloat scrollerH = YYHeightScreen - scrollerY;

        _taobaoScrollerView = [[YYTaobaoScrollerView alloc] initWithFrame:CGRectMake(0, scrollerY, YYWidthScreen, scrollerH)];
        _taobaoScrollerView.delegate = self;
        
    }
    return _taobaoScrollerView;
}
- (UIScrollView *)aliScrollerView{
    if (!_aliScrollerView) {
        
        CGFloat viewHeight = YY10HeightMargin * 5 + 30;
        CGFloat scrollerY = 64 + viewHeight;
        CGFloat scrollerH = YYHeightScreen - scrollerY;
        
        _aliScrollerView = [[YYAliScrollerView alloc] initWithFrame:CGRectMake(0, scrollerY, YYWidthScreen, scrollerH)];
    }
    return _aliScrollerView;
}
- (UIScrollView *)internationalScrollerView{
    if (!_internationalScrollerView) {
       
        CGFloat viewHeight = YY10HeightMargin * 5 + 30;
        CGFloat scrollerY = 64 + viewHeight;
        CGFloat scrollerH = YYHeightScreen - scrollerY;
        
        _internationalScrollerView = [[YYInternationalScrollerView alloc] initWithFrame: CGRectMake(0, scrollerY, YYWidthScreen, scrollerH)];
    }
    return _internationalScrollerView;
}
#pragma mark 义诊提交成功
- (void)yizhenPostSuccess{
    YYLog(@"义诊提交成功");
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   //监听义诊提交成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yizhenPostSuccess) name:YizhenPostSuccess object:nil];
    
    //增加顶部的三个按钮的view
    CGFloat viewHeight = YY10HeightMargin * 5 + 30;
    [self addTopBtnsViewWithFrame:CGRectMake(0, 64, YYWidthScreen, viewHeight)];
    
    [self topBtnsClickWithBtn:self.taobaoBtn];
    
    //设置导航栏
    [self setNavBar];
    //监听键盘弹出事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 监听键盘弹出事件
- (void)keyBoardDidShow:(NSNotification *)noti{
    // YYLog(@"键盘弹出");
//    if (self.taobaoScrollerView.textViewWrite || self.aliScrollerView.textViewWrite ||self.internationalScrollerView.textViewWrite) {
//        CGFloat contentOffsetY = self.taobaoScrollerView.contentSize.height - self.taobaoScrollerView.height + 255;
//        
//        self.taobaoScrollerView.contentOffset = CGPointMake(0, contentOffsetY);
//        self.aliScrollerView.contentOffset = CGPointMake(0, contentOffsetY);
//        self.internationalScrollerView.contentOffset = CGPointMake(0, contentOffsetY);
//    }

}
- (void)keyBoardWillHidden{
    YYLog(@"键盘隐藏");
//    if (!self.taobaoScrollerView.textViewWrite && !self.aliScrollerView.textViewWrite &&!self.internationalScrollerView.textViewWrite) {
//        CGFloat contentOffsetY = self.taobaoScrollerView.contentSize.height - self.taobaoScrollerView.height;
//        
//        
//        self.taobaoScrollerView.contentOffset = CGPointMake(0, contentOffsetY);
//        self.aliScrollerView.contentOffset = CGPointMake(0, contentOffsetY);
//        self.internationalScrollerView.contentOffset = CGPointMake(0, contentOffsetY);
//    }

}
#pragma mark 设置导航栏
- (void)setNavBar{
    self.title = @"在线诊断申请";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(onlineNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 下一步按钮被点击
- (void)onlineNextBtnClick{
    if (self.taobaoBtn.selected) {
        [self taobaoBtnNextClick];
    }
    else if (self.aliBtn.selected){
        [self aliBtnNextClick];
    }
    else if (self.internationalBtn.selected){
        [self internationalBtnNextClick];
    }
}
#pragma mark 判断是否选择按钮，若选择把字符串传出，若没有选择提示信息,传出YES表示要返回，NO表示不用返回
- (NSString *)judgeBtnsSelectWithBtnsArray:(NSArray *)btnsArray andShowText:(NSString *)showText{
    int i = 0;
    NSString *str = nil;
    for (UIButton *btn in btnsArray) {
        if (!btn.selected) {
            i++;
            if (i == 2) {
                [MBProgressHUD showError:showText];
            }
        }
        else{
            str = btn.titleLabel.text;
            YYLog(@"%@",str);
            break;
        }
    }
    return str;
}
#pragma mark 淘宝模块时的下一步被点击
- (void)taobaoBtnNextClick{
    
    NSString *elem1 = self.taobaoScrollerView.storeAddressTextField.text;
    NSString *elem2 = self.taobaoScrollerView.storeSellTextField.text;
    NSString *elem3 = nil;
    NSString *elem4 = nil;
    NSString *questionIntro = nil;
    if (elem1.length == 0) {
        [MBProgressHUD showError:@"请输入店铺全称"];
        return;
    }
    else if (elem2.length == 0){
        [MBProgressHUD showError:@"请输入店铺主营产品"];
        return;
    }
    elem3 = [self judgeBtnsSelectWithBtnsArray:self.taobaoScrollerView.thirdBtnsArray andShowText:@"请选择是否请了美工"];
    
    if (!elem3) return;
    
    elem4 = [self judgeBtnsSelectWithBtnsArray:self.taobaoScrollerView.fiveBtnsArray andShowText:@"请选择店铺操作时间"];
    if (!elem4) return;
   
    if (self.taobaoScrollerView.haveWriteText) {
        questionIntro = self.taobaoScrollerView.textView.text;
        YYLog(@"输入的补充%@",questionIntro);
        
    }
    else{
       [MBProgressHUD showError:@"请输入问题描述"];
        return;
    }

    YYClinicModel *model = [[YYClinicModel alloc] initWithClinicID:nil userModel:nil adminModel:nil categoryid:@"1" title:nil elem1:elem1 elem2:elem2 elem3:elem3 elem4:elem4 content:questionIntro result:nil done:nil replyTime:nil createTime:nil];
    
    YYOnlinePersonViewController *personController = [[YYOnlinePersonViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:personController animated:YES];
    YYLog(@"淘宝模块时的下一步被点击");
}
#pragma mark 1688模块时的下一步被点击
- (void)aliBtnNextClick{
    
    NSString *elem1 = self.aliScrollerView.storeAddressTextField.text;
    NSString *elem2 = self.aliScrollerView.storeSellTextField.text;
    NSString *elem3 = nil;
    NSString *elem4 = nil;
    NSString *questionIntro = nil;
    if (elem1.length == 0) {
        [MBProgressHUD showError:@"请输入公司全称／账号ID"];
        return;
    }
    else if (elem2.length == 0){
        [MBProgressHUD showError:@"请输入店铺主营产品"];
        return;
    }
    elem3 = [self judgeBtnsSelectWithBtnsArray:self.aliScrollerView.thirdBtnsArray andShowText:@"请选择是否请了美工"];
    if (!elem3) return;
    
    elem4 = [self judgeBtnsSelectWithBtnsArray:self.aliScrollerView.fiveBtnsArray andShowText:@"请选择店铺操作时间"];
    if (!elem4) return;
    if (self.aliScrollerView.haveWriteText) {
        questionIntro = self.aliScrollerView.textView.text;
        YYLog(@"输入的补充%@",questionIntro);
        
    }
    else{
        [MBProgressHUD showError:@"请输入问题描述"];
        return;
    }
    
     YYClinicModel *model = [[YYClinicModel alloc] initWithClinicID:nil userModel:nil adminModel:nil categoryid:@"2" title:nil elem1:elem1 elem2:elem2 elem3:elem3 elem4:elem4 content:questionIntro result:nil done:nil replyTime:nil createTime:nil];
    YYOnlinePersonViewController *personController = [[YYOnlinePersonViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:personController animated:YES];
    YYLog(@"阿里巴巴模块时的下一步被点击");
}
#pragma mark 国际站模块时的下一步被点击
- (void)internationalBtnNextClick{
    
    NSString *elem1 = self.internationalScrollerView.storeAddressTextField.text;
    NSString *elem2 = nil;
    NSString *elem3 = nil;
    NSString *elem4 = nil;
    NSString *questionIntro = nil;
    if (elem1.length == 0) {
        [MBProgressHUD showError:@"请输入公司全称"];
        return;
    }
    elem2 = [self judgeBtnsSelectWithBtnsArray:self.internationalScrollerView.fouthBtnsArray andShowText:@"请选择店铺操作时间"];
    if (!elem2) return;
    
    elem3 = [self judgeBtnsSelectWithBtnsArray:self.internationalScrollerView.fiveBtnsArray andShowText:@"请选择周上传产品数量"];
    if (!elem3) return;
    
    elem4 = [self judgeBtnsSelectWithBtnsArray:self.internationalScrollerView.sixBtnsArray andShowText:@"请选择是否适用P4P业务"];
    if (!elem4) return;
    if (self.internationalScrollerView.haveWriteText) {
        questionIntro = self.internationalScrollerView.textView.text;
        YYLog(@"输入的补充%@",questionIntro);
        
    }
    else{
        [MBProgressHUD showError:@"请输入问题描述"];
        return;
    }

     YYClinicModel *model = [[YYClinicModel alloc] initWithClinicID:nil userModel:nil adminModel:nil categoryid:@"3" title:nil elem1:elem1 elem2:elem2 elem3:elem3 elem4:elem4 content:questionIntro result:nil done:nil replyTime:nil createTime:nil];
    YYOnlinePersonViewController *personController = [[YYOnlinePersonViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:personController animated:YES];
    YYLog(@"国际站模块时的下一步被点击");
}
#pragma mark 增加顶部的三个按钮的view
- (void)addTopBtnsViewWithFrame:(CGRect)viewFrame{
    UIButton *topView = [[UIButton alloc] initWithFrame:viewFrame];
    [self.view addSubview:topView];
    self.topViewBtn = topView;
    [self.topViewBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮宽90，高40
    CGFloat btnW = 90;
    CGFloat btnH = 40;
    CGFloat btn1X = (viewFrame.size.width - btnW * 3)/2.0;
    CGFloat btnY = YY10HeightMargin * 2.5;
    
    UIButton *btn1 = [YYPugongyingTool createBtnWithFrame:CGRectMake(btn1X, btnY, btnW, btnH) superView:topView backgroundImage:nil titleColor:nil title:@"淘宝"];
    btn1.tag = 0;
    [btn1 addTarget:self action:@selector(topBtnsClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self setBtnImageWithBtn:btn1];
    self.taobaoBtn = btn1;
    
    UIButton *btn2 = [YYPugongyingTool createBtnWithFrame:CGRectMake(btn1X + btnW, btnY, btnW, btnH) superView:topView backgroundImage:nil titleColor:nil title:@"1688"];
    btn2.tag = 1;
    [btn2 addTarget:self action:@selector(topBtnsClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self setBtnImageWithBtn:btn2];
    self.aliBtn = btn2;
    
    UIButton *btn3 = [YYPugongyingTool createBtnWithFrame:CGRectMake(btn1X + btnW * 2, btnY, btnW, btnH) superView:topView backgroundImage:nil titleColor:nil title:@"国际站"];
    btn3.tag = 2;
    [btn3 addTarget:self action:@selector(topBtnsClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self setBtnImageWithBtn:btn3];
    self.internationalBtn = btn3;
}
#pragma mark 设置按钮图片
- (void)setBtnImageWithBtn:(UIButton *)btn{
    
    [btn setTitleColor:[UIColor colorWithRed:85/255.0 green:116/255.0 blue:202/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_blue_LCR"] forState:UIControlStateHighlighted];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_blue_LCR"] forState:UIControlStateSelected];
    
    switch (btn.tag) {
        case 0:
            [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_left_nor"] forState:UIControlStateNormal];
            break;
        case 1:
            [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_center_nor"] forState:UIControlStateNormal];
            break;
        case 2:
            [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_right_nor"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
#pragma mark 上面的按钮被点击
- (void)topBtnsClickWithBtn:(UIButton *)btn{
    for (UIView *subView in self.topViewBtn.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            button.selected = NO;
        }
    }
    btn.selected = YES;
    
    if (btn.tag == 0) {
        [self.view addSubview:self.taobaoScrollerView];
        [self.aliScrollerView removeFromSuperview];
        [self.internationalScrollerView removeFromSuperview];
        
    }
    else if (btn.tag == 1){
        [self.view addSubview:self.aliScrollerView];
        [self.taobaoScrollerView removeFromSuperview];
        [self.internationalScrollerView removeFromSuperview];
    }
    else if (btn.tag == 2){
        [self.view addSubview:self.internationalScrollerView];
        [self.taobaoScrollerView removeFromSuperview];
        [self.aliScrollerView removeFromSuperview];
    }

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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
