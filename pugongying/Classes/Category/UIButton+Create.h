//
//  UIButton+Create.h
//  pugongying
//
//  Created by wyy on 16/5/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)
+ (instancetype)btnWithBGNorImgae:(UIImage *)norbgImage bgHighImage:(UIImage *)bgHighImage titleColor:(UIColor *)titleColor title:(NSString *)title;

+ (instancetype)btnWithBGNorImgae:(UIImage *)norbgImage bgHighImage:(UIImage *)bgHighImage titleNorColor:(UIColor *)titleNorColor titleSelColor:(UIColor *)titleSelColor title:(NSString *)title;
@end
