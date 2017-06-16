//
//  YYBusinessNoAuthViewController.m
//  pugongying
//
//  Created by wyy on 16/3/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYBusinessNoAuthViewController.h"

@interface YYBusinessNoAuthViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**
 *  企业姓名TextField
 */
@property (nonatomic, weak) UITextField *businessNameTextField;
/**
 *  营业执照号码TextField
 */
@property (nonatomic, weak) UITextField *businessSorttextField;
/**
 *  提交营业执照按钮
 */
@property (nonatomic, weak) UIButton *uploadPicBtn;
/**
 *  是否提交过照片
 */
@property (nonatomic, assign, getter=isUploadPic) BOOL uploadPic;
/**
 *  提交申请按钮
 */
@property (nonatomic, weak) UIButton *postApplyBtn;
@end

@implementation YYBusinessNoAuthViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    // 增加遮盖层
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加填写企业信息的View
    CGFloat viewY = YY12HeightMargin * 2 + 64;
    
    [self addPersonDataHaveTextFieldViewWithFrame:CGRectMake(0, viewY, YYWidthScreen, 100)];
    
    //增加添加营业执照的按钮
    CGFloat uploadPicBtnW = 225;
    CGFloat uploadPicBtnH = 145;
    CGFloat uploadPicBtnX = (YYWidthScreen - uploadPicBtnW)/2.0;
    CGFloat uploadPicBtnY = viewY + 100 + 5 * YY10HeightMargin;
    [self addIDCardImageBtnWithFrame:CGRectMake(uploadPicBtnX, uploadPicBtnY, uploadPicBtnW, uploadPicBtnH)];
    
    //增加上传图片的名称label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, uploadPicBtnY + uploadPicBtnH + YY10HeightMargin, YYWidthScreen, 20)];
    label.text = @"营业执照";
    label.textColor = YYGrayTextColor;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    //增加提交申请按钮
    CGFloat uploadApplyBtnY = uploadPicBtnY + uploadPicBtnH + 5 *YY10HeightMargin;
    [self adduploadApplyBtnWithFrame:CGRectMake(0, uploadApplyBtnY, YYWidthScreen, 50)];
}
#pragma mark 增加添加营业执照的按钮
- (void)addIDCardImageBtnWithFrame:(CGRect)btnFrame{
    UIButton *uploadPicBtn = [YYPugongyingTool createBtnWithFrame:btnFrame superView:self.view backgroundImage:nil titleColor:nil title:nil];
    self.uploadPicBtn = uploadPicBtn;
    
    [uploadPicBtn setImage:[UIImage imageNamed:@"profile_upload_pic"] forState:UIControlStateNormal];
    
    [uploadPicBtn addTarget:self action:@selector(uploadPicBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 上传营业执照按钮被点击
- (void)uploadPicBtnClick{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选择本机相片" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];

}
#pragma mark UIActionSheet的代理方法被点击
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *ipC = [[UIImagePickerController alloc] init];
    ipC.allowsEditing = YES;
    ipC.delegate = self;
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            ipC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
    }
    else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            ipC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:ipC animated:YES completion:nil];
}
#pragma mark UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    [self.uploadPicBtn setImage:editImage forState:UIControlStateNormal];
    self.uploadPic = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 增加增加提交申请按钮
- (void)adduploadApplyBtnWithFrame:(CGRect)btnFrame{
    UIButton *btn = [YYPugongyingTool createBtnWithFrame:btnFrame superView:self.view backgroundImage:nil titleColor:[UIColor colorWithRed:240/255.0 green:96/255.0 blue:86/255.0 alpha:1.0] title:@"提交申请"];
    
    self.postApplyBtn = btn;
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:btn];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, btnFrame.size.height - 0.5, YYWidthScreen, 0.5) andView:btn];
    
    [btn addTarget:self action:@selector(uploadApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 提交申请按钮被点击
- (void)uploadApplyBtnClick{
    YYLog(@"提交申请按钮被点击");
    NSString *realName = self.businessNameTextField.text;
    NSString *idCard = self.businessSorttextField.text;
    if (realName.length == 0) {
        [MBProgressHUD showError:@"请输入企业名称"];
        return;
    }
    else if (idCard.length == 0){
        [MBProgressHUD showError:@"请输入营业执照号"];
        return;
    }
//    else if (idCard.length != 18){
//        [MBProgressHUD showError:@"身份证号码不正确"];
//        return;
//    }
    if (self.isUploadPic == NO) {
        [MBProgressHUD showError:@"请上传营业执照"];
        return;
    }
    
    [self businessNameAuthWithBusinessName:realName andbusinessCard:idCard];
}
#pragma mark 公司实名认证信息提交
- (void)businessNameAuthWithBusinessName:(NSString *)realName andbusinessCard:(NSString *)IDCard{
    self.postApplyBtn.enabled = NO;
    
    NSURL *url = [NSURL URLWithString:YYHTTPInsertPOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10];
      
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mode"] = @"13";
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:YYUserID];
    parameters[@"company"] = realName;
    parameters[@"license"] = IDCard;
    
    NSData *imageData = UIImageJPEGRepresentation(self.uploadPicBtn.imageView.image, 0.3);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    parameters[@"licenseimg"] = imageStr;
    
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        YYLog(@"转换json出错%@",error);
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            
            [MBProgressHUD showError:@"网络请求失败"];
            return ;
        }
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        YYLog(@"%@",dic);
        if([dic[@"msg"] isEqualToString:@"ok"]){
          
            [MBProgressHUD showSuccess:@"公司认证申请已提交"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.postApplyBtn.enabled = YES;
        YYLog(@"解析数据%@\n\n错误%@",dic,error);
    }];
    
}
#pragma mark 遮盖层被点击
- (void)coverBtnClick{
    [self.view endEditing:YES];
}
#pragma mark 增加填写企业信息的View
- (void)addPersonDataHaveTextFieldViewWithFrame:(CGRect)viewFrame{
    UIView *superView = [[UIView alloc] initWithFrame:viewFrame];
    [self.view addSubview:superView];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, 0, YYWidthScreen, 0.5) andView:superView];
    //增加真实姓名Label和textfield
    CGFloat realNameTextFieldH = viewFrame.size.height/2.0;
    self.businessNameTextField = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, 0, 85, realNameTextFieldH) toSuperView:superView labelText:@"企业名称："];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(YY18WidthMargin, viewFrame.size.height/2.0 -0.5, YYWidthScreen - YY18WidthMargin * 2, 0.5) andView:superView];
    
    //增加身份证号码Label和textfield
    self.businessSorttextField = [self addLabelWithLabelFrame:CGRectMake(YY18WidthMargin, realNameTextFieldH, 100, realNameTextFieldH) toSuperView:superView labelText:@"营业执照号："];
    
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(0, viewFrame.size.height - 0.5, YYWidthScreen, 0.5) andView:superView];
    
    
}
#pragma mark 增加Label和textField
- (UITextField *)addLabelWithLabelFrame:(CGRect)labelFrame toSuperView:(UIView *)superView labelText:(NSString *)labelTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = YYGrayTextColor;
    label.text = labelTitle;
    [superView addSubview:label];
    label.font = [UIFont systemFontOfSize:16];
    
    CGFloat textFieldX = labelFrame.origin.x + labelFrame.size.width + 5;
    CGFloat textFieldW = YYWidthScreen - textFieldX - YY18WidthMargin;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, labelFrame.origin.y, textFieldW, labelFrame.size.height)];
    [superView addSubview:textField];
    
    return textField;
    
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
