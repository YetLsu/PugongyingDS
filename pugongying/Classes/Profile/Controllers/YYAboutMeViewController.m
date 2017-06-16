//
//  YYAboutMeViewController.m
//  pugongying
//
//  Created by wyy on 16/4/22.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYAboutMeViewController.h"
#import "YYXieYiWebViewController.h"

@interface YYAboutMeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconConstraintH;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *pgyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pgyConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1ConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2ConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqLabelConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLabelConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailLabelConstraintH;

@property (weak, nonatomic) IBOutlet UIButton *xieyiBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xieyiBtnConstraintH;

@property (weak, nonatomic) IBOutlet UILabel *banquanLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *banquanLabelConstraintH;
@end

@implementation YYAboutMeViewController

- (IBAction)xueyiBtnClick {
    YYXieYiWebViewController *xieyi = [[YYXieYiWebViewController alloc] initWithFromSet];
    [self.navigationController pushViewController:xieyi animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    
    //设置控件的高度
    [self setConstraintHeight];

    //设置控件的内容
    [self setViewsContentAndFont];
    
    //设置字体颜色
    [self setTitleColor];
    
}
/**
 *  设置字体颜色
 */
- (void)setTitleColor{
    self.pgyLabel.textColor = YYGrayTextColor;
    self.titleLabel.textColor = YYGrayTextColor;
    self.label1.textColor = YYGrayText140Color;
    self.label2.textColor = YYGrayText140Color;
    self.phoneLabel.textColor = YYGrayText140Color;
    self.qqLabel.textColor = YYGrayText140Color;
    self.emailLabel.textColor = YYGrayText140Color;
    [self.xieyiBtn setTitleColor:[UIColor colorWithRed:133/255.0 green:176/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.banquanLabel.textColor = YYGrayText140Color;
}
/**
 *  设置控件的内容
 */
- (void)setViewsContentAndFont{
    self.label1.text = @"       蒲公英电商iOS版是绍兴蒲公英电子商务有限公司推出的服务于电商从业者的交流学习平台。我们致力于帮助电商人更好更快乐的成长。";
    
    self.label2.text = @"在这里，您可以在线观看大量的精品课程；\n在这里，您可以随时随地地向名师专家请教；\n在这里，您可以与志同道合的小伙伴进行交流。";
    
    CGFloat scale = YYHeightScreen / 667.0;
    UIFont *textFont = [UIFont systemFontOfSize:15.0 * scale];
    self.label1.font = [UIFont systemFontOfSize:16.0 * scale];
    self.label2.font = [UIFont systemFontOfSize:15.0 * scale * 0.96];;
    self.phoneLabel.font = textFont;
    self.qqLabel.font = textFont;
    self.emailLabel.font = textFont;
    self.xieyiBtn.titleLabel.font = textFont;
    self.banquanLabel.font = textFont;
    
    self.pgyLabel.font = [UIFont systemFontOfSize:26 * scale];
    self.titleLabel.font = [UIFont systemFontOfSize:19 * scale];
    
}
/**
 *  设置控件的高度
 */
- (void)setConstraintHeight{
    
    CGFloat scale = (YYHeightScreen - 64)/(667.0 - 64);
    
    CGFloat iconH = self.iconImageView.height * scale;
    self.iconConstraintH.constant = iconH;
    
    CGFloat pgyH = self.pgyLabel.height * scale;
    self.pgyConstraintH.constant = pgyH;
    
    CGFloat titleH = self.titleLabel.height * scale;
    self.titleConstraintH.constant = titleH;
    
    CGFloat label1H = self.label1.height * scale;
    self.label1ConstraintH.constant = label1H;
    
    CGFloat label2H = self.label2.height * scale;
    self.label2ConstraintH.constant = label2H;
    
    CGFloat qqLabelH = self.qqLabel.height * scale;
    self.qqLabelConstraintH.constant = qqLabelH;
    
    CGFloat phoneLabelH = self.phoneLabel.height * scale;
    self.phoneLabelConstraintH.constant = phoneLabelH;
    
    CGFloat emailLabelH = self.emailLabel.height * scale;
    self.emailLabelConstraintH.constant = emailLabelH;

    CGFloat xieyiBtnH = self.xieyiBtn.height * scale;
    self.xieyiBtnConstraintH.constant = xieyiBtnH;
    
    CGFloat banquanLabelH = self.banquanLabel.height * scale;
    self.banquanLabelConstraintH.constant = banquanLabelH;
    
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
