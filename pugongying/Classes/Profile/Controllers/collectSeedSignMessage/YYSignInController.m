//
//  YYSignInController.m
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYSignInController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+GIF.h"

@interface YYSignInController (){
    /**
     *  今日大事件Label的最大高度
     */
    CGFloat _thingLabelMaxH;
    /**
     *  今日大事件Label的最大宽度
     */
    CGFloat _thingLabelMaxW;
    
}
/**
 *  今日大事件中的View
 */
@property (nonatomic, weak) UIView *thingView;
/**
 *  今日大事件中的Label
 */
@property (nonatomic, weak) UILabel *thingLabel;
/**
 * 根据时间显示的上面的Label中的文字
 */
@property (nonatomic, weak) UILabel *topLabel;
/**
 *点击立即签到后出现的遮挡View
 */
@property (nonatomic, weak) UIView *coverView;
/**
 * 签到中连续签到天数的Label
 */
@property (nonatomic, weak) UILabel *daysLabel;
/**
 * 签到中获得种子的Label
 */
@property (nonatomic, weak) UILabel *seedsLabel;
/**
 *立即签到的按钮
 */
@property (nonatomic, weak) UIButton * signInBtn;
@end

@implementation YYSignInController

- (instancetype)init{
    if (self = [super init]) {

        //根据时间增加imageView到View上
        [self basedOnTimeAddImageViewAndLabel];
        
        //增加今日大事件的View到self.view上
        [self addTodayThingView];
        
        //查询是否签到
        [self getSignIn];
        //获取今日大事件内容
        [self getTodayThing];
        
        //增加立即签到按钮
        [self addSignInBtn];
    
    }
    return self;
}

#pragma mark 搜索是否签到
/**
 *  查询是否签到
 */
- (void)getSignIn{
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"131";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"已签到" forKey:YYSignInToday];
            [self.signInBtn setTitle:@"已签到" forState:UIControlStateDisabled];
            self.signInBtn.enabled = NO;
            
        }
        else if ([responseObject[@"msg"] isEqualToString:@"error"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"未签到" forKey:YYSignInToday];
            [self.signInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
            self.signInBtn.enabled = YES;
        }

    }];
}
/**
 *  根据时间增加imageView和label到View上,
 */
- (void)basedOnTimeAddImageViewAndLabel{
    //增加图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    //增加label
    CGFloat labelY = 15/667.0 * YYHeightScreen + 64;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, YYWidthScreen, 20)];
    [self.view addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat scale = YYWidthScreen/375.0;
    label.font = [UIFont systemFontOfSize:16.0 * scale];
    self.topLabel = label;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HHmmss";
    
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    YYLog(@"%@",currentTime);
    NSString *hourStr = [currentTime substringToIndex:2];
    YYLog(@"%@",hourStr);
    int hour = hourStr.intValue;
    YYLog(@"%d",hour);
    if (hour >= 0 && hour < 6) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_night"];
        label.text = @"夜深人静的时候，小pú一直在您身边";
    }
    else if (hour >= 6 && hour < 9) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_earlyMorning"];
        label.text = @"一日之计在于晨，新的一天从此开始";
    }
    else if (hour >= 9 && hour < 11) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_morning"];
        label.text = @"一日之计在于晨，新的一天从此开始";
    }
    else if (hour >= 11 && hour < 13) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_noon"];
        label.text = @"休息时刻，看看电商大世界的动态吧";
    }
    else if (hour >= 13 && hour <= 16) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_afternoon"];
        label.text = @" 来一杯下午茶儿，美好午后有我陪你";
    }
    else if (hour > 16 && hour < 19) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_dusk"];
        label.text = @"晚餐时间，小pú给您带来了精神食粮";
    }
    else if (hour >= 19 && hour <= 24) {
        imageView.image = [UIImage imageNamed:@"profile_signIn_night"];
        label.text = @"人未静，夜读书，愿君求学勿忘身心";
    }
}

/**
 *  增加今日大事件的View到self.view上
 */
- (void)addTodayThingView{
    //584  424
    CGFloat thingViewW = 292;
    CGFloat thingViewH = 212;
    CGFloat thingViewX = (YYWidthScreen - thingViewW)/2.0;
    CGFloat thingViewY = YYHeightScreen - YY10HeightMargin - thingViewH;
    UIView *thingView = [[UIView alloc] initWithFrame:CGRectMake(thingViewX, thingViewY, thingViewW, thingViewH)];
    [self.view addSubview:thingView];
    self.thingView = thingView;
    
    //增加背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:thingView.bounds];
    [thingView addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"profile_signIn_thing"];
    
    //增加今日大事件中的Label
    CGFloat thingLabelY = 80 + 6;
    _thingLabelMaxH = thingViewH - thingLabelY - 11;
    CGFloat thingLabelX = 20;
    _thingLabelMaxW = thingViewW - thingLabelX * 2;
    
    UILabel *thingLabel = [[UILabel alloc] initWithFrame:CGRectMake(thingLabelX, thingLabelY, _thingLabelMaxW, _thingLabelMaxH)];
    [thingView addSubview:thingLabel];
 
    self.thingLabel = thingLabel;
    self.thingLabel.numberOfLines = 0;
    self.thingLabel.textColor = [UIColor colorWithRed:29/255.0 green:41/255.0 blue:90/255.0 alpha:1.0];
    
#pragma mark 先设置前面获取的文字
    YYMainDataModel *model = [YYMainDataTool mainModel];
    [self setTodayThingWithString:model.todayThing];
    
}
#pragma mark 搜索今日大事件
/**
 *  查询今日大事件
 */
- (void)getTodayThing{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"4";
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"出错%@",error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *retDic = responseObject[@"ret"];
            
            NSString *thingStr = retDic[@"content"];
            
            [self setTodayThingWithString:thingStr];
            YYMainDataModel *model = [[YYMainDataModel alloc] init];
            model.todayThing = thingStr;
            
            [YYMainDataTool saveMainModelWithModel:model];
            
        }
    }];
}
/**
 *  设置今日大事件中的文字
 */
- (void)setTodayThingWithString:(NSString *)todayThing{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:todayThing];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    
    NSRange range = NSMakeRange(0, todayThing.length);
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:17.0];
    
    [attributeStr setAttributes:attr range:range];
    
    CGFloat thingLabelH = [todayThing boundingRectWithSize:CGSizeMake(_thingLabelMaxW, _thingLabelMaxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    self.thingLabel.height = thingLabelH;
    self.thingLabel.attributedText = attributeStr;
}
/**
 *  增加立即签到按钮
 */
- (void)addSignInBtn{
    //360,108
    CGFloat scale = YYWidthScreen/375.0;
    CGFloat btnH = 54 * scale;
    CGFloat btnW = 180 * scale;
    CGFloat btnX = (YYWidthScreen - btnW)/2.0;
    CGFloat btnY = CGRectGetMinY(self.thingView.frame) - 2 * YY12HeightMargin - btnH;
    UIButton *btn = [YYPugongyingTool createBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH) superView:self.view backgroundImage:[UIImage imageNamed:@"profile_signIn_btn"] titleColor:[UIColor colorWithRed:29/255.0 green:41/255.0 blue:90/255.0 alpha:1.0] title:nil];
    self.signInBtn = btn;
    [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"profile_signIn_btn"] forState:UIControlStateDisabled];
    [self.signInBtn setTitleColor:YYGrayText140Color forState:UIControlStateDisabled];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:YYSignInToday] isEqualToString:@"已签到"]) {
        [self.signInBtn setTitle:@"已签到" forState:UIControlStateDisabled];
        self.signInBtn.enabled = NO;
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:YYSignInToday] isEqualToString:@"未签到"]){
        [self.signInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        self.signInBtn.enabled = YES;
    }
    else{
        [self.signInBtn setTitle:@"已签到" forState:UIControlStateDisabled];
        self.signInBtn.enabled = NO;

    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:24.0 * scale];
    [btn addTarget:self action:@selector(signInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 *  立即签到按钮被点击   mode: 24,userid: 1
 */
- (void)signInBtnClick:(UIButton *)btn{
    [MBProgressHUD showMessage:@"正在签到"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:YYHTTPInsertPOST] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"24";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults]objectForKey:YYUserID];
    
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"签到失败，请重新签到"];
        return;
    }
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        
        if (connectionError) {
            [MBProgressHUD showError:@"签到失败，请重新签到"];
            return;
        }
        
        NSError *dicError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
        YYLog(@"%@签到",dic);
        if (dicError) {
            [MBProgressHUD showError:@"签到失败，请重新签到"];
            return;
        }
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            [self.signInBtn setTitle:@"已签到" forState:UIControlStateDisabled];
            [[NSUserDefaults standardUserDefaults] setObject:@"已签到" forKey:YYSignInToday];
            [[NSUserDefaults standardUserDefaults] synchronize];
       
            NSString *day = [NSString stringWithFormat:@"%@",dic[@"signday"]];
            [self signinSuccessWithSignDay:day];
        }
        
    }];
    
}
/**
 *  签到成功
 */
- (void)signinSuccessWithSignDay:(NSString *)signDay{
    //增加一层遮挡的模版
    UIView * coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:coverView];
    
    self.coverView = coverView;
    self.coverView.alpha = 0;
    
    //555,473增加签到后出现的View800,600
    CGFloat signInViewW = 555/2.0;
    CGFloat signInViewH = 473/2.0;
    //    CGFloat signInViewW = 800/2.0;
    //    CGFloat signInViewH = 600/2.0;
    CGFloat signInViewX = (YYWidthScreen - signInViewW) / 2.0;
    CGFloat signInViewY = (YYHeightScreen - signInViewH) / 2.0;
    [self addSignInViewToCoverViewWithFrame:CGRectMake(signInViewX, signInViewY, signInViewW, signInViewH) andSignDay:signDay];
    
    //执行动画
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"signInMusic.wav" withExtension:nil];
    if (fileURL != nil)
    {
        SystemSoundID theSoundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
        if (error == kAudioServicesNoError){
            SystemSoundID soundID = theSoundID;
            AudioServicesPlaySystemSound(soundID);
        }else {
            NSLog(@"Failed to create sound ");
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = 1.0;
    }];

}
/**
 *  测试
 */
- (void)text{
    //增加连续登录天数Label
    CGFloat labelH = 20;
    CGFloat label1Y = 100;
    
    UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label1Y, 300, labelH)];
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:daysLabel];
    daysLabel.textAlignment = NSTextAlignmentCenter;
    daysLabel.font = [UIFont systemFontOfSize:17.0];
    
    NSString *signDay = @"1";
    NSString *signday = [NSString stringWithFormat:@"已连续登陆%@天",signDay];
    NSRange range1 = [signday rangeOfString:@"天"];
    NSMutableAttributedString *signdayAttribute = [[NSMutableAttributedString alloc] initWithString:signday];
    NSUInteger location = range1.location;
    NSRange signdayRange = NSMakeRange(location - signDay.length, signDay.length);
    [signdayAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21.0] range:signdayRange];
    [signdayAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:signdayRange];
    daysLabel.text = signday;
    daysLabel.attributedText = signdayAttribute;
    
    //增加获得种子数量Label
    CGFloat label2Y = CGRectGetMaxY(daysLabel.frame) + 8;
    UILabel *seedsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label2Y, 300, labelH)];
    [window addSubview:seedsLabel];
    seedsLabel.font = [UIFont systemFontOfSize:17.0];
    
    
    NSString *seedNum = @"今日签到获得1颗种子";
    NSRange seedRange = [seedNum rangeOfString:@"1"];
    NSMutableAttributedString *seedNumAttr = [[NSMutableAttributedString alloc] initWithString:seedNum];
    [seedNumAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21.0] range:seedRange];
    [seedNumAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:seedRange];
    seedsLabel.text = seedNum;
    seedsLabel.attributedText = seedNumAttr;
    seedsLabel.textAlignment = NSTextAlignmentCenter;
}

/**
 *  增加签到后出现的View
 */
- (void)addSignInViewToCoverViewWithFrame:(CGRect)signViewFrame andSignDay:(NSString *)signDay{
    UIView *signInView = [[UIView alloc] initWithFrame:signViewFrame];
    [self.coverView addSubview:signInView];
    //
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:signInView.bounds];
    [signInView addSubview:bgImageView];

    bgImageView.image = [UIImage imageNamed:@"profile_signIn_buling"];


    //增加连续登录天数Label
    CGFloat labelH = 20;
    CGFloat label1Y = 100;
    CGFloat labelW = signViewFrame.size.width;
    
    UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label1Y, labelW, labelH)];
    [signInView addSubview:daysLabel];
    daysLabel.textAlignment = NSTextAlignmentCenter;
    daysLabel.font = [UIFont systemFontOfSize:19.0];
    self.daysLabel = daysLabel;
    
    NSString *signday = [NSString stringWithFormat:@"已连续登陆%@天",signDay];
    NSRange range1 = [signday rangeOfString:@"天"];
    NSMutableAttributedString *signdayAttribute = [[NSMutableAttributedString alloc] initWithString:signday];
    NSUInteger location = range1.location;
    NSUInteger length = signDay.length;
//    NSRange signdayRange = NSMakeRange(location - signDay.length, signDay.length);
    NSRange signdayRange = NSMakeRange(location - length, length);
    [signdayAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21.0] range:signdayRange];
    [signdayAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:signdayRange];
    self.daysLabel.text = signday;
    self.daysLabel.attributedText = signdayAttribute;

    //增加获得种子数量Label
    CGFloat label2Y = CGRectGetMaxY(daysLabel.frame) + 8;
    UILabel *seedsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label2Y, labelW, labelH)];
    [signInView addSubview:seedsLabel];
    self.seedsLabel = seedsLabel;
    self.seedsLabel.font = [UIFont systemFontOfSize:19.0];
    
    
    NSString *seedNum = @"今日签到获得1颗种子";
    NSRange seedRange = [seedNum rangeOfString:@"1"];
    NSMutableAttributedString *seedNumAttr = [[NSMutableAttributedString alloc] initWithString:seedNum];
    [seedNumAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21.0] range:seedRange];
    [seedNumAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:seedRange];
    self.seedsLabel.text = seedNum;
    self.seedsLabel.attributedText = seedNumAttr;
    self.seedsLabel.textAlignment = NSTextAlignmentCenter;
    
    //增加知道了按钮
    CGFloat btnY = CGRectGetMaxY(self.seedsLabel.frame) + 20;
    CGFloat btnH = 30;
    CGFloat btnW = 110;
    CGFloat btnX = (signViewFrame.size.width - btnW)/2.0;
    UIButton *btn = [YYPugongyingTool createBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH) superView:signInView backgroundImage:[UIImage imageNamed:@"profile_signIn_know"] titleColor:[UIColor whiteColor] title:@"朕知道了"];
    [btn addTarget:self action:@selector(knowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
/**
 *  增加签到天数和获得种子数Label
 */
- (void)addSignDayAndSeedNumLabelWithSignViewFrame:(CGRect)signViewFrame{
    
}
/**
 *  签到点击后出现的View中的知道了按钮被点击
 */
- (void)knowBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        self.signInBtn.enabled = NO;
        [self.coverView removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每日签到";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
