//
//  YYPugongyingTool.m
//  pugongying
//
//  Created by wyy on 16/2/23.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYPugongyingTool.h"

@implementation YYPugongyingTool
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static YYPugongyingTool *pugongyingTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pugongyingTool = [super allocWithZone:zone];
    });
    return pugongyingTool;
}
+ (instancetype)shareFruitTool{
    return [[self alloc] init];
}
#pragma mark 添加线条
+ (void)addLineViewWithFrame:(CGRect)frame andView:(UIView *)superView{
    UIView *view = [[UIView alloc] init];
    [superView addSubview:view];
    view.frame = frame;
    view.backgroundColor = YYGrayLineColor;
}
#pragma mark 创建一个按钮并添加到父控件
+ (UIButton *)createBtnWithFrame:(CGRect)btnFrame superView:(UIView *)superView backgroundImage:(UIImage *)bgImage titleColor:(UIColor *)titleColor title:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [superView addSubview:btn];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    return btn;
}
#pragma mark 根据颜色创建图片
+ (UIImage*)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
