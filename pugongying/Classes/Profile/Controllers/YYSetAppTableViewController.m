//
//  YYSetAppTableViewController.m
//  pugongying
//
//  Created by wyy on 16/3/12.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYSetAppTableViewController.h"
#import "YYUserTool.h"
#import "YYXieYiWebViewController.h"
#import "YYLoginRegisterViewController.h"
#import "YYWriteCommentViewController.h"
#import "YYAboutMeViewController.h"
#import <StoreKit/StoreKit.h>
#import "YYTestOldPasswordController.h"
#import "YYNavigationController.h"

@interface YYSetAppTableViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation YYSetAppTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
            return 5;
        }
        else{
            return 4;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = YYGrayTextColor;
    if (indexPath.section == 0) {
        [self setCacheTableViewCell:cell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else if (indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用户协议";
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"意见反馈";
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"关于我们";
        }
        else if (indexPath.row == 3){
            cell.textLabel.text = @"评分";
        }
        else if (indexPath.row == 4){
            cell.textLabel.text = @"修改密码";
        }

    }

    else if (indexPath.section == 2){
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YYWidthScreen, 50)];
        [cell.contentView addSubview:btn];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:YYBlueTextColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//用户协议
            YYXieYiWebViewController *xieyi = [[YYXieYiWebViewController alloc] initWithFromSet];
            
            [self.navigationController pushViewController:xieyi animated:YES];
        }
        
        else if (indexPath.row == 1){//意见反馈
            //判断用户是否存在
            if (![[NSUserDefaults standardUserDefaults] objectForKey:YYUserID]) {
                [self registerLoginBtnClick];
                return;
            }
            
            YYWriteCommentViewController *write = [[YYWriteCommentViewController alloc] initWithOpinion];
            [self.navigationController pushViewController:write animated:YES];
        }
        else if (indexPath.row == 2){//关于我们
            YYAboutMeViewController *aboutMe = [[YYAboutMeViewController alloc] init];
            [self.navigationController pushViewController:aboutMe animated:YES];
        }
        else if (indexPath.row == 3){//评分
            [MBProgressHUD showMessage:@"正在加载页面..."];
            [self gotoAppStoreScore];
//            NSString *baseUrl =  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1093007098";
//            
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:baseUrl]];
        }
        else if (indexPath.row == 4){
            YYTestOldPasswordController *testOldPassword = [[YYTestOldPasswordController alloc] init];
            [self.navigationController pushViewController:testOldPassword animated:YES];
        }
    }
}
#pragma maerk 去appStore评分
/**
 *  去appStore评分
 */
- (void)gotoAppStoreScore{
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"1093007098"} completionBlock:^(BOOL result, NSError *error) {
         [MBProgressHUD hideHUD];
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}
//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma maerk 退出按钮被点击
- (void)logoutBtnClick{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YYUserID];
    [YYUserTool removeUserModel];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YYUserLogoutApp object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 创建清理缓存单元格
- (void)setCacheTableViewCell:(UITableViewCell *)cell{
    cell.textLabel.text = @"清理缓存";
    
    CGFloat btnW = 100;
    CGFloat btnX = YYWidthScreen - YY18WidthMargin - btnW;
    UIButton *cacheBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, 50)];
    [cell.contentView addSubview:cacheBtn];
    
    float size = [self folderSizeAtPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
    
//    YYLog(@"%f",size);
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:cacheBtn.bounds];
    [cacheBtn addSubview:sizeLabel];
    sizeLabel.textColor = YYGrayTextColor;
    sizeLabel.text = [NSString stringWithFormat:@"%.0fMB",size];
    sizeLabel.textAlignment = NSTextAlignmentRight;
    sizeLabel.font = [UIFont systemFontOfSize:16];
    [cacheBtn addTarget:self action:@selector(cacheBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 清理缓存按钮被点击
- (void)cacheBtnClick{

    [MBProgressHUD showMessage:@"正在清理缓存"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.view addSubview:view];
    [UIView animateWithDuration:1.0 animations:^{
        view.x = 10;
        [self clearCache:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
    } completion:^(BOOL finished) {
        [MBProgressHUD hideHUD];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];

}

#pragma mark 缓存
/**
 * 计算cache中缓存的大小
 */
- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        /**
         * SDWebImage框架自身计算缓存的实现
         */
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
/**
 * 清除cache中缓存
 */
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

/**
 * 计算cache中单个文件的缓存的大小
 */
- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

#pragma mark tableview的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
@end
