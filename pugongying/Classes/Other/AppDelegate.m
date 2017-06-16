 //
//  AppDelegate.m
//  pugongying
//
//  Created by wyy on 16/2/22.
//  Copyright © 2016年 WYY. All rights reserved.
//／／／TD2DR3SFY7.com.pugongying.app

/**
 *  app的版本号
 */
#define YYAppVersion @"YYAppVersion"

#import "AFNetworking.h"
/**
 *  课程,义诊,资讯分类模型
 */
#import "YYCourseCategoryModel.h"
#import "YYClinicCategoryModel.h"
#import "YYNewsCategoryModel.h"

#import "YYUserTool.h"


#define YYFirstStart @"YYFirstStart"
#import "YYWelcomeViewController.h"

#import "AppDelegate.h"
#import "YYTabBarController.h"

#import <SMS_SDK/SMSSDK.h>

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
////SMSSDK官网公共key
//#define appkey @"f3fc6baa9ac4"
//#define app_secrect @"7f3dedcb36d92deebcb373af921d635a"
//自己的
#define appkey @"10cc9fbeeff48"
#define app_secrect @"4d3868d340e468d206802696dfcc525f"


#define YYUserModelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selfuser.plist"]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //查询今日大事件
    [self getTodayThing];
    [self getNetState];
    //获取课程资讯的分类
    [self getAllCategoryArray];
    //获取义诊分类数组
    [self getClinicCategoryArray];
    //查询资讯分类
    [self getNewsCategory];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    if (userID) {
        //查询个人信息
        [self selectUserMessageWithUserid:userID];
        //查询是否签到
        [self getSignIn];
        //获取义诊进度
        [self getClinicProgress];
    }
    
    [self.window makeKeyAndVisible];
    //把第一次加载页面的值全置为yes
    [self firstLoadSetYes];
    NSString *versionstr = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:YYAppVersion];
    
    if ([lastVersion isEqualToString:versionstr]) {
        self.window.rootViewController = [[YYTabBarController alloc] init];
    }
    else{
        [defaults setObject:versionstr forKey:YYAppVersion];
        [defaults synchronize];
        [self clearCache:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
        self.window.rootViewController = [[YYWelcomeViewController alloc] init];
    }
    
#pragma mark 注册发送验证码
    [SMSSDK registerApp:appkey
             withSecret:app_secrect];
    
    // 分享的代码
    [self shareCode];

    return YES;
    
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
            YYLog(@"有错误：%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *retDic = responseObject[@"ret"];
            
            NSString *thingStr = retDic[@"content"];
            
            YYMainDataModel *model = [[YYMainDataModel alloc] init];
            model.todayThing = thingStr;
            
            [YYMainDataTool saveMainModelWithModel:model];
        }

    }];
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

#pragma mark 获取用户信息
- (void)selectUserMessageWithUserid:(NSString *)userId{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"11";
    
    parameters[@"userid"] = userId;
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//查询用户信息成功
            NSDictionary *ret = responseObject[@"ret"];
            
            YYUserModel *userModel = [[YYUserModel alloc] init];
            
            [userModel setValuesForKeysWithDictionary:ret];
            
            [YYUserTool saveUserModelWithModel:userModel];
        }
    }];
}
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
            YYLog(@"有错误：%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *dic = responseObject[@"ret"];
            NSString *state = dic[@"donestate"];
            [[NSUserDefaults standardUserDefaults]setObject:state forKey:YYCurrentClinicProgress];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}
#pragma mark 搜索是否签到
/**
 *  搜索是否签到
 */
- (void)getSignIn{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"131";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"已签到" forKey:YYSignInToday];
        }
        else if ([responseObject[@"msg"] isEqualToString:@"error"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"未签到" forKey:YYSignInToday];
        }

    }];
}
#pragma mark 查询资讯，课程，义诊分类
/**
 *  查询资讯分类
 */
- (void)getNewsCategory{
    YYLog(@"查询资讯分类");
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"1";
    parameters[@"module"] = @"news";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        NSMutableArray *categoryArray = [NSMutableArray array];
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSArray *array = responseObject[@"ret"];
            for (NSDictionary *dic in array) {
                NSString *categoryID = dic[@"id"];
                NSString *categoryNewNum = dic[@"newsnum"];
                NSString *categoryName = dic[@"name"];
                
                YYNewsCategoryModel *model = [[YYNewsCategoryModel alloc] initWithnewsCategoryID:categoryID newsCategoryName:categoryName newsCategoryNewsNum:categoryNewNum];
                
                [categoryArray addObject:model];
            }
            NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:YYNewsCategoryArrayPath];
            [NSKeyedArchiver archiveRootObject:categoryArray toFile:path];
        }

    }];
}
/**
 *  获取课程的分类
 */
- (void)getAllCategoryArray{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"1";
    parameters[@"module"] = @"course";
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSArray *cateArray = responseObject[@"ret"];
            [self analysisCourseCategoryArray:cateArray];
        }
    }];
}
/**
 * 解析课程分类数组
 */
- (void)analysisCourseCategoryArray:(NSArray *)categoryArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in categoryArray) {
        //分类id
        NSString *categoryID = dic[@"id"];
        //类名
        NSString *categoryName = dic[@"name"];
        //图标地址
        NSString *categoryIcon = dic[@"iconimgurl"];
        //拥有的课程数
        NSString *categoryCourseNum = dic[@"coursenum"];
        
        YYCourseCategoryModel *model = [[YYCourseCategoryModel alloc] initWithCategoryID:categoryID categoryName:categoryName categoryIcon:categoryIcon categoryCourseNum:categoryCourseNum];
        
        [array addObject:model];
    }
    
    NSString *categoryPath = [[NSUserDefaults standardUserDefaults] objectForKey:YYCourseCategoryArrayPath];
//    YYLog(@"%@",categoryPath);
    [NSKeyedArchiver archiveRootObject:array toFile:categoryPath];
    
}
/**
 *  获取义诊分类数组
 */
- (void)getClinicCategoryArray{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"1";
    parameters[@"module"] = @"clinic";
    
    [NSObject GET:YYHTTPSelectGET parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            YYLog(@"有错误：%@", error);
            return;
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSMutableArray *array = [NSMutableArray array];
            
            NSArray *cateArray = responseObject[@"ret"];
            for (NSDictionary *dic in cateArray) {
                YYClinicCategoryModel *model = [[YYClinicCategoryModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                
                [array addObject:model];
            }
            NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:YYClinicCategoryArrayPath];
            //            YYLog(@"%@",path);
            [NSKeyedArchiver archiveRootObject:array toFile:path];
        }

    }];
}

/**
 *  分享的代码
 */
- (void)shareCode{
    [ShareSDK registerApp:@"10cc9a49a1a30"
     
          activePlatforms:@[
                            //                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            //                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
                 //             case SSDKPlatformTypeQQ:
                 //                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 //                 break;
                 //             case SSDKPlatformTypeSinaWeibo:
                 //                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 //             case SSDKPlatformTypeSinaWeibo:
                 //                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 //                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                 //                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                 //                                         redirectUri:@"http://www.sharesdk.cn"
                 //                                            authType:SSDKAuthTypeBoth];
                 //                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx99cdd36b87493226"
                                       appSecret:@"492d66f32599b66c0ec4d4f633c4a30d"];
                 break;
                 //             case SSDKPlatformTypeQQ:
                 //                 [appInfo SSDKSetupQQByAppId:@"100371282"
                 //                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                 //                                    authType:SSDKAuthTypeBoth];
                 //                 break;
                 //             case SSDKPlatformTypeRenren:
                 //                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                 //                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                 //                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                 //                                               authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];

}
#pragma mark 把第一次加载页面的值全置为yes
- (void)firstLoadSetYes{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:YYFirstNews];
    [defaults setBool:YES forKey:YYFirstStory];
    [defaults setBool:YES forKey:YYFirstCourse];
    [defaults setBool:YES forKey:YYUpdateYizhen];
    
    /**
     *  获取分类数组的路径，存入配置文件
     */
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *courseCategoryPath = [path stringByAppendingPathComponent:@"courseCategoryArray.plist"];
    [defaults setObject:courseCategoryPath forKey:YYCourseCategoryArrayPath];
    /**
     *  资讯分类路径
     */
    NSString *newsPath = [path stringByAppendingPathComponent:@"newsCategoryArray.plist"];
    [defaults setObject:newsPath forKey:YYNewsCategoryArrayPath];
    /**
     *  义诊分类路径
     */
    NSString *clinicPath = [path stringByAppendingPathComponent:@"clinicCategoryArray.plist"];
    [defaults setObject:clinicPath forKey:YYClinicCategoryArrayPath];
    
    [defaults synchronize];
}
#pragma mark 监听网络状态
- (void)getNetState{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSUserDefaults standardUserDefaults] setInteger:status forKey:YYNetworkState];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable://0
                YYLog(@"没有网络连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://1
                YYLog(@"流量网络连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://2
                YYLog(@"无线网络连接");
                break;
            default:
                break;
        }
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
////    YYLog(@"%d",self.allScreen);
//    if (self.allScreen) {
//        return UIInterfaceOrientationMaskLandscapeRight;
//        
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
////  每次试图切换的时候都会走的方法,用于控制设备的旋转方向.
//-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (_isRotation) {
//        return UIInterfaceOrientationMaskLandscape;
//    }else {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    
//}
@end
