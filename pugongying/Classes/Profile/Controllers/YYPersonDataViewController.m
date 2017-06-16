//
//  YYPersonDataViewController.m
//  pugongying
//
//  Created by wyy on 16/3/12.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYPersonDataViewController.h"
#import "YYAuthMeController.h"
#import "YYNoAuthMeController.h"
#import "YYBusinessNoAuthViewController.h"
#import "YYBusinessAuthViewController.h"
#import "YYUserTool.h"
#import "YYChangeNameViewController.h"


@interface YYPersonDataViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**
 *  头像信息的view
 */
@property (weak, nonatomic) IBOutlet UIView *iconMessageView;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
/**
 *  点击设置头像Label
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomIconLabel;
/**
 *  用户信息的View
 */
@property (weak, nonatomic) IBOutlet UIView *personDataView;
/**
 *  用户昵称Label
 */
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
/**
 *  用户昵称显示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/**
 *  真实姓名Label
 */
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
/**
 *  真实姓名认证Label
 */
@property (weak, nonatomic) IBOutlet UILabel *realNameAuthLabel;
///**
// *  企业Label
// */
//@property (weak, nonatomic) IBOutlet UILabel *busnissLabel;
///**
// *  企业认证Label
// */
//@property (weak, nonatomic) IBOutlet UILabel *busnissAuthLabel;
/**
 *  认证图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;

/**
 *  用户昵称按钮被点击
 */
- (IBAction)userNameBtnClick;

/**
 *  真实姓名按钮被点击
 */
- (IBAction)realNameBtnClick;
///**
// *  企业按钮被点击
// */
//- (IBAction)busnissBtnClick;
/**
 *  头像上的按钮被点击
 */
- (IBAction)iconBtnClick;
@end

@implementation YYPersonDataViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置控件
    [self setControls];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    YYUserModel *model = [YYUserTool userModel];
    
    //判断是否认证
    if ([model.regstate isEqualToString:@"已认证"] | [model.authstate isEqualToString:@"已认证"]) {
        self.authImageView.image = [UIImage imageNamed:@"profile_authent"];
    }
    else{
        self.authImageView.image = [UIImage imageNamed:@"profile_noauthent"];
    }
    
    self.title = @"个人资料";
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置控件
    [self setControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNickName) name:YYUserChangeName object:nil];
}
#pragma mark 修改昵称
- (void)changeNickName{
    
    YYUserModel *model = [YYUserTool userModel];
    self.userNameLabel.text = model.nickname;
}
- (void)setControls{
    /**
     *  用户头像
     */
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.width/2.0;
    self.userIconImageView.layer.masksToBounds = YES;
    if ([YYUserTool userModel].headimgurl) {
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:[YYUserTool userModel].headimgurl] placeholderImage:[UIImage imageNamed:@"profile_iconmoren"]];
    }
    else{
        self.userIconImageView.image = [UIImage imageNamed:@"profile_iconmoren"];
    }

    /**
     *  点击设置头像Label
     */
    self.bottomIconLabel.textColor = YYGrayText140Color;
    self.bottomIconLabel.font = [UIFont systemFontOfSize:14.0];
    /**
     *  用户信息的View增加线条
     */
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:self.personDataView];
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, self.personDataView.height - 0.5, YYWidthScreen, 0.5) andView:self.personDataView];
    
    CGFloat cellHeight = self.personDataView.height/2.0;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(16, cellHeight - 0.5, YYWidthScreen - 32, 0.5) andView:self.personDataView];
    
    /**
     *  用户昵称Label
     */
    self.userLabel.textColor = YYGrayTextColor;
    /**
     *  用户昵称显示Label
     */
    self.userNameLabel.textColor = YYGrayText140Color;
    self.userNameLabel.text = [YYUserTool userModel].nickname;
    /**
     *  真实姓名Label
     */
    self.realNameLabel.textColor = YYGrayTextColor;
    /**
     *  真实姓名认证Label
     */
    self.realNameAuthLabel.textColor = YYGrayText140Color;
    NSString *regState = [YYUserTool userModel].regstate;
    if ([regState isEqualToString:@"已认证"]) {//已认证
        self.realNameAuthLabel.textColor = [UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0];
    }
    else if ([regState isEqualToString:@"认证中"]){
        self.realNameAuthLabel.textColor = [UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0];
    }
    else if ([regState isEqualToString:@"未认证"]){
        self.realNameAuthLabel.textColor = YYGrayText140Color;
    }
    else if ([regState isEqualToString:@"认证失败"]){
        self.realNameAuthLabel.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:0 alpha:1.0];
    }
    self.realNameAuthLabel.text = [YYUserTool userModel].regstate;
    /**
     *  企业Label
     */
//    self.busnissLabel.textColor = YYGrayTextColor;
    /**
     *  企业认证Label
     */
//    NSString *authState = [YYUserTool userModel].authstate;
//    if ([authState isEqualToString:@"已认证"]) {//已认证
//        self.busnissAuthLabel.textColor = [UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0];
//        
//    }
//    else if([authState isEqualToString:@"认证中"]){
//        self.busnissAuthLabel.textColor = [UIColor colorWithRed:94/255.0 green:122/255.0 blue:221/255.0 alpha:1.0];
//        
//    }
//    else if ([authState isEqualToString:@"未认证"]){
//        self.busnissAuthLabel.textColor = YYGrayText140Color;
//    }
//    else if ([authState isEqualToString:@"认证失败"]){
//        self.busnissAuthLabel.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:0 alpha:1.0];
//    }
//
//    self.busnissAuthLabel.text =authState;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

*/
/**
 *  用户昵称按钮被点击
 */
- (IBAction)userNameBtnClick {
  
    YYChangeNameViewController *changeName = [[YYChangeNameViewController alloc] init];
    [self.navigationController pushViewController:changeName animated:YES];
    
}
/**
 *  真实姓名按钮被点击
 */
- (IBAction)realNameBtnClick {
   
    if ([self.realNameAuthLabel.text isEqualToString:@"未认证"]) {//
        
        YYNoAuthMeController *noAuthPerson = [[YYNoAuthMeController alloc] init];
        [self.navigationController pushViewController:noAuthPerson animated:YES];
        
    }
    else{
        YYAuthMeController *auth = [[YYAuthMeController alloc] init];
        [self.navigationController pushViewController:auth animated:YES];
    }
}
/**
 *  企业按钮被点击
 */
//- (IBAction)busnissBtnClick {
//    if ([self.busnissAuthLabel.text isEqualToString:@"未认证"]) {//
//       
//        YYBusinessNoAuthViewController *noAuth = [[YYBusinessNoAuthViewController alloc] init];
//        [self.navigationController pushViewController:noAuth animated:YES];
//    }
//    else{
//        
//        YYBusinessAuthViewController *auth = [[YYBusinessAuthViewController alloc] init];
//        [self.navigationController pushViewController:auth animated:YES];
//    }
//}
/**
 *  头像上的按钮被点击
 */
- (IBAction)iconBtnClick {
  
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择本机相片" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}
#pragma mark UIActionSheet的代理方法被点击
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *ipC = [[UIImagePickerController alloc] init];
    
    ipC.delegate = self;
    ipC.allowsEditing = YES;
    
    if (buttonIndex == 0) {//选择本机照片
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            ipC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:ipC animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1){//拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            ipC.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:ipC animated:YES completion:nil];
            
        }
    }
}
#pragma mark UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    YYLog(@"%@",info);
    [MBProgressHUD showMessage:@"正在修改头像"];
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
   
    NSData *imageData = UIImageJPEGRepresentation(editImage, 0.3);
    editImage = [UIImage imageWithData:imageData];
    
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mode"] = @"23";
    dic[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    dic[@"headimg"] = imageStr;
    
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改头像失败，请重新提交"];
        return;
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [MBProgressHUD hideHUD];
        if (connectionError) {
            [MBProgressHUD showError:@"修改头像失败，请重新提交"];
            YYLog(@"网络请求失败");
            return ;
        }
        
        NSError *dicError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
        YYLog(@"%@",dic);
//        if (dicError) {
//            [MBProgressHUD showError:@"修改头像失败，请重新提交"];
//            return;
//        }
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
//            YYLog(@"修改成功");
            [MBProgressHUD showSuccess:@"成功修改头像"];

            [picker dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(setUserIcon:)]) {
                    [self.delegate setUserIcon:editImage];
                }
                self.userIconImageView.image = editImage;
            }];
            
        }else{
            [MBProgressHUD showError:@"修改头像失败，请重新提交"];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
        YYLog(@"解析数据%@\n\n错误%@",dic,error);
    }];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
