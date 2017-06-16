//
//  YYTaobaoScrollerView.m
//  pugongying
//
//  Created by wyy on 16/3/22.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYTaobaoScrollerView.h"
#import "sys/utsname.h"

@interface YYTaobaoScrollerView ()<UITextViewDelegate>

@property (nonatomic, weak) UIButton *coverBtn;

@end
static NSString *placeholderStr = @"小pu温馨提示：请在此输入您对店铺的想法或者总结哦！\n\n如：店铺最近日均销售额、访客数、转化率、主推款的销量等）\n您资料提供的越详细，专家诊断的越精湛噢！";
@implementation YYTaobaoScrollerView
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:btn];
        self.coverBtn = btn;
        [self.coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //增加label和textfield到scroller View
        [self addLabelTextField];
        // 增加按钮选项到scroller View
        
        [self addBtnsToScrollerViewWithFirstBtnY:CGRectGetMaxY(self.storeSellTextField.frame) + YY10HeightMargin];

    }
    return self;
}
#pragma mark 遮盖层被点击
- (void)coverBtnClick{
    [self endEditing:YES];
}

#pragma mark 增加label和textfield到scroller View
- (void)addLabelTextField{
    //增加店铺链接或完整名称:
    CGFloat labelX = YY18WidthMargin + 7;
    CGFloat labelY = YY10HeightMargin;
    CGFloat labelW = 75;
    CGFloat labelH = 30;
    
    CGFloat textfieldX = labelX + labelW + 5;
    CGFloat textfieldW = YYWidthScreen - textfieldX - YY18WidthMargin;
    self.storeAddressTextField = [self addLabelAndTextFieldWithLabelFrame:CGRectMake(labelX, labelY, labelW, labelH) andTextFieldFrame:CGRectMake(textfieldX, labelY, textfieldW, labelH) andlabelText:@"店铺全称:" placeholder:nil withTag:0];
    
    //增加店铺主营产品:
    CGFloat label1W = 110;
    CGFloat label1Y = labelY + labelH + YY10HeightMargin;
    CGFloat textField1X = labelX + label1W + 5;
    CGFloat textField1W = YYWidthScreen - textField1X - YY18WidthMargin;
    self.storeSellTextField = [self addLabelAndTextFieldWithLabelFrame:CGRectMake(labelX, label1Y, label1W, labelH) andTextFieldFrame:CGRectMake(textField1X, label1Y, textField1W, labelH) andlabelText:@"店铺主营产品:" placeholder:nil withTag:0];
}

#pragma mark 添加一个Label和一个TextField到View上 tag为0添加星星 为1不添加
- (UITextField *)addLabelAndTextFieldWithLabelFrame:(CGRect)labelFrame andTextFieldFrame:(CGRect)tfFrame andlabelText:(NSString *)labelText placeholder:(NSString *)placeholder withTag:(int)tag{
    //星星图标长宽7，7.5
    if (tag == 0) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(labelFrame.origin.x - 7, labelFrame.origin.y + 3, 7, 7.5)];
        starImageView.image = [UIImage imageNamed:@"yizhen_redStar"];
        [self addSubview:starImageView];
    }
    
    
    //增加Label
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = labelText;
    label.textColor = YYGrayTextColor;
    [self addSubview:label];
    
    //增加TextField
    UITextField *textField = [[UITextField alloc] initWithFrame:tfFrame];
    textField.placeholder = placeholder;
    [self addSubview:textField];
    
    CGFloat lineX = tfFrame.origin.x;
    CGFloat lineY = CGRectGetMaxY(tfFrame) - 0.5;
    CGFloat lineW = tfFrame.size.width;
    [YYPugongyingTool addLineViewWithFrame:CGRectMake(lineX, lineY, lineW, 0.5) andView:self];
    
    return textField;
}

#pragma mark 增加按钮到scroller View上
- (void)addBtnsToScrollerViewWithFirstBtnY:(CGFloat)firstBtnY{
    CGFloat marginH = YY16HeightMargin;
    CGFloat labelW = 115;
    CGFloat labelH = 30;
    CGFloat labelX = YY18WidthMargin + 7;
    
//    self.firstBtnsArray = [self addBtnToViewWithLabelFrame:CGRectMake(labelX, firstBtnY, labelW, labelH) btnsTitle:@[@"自己做", @"别人做", @"没装修"] labelTitle:@"店铺装修情况:"];
//    self.secondBtnsArray = [self addBtnToViewWithLabelFrame:CGRectMake(labelX, firstBtnY + (labelH + marginH)*1, labelW, labelH) btnsTitle:@[@"自己做", @"有团队", @"有客服"] labelTitle:@"是否专人负责:"];
    self.thirdBtnsArray = [self addBtnToViewWithLabelFrame:CGRectMake(labelX, firstBtnY, labelW, labelH) btnsTitle:@[ @"有美工", @"无美工"] labelTitle:@"是否有请美工:"];
    
//    self.fouthBtnsArray = [self addBtnToViewWithLabelFrame:CGRectMake(labelX, firstBtnY + (labelH + marginH)*3, labelW, labelH) btnsTitle:@[@"直通车", @"做钻展", @"没有做"] labelTitle:@"是否付费推广:"];
    
    self.self.fiveBtnsArray = [self addBtnToViewWithLabelFrame:CGRectMake(labelX, firstBtnY + (labelH + marginH)*1, labelW, labelH) btnsTitle:@[@"全职做", @"偶尔做"] labelTitle:@"店铺操作时间:"];

    //增加下面的补充情况输入框
    CGFloat textViewLabelY = firstBtnY + (labelH + marginH) * 2;
    [self addMessageTextFieldWithY:textViewLabelY];
    
}
#pragma mark 增加一组按钮到View上
- (NSMutableArray *)addBtnToViewWithLabelFrame:(CGRect)labelFrame btnsTitle:(NSArray *)titleArrays labelTitle:(NSString *)labelTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = labelTitle;
    label.textColor = YYGrayTextColor;
    [self addSubview:label];
    
    //星星图标长宽7，7.5
    UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(labelFrame.origin.x - 7, labelFrame.origin.y + 3, 7, 7.5)];
    starImageView.image = [UIImage imageNamed:@"yizhen_redStar"];
    [self addSubview:starImageView];
    
    NSInteger index = 0;
    if ([labelTitle isEqualToString:@"店铺装修情况:"]) {
        index = 0;
    }
    else if ([labelTitle isEqualToString:@"是否专人负责:"]){
        index = 10;
    }
    else if ([labelTitle isEqualToString:@"是否有请美工:"]){
        index = 20;
    }
    else if ([labelTitle isEqualToString:@"是否付费推广:"]){
        index = 30;
    }
    else if ([labelTitle isEqualToString:@"店铺操作时间:"]){
        index = 40;
    }
    NSMutableArray *btnsArray = [NSMutableArray array];
    
    CGFloat btnW = 70/375.0*YYWidthScreen;
    CGFloat btnH = 30;
    CGFloat btnY = labelFrame.origin.y;
    for (int i = 0; i < titleArrays.count; i++) {
        CGFloat btnX = labelFrame.origin.x + labelFrame.size.width + i * btnW;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [self addSubview:btn];
        [btnsArray addObject:btn];
        [btn setTitle:titleArrays[i] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        //设置字体颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithRed:85/255.0 green:116/255.0 blue:202/255.0 alpha:1.0] forState:UIControlStateNormal];
        //设置背景颜色
        if (titleArrays.count == 2) {
            if (i == 0) {
                [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_left_nor"] forState:UIControlStateNormal];
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_center_nor"] forState:UIControlStateNormal];
            }
        }
        else if (titleArrays.count == 3){
            if (i == 0) {
                [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_left_nor"] forState:UIControlStateNormal];
            }
            else if(i == 1){
                [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_center_nor"] forState:UIControlStateNormal];
            }
            else{
                [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_btn_right_nor"] forState:UIControlStateNormal];
            }
            
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_blue_LCR"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"yizhen_blue_LCR"] forState:UIControlStateHighlighted];
        
        btn.userInteractionEnabled = YES;
        btn.tag = index + i;
        
        //        [btn addTarget:self action:@selector(taobaoBtnsClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn addTarget:self action:@selector(taobaoBtnsClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btnsArray;
}

#pragma mark 下面的按钮其中一个被点击
/**
 *  店铺装修情况数组tag0,1,2
 * 是否专人负责数组tag10,11,12
 * 是否有请美工数组tag20,21,22
 * 是否付费推广数组tag30,31,32
 * 店铺操作时间数组tag40,41,42
 */
- (void)taobaoBtnsClickWithBtn:(UIButton *)btn{
//    if (btn.tag/10 == 0) {
//        for (UIButton *subBtn in self.firstBtnsArray) {
//            subBtn.selected = NO;
//        }
//    }
//    else if (btn.tag/10 == 1){
//        //        YYLog(@"店铺装修按钮数组");
//        for (UIButton *subBtn in self.secondBtnsArray) {
//            subBtn.selected = NO;
//        }
//        
//    }
    if (btn.tag/10 == 2){
        //        YYLog(@"是否有请美工按钮数组");
        for (UIButton *subBtn in self.thirdBtnsArray) {
            subBtn.selected = NO;
        }
    }
//    else if (btn.tag/10 == 3){
//        for (UIButton *subBtn in self.fouthBtnsArray) {
//            subBtn.selected = NO;
//        }
//    }
    else if (btn.tag/10 == 4){
//         YYLog(@"店铺操作时间按钮数组");
        for (UIButton *subBtn in self.fiveBtnsArray) {
            subBtn.selected = NO;
        }
    }

    btn.selected = YES;
}
#pragma mark 增加下面的补充情况输入框
- (void)addMessageTextFieldWithY:(CGFloat)textViewY{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY18WidthMargin, textViewY, 300, 30)];
    [self addSubview:titleLabel];
    titleLabel.textColor = YYGrayTextColor;
    titleLabel.text = @"店铺情况补充";
    
    //增加输入框
#pragma mark 根据设备设置textView的高度
    
    CGFloat textViewH = [self getTextViewHeight];
    
    CGFloat textViewX = YY18WidthMargin;
    CGFloat textViewW = YYWidthScreen - 2 * YY18WidthMargin;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewX, textViewY + 30 + YY10HeightMargin, textViewW, textViewH)];
    [self addSubview:textView];
    UIImageView *textImage = [[UIImageView alloc] initWithFrame:CGRectMake(textViewX, textViewY + 30 + YY10HeightMargin, textViewW, textViewH)];
    textImage.image = [UIImage imageNamed:@"yizhen_textViewBG"];
    [self addSubview:textImage];
    self.textView = textView;
    
    CGFloat scrollerViewH = CGRectGetMaxY(textView.frame) + 3 * YY10HeightMargin;
    if (scrollerViewH < self.height) {
        scrollerViewH = self.height;
    }
    self.contentSize = CGSizeMake(YYWidthScreen, scrollerViewH);
    
    //设置输入框
    [self setTextView];
}
#pragma mark 设置输入框
- (void)setTextView{
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.text = placeholderStr;
    self.textView.textColor = YYGrayLineColor;
    self.textView.delegate = self;
    //监听输入框开始输入文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginWrite1) name:UITextViewTextDidBeginEditingNotification object:self.textView];
    //监听输入框正在输入文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowWrite1) name:UITextViewTextDidChangeNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endWrite1) name:UITextViewTextDidEndEditingNotification object:self.textView];
}


#pragma mark 监听输入框的方法
/**
 *  检测是否有输入的文字，yes表示有，no表示没有
 */
- (void)beginWrite1{
   YYLog(@"输入框开始输入");
    if (self.isHaveWriteText) return;
    
    self.textView.text = nil;
    self.textView.textColor = [UIColor blackColor];
    if (self.textViewWrite) {
        CGFloat contentOffsetY = self.contentSize.height - self.height + 180;
        
        
        self.contentOffset = CGPointMake(0, contentOffsetY);
    }

}
/**
 *  输入框正在输入
 */
- (void)nowWrite1{
YYLog(@"输入正在输入");
        self.haveWriteText = YES;
}
/**
 *  输入框结束输入
 */
- (void)endWrite1{
YYLog(@"输入框结束输入");
    self.textViewWrite = NO;
    if (self.textView.text.length == 0){
        self.textView.text = placeholderStr;
        self.textView.textColor = YYGrayLineColor;
        self.haveWriteText = NO;
    }
    else{
        self.haveWriteText = YES;
    }
    
    CGFloat contentOffsetY = self.contentSize.height - self.height;

    self.contentOffset = CGPointMake(0, contentOffsetY);

    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   
    self.textViewWrite = YES;
    return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.textViewWrite = NO;
    return YES;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6 Plus";
    
    return nil;
}
#pragma mark 根据设备设置textView的高度
- (CGFloat)getTextViewHeight{
    NSString *deviceString = [YYTaobaoScrollerView deviceVersion];
    if ([deviceString isEqualToString:@"iPhone 4S"]) {
        return  70;
    }
    else if ([deviceString isEqualToString:@"iPhone 5"]){
        return  115;
    }
    else if ([deviceString isEqualToString:@"iPhone 6"]){
        return  190;
    }
    else if ([deviceString isEqualToString:@"iPhone 6 Plus"]){
        return  260;
    }
    return 140;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
