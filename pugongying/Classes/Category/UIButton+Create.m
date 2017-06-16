//
//  UIButton+Create.m
//  pugongying
//
//  Created by wyy on 16/5/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)
+ (instancetype)btnWithBGNorImgae:(UIImage *)norbgImage bgHighImage:(UIImage *)bgHighImage titleColor:(UIColor *)titleColor title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:norbgImage forState:UIControlStateNormal];
//    [btn setBackgroundImage:bgHighImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:bgHighImage forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    return btn;
    
}
+ (instancetype)btnWithBGNorImgae:(UIImage *)norbgImage bgHighImage:(UIImage *)bgHighImage titleNorColor:(UIColor *)titleNorColor titleSelColor:(UIColor *)titleSelColor title:(NSString *)title{
    UIButton *btn = [UIButton btnWithBGNorImgae:norbgImage bgHighImage:bgHighImage titleColor:titleNorColor title:title];
    
//    [btn setTitleColor:titleSelColor forState:UIControlStateHighlighted];
    [btn setTitleColor:titleSelColor forState:UIControlStateSelected];
    
    return btn;
}
@end
