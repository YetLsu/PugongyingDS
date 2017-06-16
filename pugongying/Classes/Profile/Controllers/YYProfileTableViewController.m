//
//  YYProfileTableViewController.m
//  pugongying
//
//  Created by wyy on 16/4/15.
//  Copyright © 2016年 WYY. All rights reserved.
//
/**
 *  我的种子，每日签到等按钮的tag值
 *
 *  我的种子0， 每日签到1
 */
#import "YYProfileTableViewController.h"
#import "YYSetAppTableViewController.h"
#import "YYProfileFirstViewCell.h"
#import "YYProfileFirstViewCellModel.h"

#import "YYCourseCollectController.h"
#import "YYNewsCollectController.h"
#import "YYMyMessageController.h"
#import "YYMySeedTableViewController.h"
#import "YYSignInController.h"

#import "YYNavigationController.h"
#import "YYLoginRegisterViewController.h"

#import "YYUserTool.h"
#import "YYPersonDataViewController.h"


@interface YYProfileTableViewController ()<YYPersonDataViewControllerDelegate>{
    CGFloat _headerImageH;
    CGFloat _headerYizhenStateH;
    CGFloat _progressLabelH;
    CGFloat _yizhenThreeViewH;
    CGFloat _scale;
    CGFloat _yMargin;
    
    NSMutableArray *_profileArray;
}

@property (nonatomic, weak) UIView *headerView;
/**
 *义诊第一个状态，填写提单
 */
@property (nonatomic, weak) UIImageView *firstYizhenStateImageView;
/**
 *义诊第二个状态，等待回复
 */
@property (nonatomic, weak) UIImageView *secondYizhenStateImageView;
/**
 *义诊第三个状态，专家回复
 */
@property (nonatomic, weak) UIImageView *thirdYizhenStateImageView;

/**
 *  头像imageView
 */
@property (nonatomic, weak) UIImageView *headImageView;
/**
 *  昵称label
 */
@property (nonatomic, weak) UILabel *nickNameLabel;
/**
 *  认证图片
 */
@property (nonatomic, weak) UIImageView *authImageView;
/**
 *  登录注册按钮
 */
@property (nonatomic, weak) UIButton *registerLoginBtn;
@end

@implementation YYProfileTableViewController
#pragma mark 获取义诊进度
/**
 *  获取义诊进度
 */
- (void)getClinicProgress{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"43";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"clinicid"] = @"0";
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *dic = responseObject[@"ret"];
            NSString *state = dic[@"donestate"];
            [[NSUserDefaults standardUserDefaults]setObject:state forKey:YYCurrentClinicProgress];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setClinicProgressImagesWithClinicState:state];
        }

    }];
}
#pragma mark 获取用户信息
- (void)selectUserMessageWithUserid:(NSString *)userId{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"11";
    
    parameters[@"userid"] = userId;
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//查询用户信息成功
            NSDictionary *ret = responseObject[@"ret"];
            
            YYUserModel *userModel = [[YYUserModel alloc] init];
            
            [userModel setValuesForKeysWithDictionary:ret];
            
            [YYUserTool saveUserModelWithModel:userModel];
            
            //查询到用户信息后设置界面
            [self setUserMessageAndUpdateViews];
        }
    }];
}
#pragma mark 查询到用户信息后设置界面
/**
 *  查询到用户信息后设置界面
 */
- (void)setUserMessageAndUpdateViews{
    YYUserModel *userModel = [YYUserTool userModel];
    //设置用户头像以及区分是否认证
    if (userModel.headimgurl) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.headimgurl] placeholderImage:[UIImage imageNamed:@"profile_iconmoren"]];
    }
    else{
        self.headImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    }

    YYUserModel *model = [YYUserTool userModel];
    //判断是否认证
    if ([model.authstate isEqualToString:@"已认证"] || [model.regstate isEqualToString:@"已认证"]) {
        self.authImageView.image = [UIImage imageNamed:@"profile_authent"];
    }
    else{
        self.authImageView.image = [UIImage imageNamed:@"profile_noauthent"];
    }
    //设置用户昵称
    self.nickNameLabel.text = userModel.nickname;
    self.nickNameLabel.hidden = NO;

}
- (instancetype) initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
      
    }
    return self;
}
#pragma mark 修改昵称
- (void)changeNickName{
    
    YYUserModel *model = [YYUserTool userModel];
    self.nickNameLabel.text = model.nickname;
}
/**
 *  退出登录
 */
- (void)logoutApp{
    self.headImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    self.nickNameLabel.hidden = YES;
    self.registerLoginBtn.hidden = NO;
    [self setClinicProgressImagesWithClinicState:@"已关闭"];
}
/**
 *  登录通知
 */
- (void)loginApp{
    
    self.nickNameLabel.hidden = NO;
    self.registerLoginBtn.hidden = YES;
    
    [self setUserMessageAndUpdateViews];
    
    [self getClinicProgress];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //获取义诊进度
    [self getClinicProgress];
    
    //设置各个控件的高度
    [self setViewsHeight];
    
    //监听退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutApp) name:YYUserLogoutApp object:nil];
    //监听修改昵称通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNickName) name:YYUserChangeName object:nil];
    //监听登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginApp) name:YYUserLoginApp object:nil];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.view.backgroundColor = YYGrayBGColor;
    
    //增加tableview的headerView
    [self addHeaderView];
    
    //查询用户信息
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    if (userID) {
        [self selectUserMessageWithUserid:userID];
    }
    else{
        self.headImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
        self.nickNameLabel.hidden = YES;
        self.registerLoginBtn.hidden = NO;
    }
}
/**
 *  设置各个控件的高度
 */
- (void)setViewsHeight{
    _scale = YYHeightScreen / 667.0;
    _yMargin = 12 * _scale;
    
    _headerImageH = 64 + _scale * (204 -  64);
    _progressLabelH = 16;
    _yizhenThreeViewH = 45 *_scale;
    _headerYizhenStateH = _progressLabelH + 4 *_yMargin + _yizhenThreeViewH;
    
    _profileArray = [NSMutableArray array];
    
    YYProfileFirstViewCellModel *courseModel = [[YYProfileFirstViewCellModel alloc] initWithIcon:[UIImage imageNamed:@"profile_collectCourse"] title:@"课程收藏" hiddenDian:YES];
    [_profileArray addObject:courseModel];
    
     YYProfileFirstViewCellModel *newsModel = [[YYProfileFirstViewCellModel alloc] initWithIcon:[UIImage imageNamed:@"profile_collectNews"] title:@"文章收藏" hiddenDian:YES];
    [_profileArray addObject:newsModel];
    
    YYProfileFirstViewCellModel *messageModel = [[YYProfileFirstViewCellModel alloc] initWithIcon:[UIImage imageNamed:@"profile_collectMessage"] title:@"我的消息" hiddenDian:YES];
    [_profileArray addObject:messageModel];
   
}
/**
 *  增加tableview的headerView
 */
- (void)addHeaderView{
  
    CGFloat headerViewH = _headerImageH + _headerYizhenStateH - 20;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, headerViewH)];
    self.tableView.tableHeaderView = headerView;
   
    self.headerView = headerView;
    
    //增加上面有背景图片的View
    [self addHaveBGImageView];
    
}
/**
 *  增加上面有背景图片的View
 */
- (void)addHaveBGImageView{
    UIView *bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, _headerImageH)];
    [self.headerView addSubview:bgImageView];
    
    //增加背景图片
    UIImageView *bgImage= [[UIImageView alloc] initWithFrame:bgImageView.bounds];
    bgImage.y = -20;
    bgImage.image = [UIImage imageNamed:@"profile_firstbg"];
    [bgImageView addSubview:bgImage];
    /**
     *  设置按钮
     */
    CGFloat setBtnY = 0;
    CGFloat setBtnW = 44;
    CGFloat setBtnX = YYWidthScreen - YY18WidthMargin - setBtnW;
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(setBtnX, setBtnY, setBtnW, setBtnW)];
    [self.headerView addSubview:setBtn];
    [setBtn setImage:[UIImage imageNamed:@"profile_setBtn"] forState:UIControlStateNormal];
    setBtn.imageView.contentMode = UIViewContentModeCenter;
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加义诊进度的View
    [self addYizhenpProgressView];
    
    //增加头像和昵称以及登录注册按钮
    [self addUserIconAndUserNameAndRegister];
    
    //增加每日签到按钮
    CGFloat btnW = 85 * _scale;
    CGFloat btnH = 30 * _scale;
    CGFloat btnY = _headerImageH * 0.5 - 20;
    [self addOneBtnWithBtnImage:[UIImage imageNamed:@"profile_signin"] andBtnFrame:CGRectMake(0, btnY, btnW, btnH) andTag:0];

    //增加我的种子按钮
    CGFloat myseedBtnX = YYWidthScreen - btnW;
    [self addOneBtnWithBtnImage:[UIImage imageNamed:@"profile_myseed"] andBtnFrame:CGRectMake(myseedBtnX, btnY, btnW, btnH) andTag:1];
}
/**
 *  增加义诊进度的View
 */
- (void)addYizhenpProgressView{
    CGFloat progressY = _headerImageH - 20;
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, progressY, YYWidthScreen, _headerYizhenStateH)];
    [self.headerView addSubview:progressView];
    progressView.backgroundColor = [UIColor whiteColor];
    
    //增加当前义诊进度label
    CGFloat progressLabelW = YYWidthScreen - 2 * YY18WidthMargin;
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, _yMargin, progressLabelW, _progressLabelH)];
    [progressView addSubview:progressLabel];
    progressLabel.textColor = YYGrayText140Color;
    progressLabel.font = [UIFont boldSystemFontOfSize:15.0];
    progressLabel.text = @"当前义诊进度";
    
    //增加横线
    CGFloat progressLineY = _yMargin * 2 + _progressLabelH - 0.5;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, progressLineY, progressLabelW, 0.5) andView:progressView];
    
    //增加义诊三个状态的View
    CGFloat yizhenStateViewY = progressLineY + 0.5 + _yMargin;
    UIView *yizhenStateView = [[UIView alloc] initWithFrame:CGRectMake(YY18WidthMargin, yizhenStateViewY, progressLabelW, _yizhenThreeViewH)];
    [progressView addSubview:yizhenStateView];
    yizhenStateView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    //设置义诊状态View中的三个状态的按钮
    [self setThreeYizhenStateBtnsWithSuperView:yizhenStateView];
}
#pragma mark 设置义诊状态View中的三个状态的按钮
/**
 *  设置义诊状态View中的三个状态的按钮
 */
- (void)setThreeYizhenStateBtnsWithSuperView:(UIView *)superView{
    CGFloat btnW = 66 * _scale;
    CGFloat btnH = 21 * _scale;
    CGFloat btnY = (superView.height - btnH)/2.0;
    
    CGFloat arrowW = 8.5;
    CGFloat allViewsWidth = btnW * 3 + arrowW * 2;
    //前段的间距是按钮与箭头间间距的1.3倍
    CGFloat XMargin = (superView.width - allViewsWidth)/(4 + 2 * 1.3);
    self.firstYizhenStateImageView = [self addImageViewToSuperView:superView andNorImage:nil andImageFrame:CGRectMake(1.3 * XMargin, btnY, btnW, btnH) andTag:1 andXmargin:XMargin];
    
    CGFloat secondX = CGRectGetMaxX(self.firstYizhenStateImageView.frame) + 2 * XMargin + arrowW;
    self.secondYizhenStateImageView = [self addImageViewToSuperView:superView andNorImage:nil andImageFrame:CGRectMake(secondX, btnY, btnW, btnH) andTag:1 andXmargin:XMargin];
    
    CGFloat thirdX = CGRectGetMaxX(self.secondYizhenStateImageView.frame) + 2 * XMargin + arrowW;
    self.thirdYizhenStateImageView = [self addImageViewToSuperView:superView andNorImage:nil andImageFrame:CGRectMake(thirdX, btnY, btnW, btnH) andTag:0 andXmargin:XMargin];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:YYCurrentClinicProgress];
        
        [self setClinicProgressImagesWithClinicState:state];
    }
    else{
        [self setClinicProgressImagesWithClinicState:@"已关闭"];
    }
}
/**
 *  增加一个按钮到父控件并返回该按钮，增加箭头,tag为1就增加箭头，为0不增加
 */
- (UIImageView *)addImageViewToSuperView:(UIView *)superView andNorImage:(UIImage *)norImage andImageFrame:(CGRect)imageFrame andTag:(NSInteger)tag andXmargin:(CGFloat)XMargin{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [superView addSubview:imageView];
    imageView.image = norImage;
   
    if (tag == 1) {
        CGFloat arrowW = 8.5;
        CGFloat arrowH = 11.5;
        CGFloat arrowY = (superView.height - arrowH)/2.0;
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageFrame) + XMargin, arrowY, arrowW, arrowH)];
        arrowImageView.image = [UIImage imageNamed:@"profile_yizhen_arrow"];
        [superView addSubview:arrowImageView];
    }
    
    return imageView;
}

#pragma mark 设置按钮被点击
/**
 *  设置按钮被点击
 */
- (void)setBtnClick{
    [self.navigationController pushViewController:[[YYSetAppTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}
#pragma mark 增加头像和昵称以及登录注册按钮
/**
 *  增加头像和昵称以及登录注册按钮
 */
- (void)addUserIconAndUserNameAndRegister{
    /**
     * 头像imageView
     */
    CGFloat iconH = 80 * _scale;
    CGFloat iconX = (YYWidthScreen - iconH)/2.0;
    CGFloat iconY = -20 + 42;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconH, iconH)];
    [self.headerView addSubview:iconImageView];
    self.headImageView = iconImageView;
    iconImageView.layer.cornerRadius = iconH/2.0;
    iconImageView.layer.masksToBounds = YES;
    /**
     *  在头像上加认证的ImageView
     */
    CGFloat authW = 22 * _scale;
    CGFloat authH = 22 * _scale;
    CGFloat authY = iconY;
    CGFloat authX = iconX + (iconH - authW);
    
    UIImageView *authImageView = [[UIImageView alloc] initWithFrame:CGRectMake(authX, authY, authW, authH)];
    [self.headerView addSubview:authImageView];
    self.authImageView = authImageView;
    
    /**
     * 在头像imageView上加按钮
     */
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(iconX, iconY, iconH, iconH)];
    [self.headerView addSubview:iconBtn];
    [iconBtn addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //未登录状态下增加登陆注册按钮
    CGFloat btnW = 130 * _scale;
    CGFloat btnH = 40 * _scale;
    CGFloat btnX = (YYWidthScreen - btnW)/2.0;
    CGFloat btnY = iconY + iconH + 30/667.0*YYHeightScreen;
    
    UIButton *registerLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [registerLoginBtn setBackgroundImage:[UIImage imageNamed:@"profile_loginRegisterBtn"] forState:UIControlStateNormal];
    [registerLoginBtn setTitle:@"登录／注册" forState:UIControlStateNormal];
    registerLoginBtn.titleLabel.font = [UIFont systemFontOfSize:18.0 * _scale];
    [registerLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerLoginBtn addTarget:self action:@selector(registerLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:registerLoginBtn];
    self.registerLoginBtn = registerLoginBtn;
    self.registerLoginBtn.hidden = YES;
    
    //创建用户名label
    CGFloat userNameLabelY = iconY + iconH + 15/667.0*YYHeightScreen;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, userNameLabelY, YYWidthScreen, btnH)];
    [self.headerView addSubview:userNameLabel];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel = userNameLabel;
    self.nickNameLabel.hidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        [self setUserMessageAndUpdateViews];
    }
    
}
#pragma mark 登陆注册按钮被点击 触发登录动作
/**
 *  登陆注册按钮被点击 触发登录动作
 */
- (void)registerLoginBtnClick{
    
    YYLoginRegisterViewController *loginRegister = [[YYLoginRegisterViewController alloc] init];
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:loginRegister];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark 增加每日签到以及我的种子等其中一个按钮
/**
 *  增加每日签到以及我的种子等其中一个按钮
 */
- (void)addOneBtnWithBtnImage:(UIImage *)btnImage andBtnFrame:(CGRect)btnFrame andTag:(NSInteger)tag{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [btn setImage:btnImage forState:UIControlStateNormal];
    [self.headerView addSubview:btn];
    btn.tag = tag;
    
    [btn addTarget:self action:@selector(oneBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  每日签到以及我的种子等其中一个按钮被点击，tag0每日签到，tag1我的种子
 */
#pragma mark 每日签到以及我的种子等其中一个按钮被点击，tag0每日签到，tag1我的种子
- (void)oneBtnClickWithBtn:(UIButton *)btn{
    //判断用户是否存在
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        [self registerLoginBtnClick];
        return;
    }
    if (btn.tag == 0) {
        YYLog(@"每日签到按钮被点击");
        YYSignInController *signIn = [[YYSignInController alloc] init];
        [self.navigationController pushViewController:signIn animated:YES];
        
    }
    else if (btn.tag == 1){
        YYLog(@"我的种子按钮被点击");
        YYMySeedTableViewController *mySeed = [[YYMySeedTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:mySeed animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark - Table view 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _profileArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYProfileFirstViewCell *cell = [YYProfileFirstViewCell profileFirstViewCellWithTable:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    YYProfileFirstViewCellModel *model = _profileArray[indexPath.row];
    
    cell.model = model;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
#pragma mark - Table view 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _yMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 56 /375.0 * YYWidthScreen;
    
    return rowHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        //去登录页面
        [self registerLoginBtnClick];
        return;
        
    }
    //课程收藏
    if (indexPath.row == 0) {

        YYCourseCollectController *courseCollect = [[YYCourseCollectController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:courseCollect animated:YES];
    }
    else if (indexPath.row == 1){
        YYNewsCollectController *newsCollect = [[YYNewsCollectController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:newsCollect animated:YES];
    }
    else if (indexPath.row == 2){
        YYMyMessageController *myMessage = [[YYMyMessageController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:myMessage animated:YES];
    }
}

#pragma mark 头像按钮被点击
- (void) iconBtnClick{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    if (!userID) {//用户未登录
        
        [self registerLoginBtnClick];
    }
    else{//用户已登录
        YYPersonDataViewController *personData = [[YYPersonDataViewController alloc] init];
        personData.delegate = self;
        [self.navigationController pushViewController:personData animated:YES];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setUserIcon:(UIImage *)image{
    [self selectUserMessageWithUserid:[[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]];
}
#pragma mark 根据义诊进度设置图片
/**
 *  根据义诊进度设置图片
 */
- (void)setClinicProgressImagesWithClinicState:(NSString *)state{
    if ([state isEqualToString:@"已提交"]) {
        self.firstYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen1_sel"];
        self.secondYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen2_nor"];
        self.thirdYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen3_nor"];
    }
    else if ([state isEqualToString:@"等待中"]){
        self.firstYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen1_sel"];
        self.secondYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen2_sel"];
        self.thirdYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen3_nor"];
    }
    else if ([state isEqualToString:@"已关闭"]){
        self.firstYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen1_nor"];
        self.secondYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen2_nor"];
        self.thirdYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen3_nor"];
    }
    else if ([state isEqualToString:@"已完成"]){
        self.firstYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen1_sel"];
        self.secondYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen2_sel"];
        self.thirdYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen3_sel"];
    }
    else{
        self.firstYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen1_nor"];
        self.secondYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen2_nor"];
        self.thirdYizhenStateImageView.image = [UIImage imageNamed:@"profile_yizhen3_nor"];
    }
}

                                       
                                       
@end
