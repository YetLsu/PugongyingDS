//
//  YYPugongyingTool.h
//  pugongying
//
//  Created by wyy on 16/2/23.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYPugongyingTool : NSObject
+ (instancetype)shareFruitTool;
#pragma mark 根据颜色创建图片
+ (UIImage*)createImageWithColor:(UIColor *)color;
//在某个View上增加一条线
+ (void)addLineViewWithFrame:(CGRect)frame andView:(UIView *)superView;

/**
 *  创建一个按钮并添加到父控件
 */
+ (UIButton *)createBtnWithFrame:(CGRect)btnFrame superView:(UIView *)superView backgroundImage:(UIImage *)bgImage titleColor:(UIColor *)titleColor title:(NSString *)title;
@end
